function [results] = run_expt(data_name, algo_name, seed_num, savefilename)

  % Please verify with your own datasets and hashing algorithms!
  % Please cite this code if you use it, thanks!
  
  rng(seed_num);
  clear seed_num;
  % Set up some structures
  iterVals.max_iter = 100;
  iterVals.iter_num = 0;
  iterVals.xseg = 0;  
  iterVals.yseg = 0;  

  % choose b for bbit
  para.b = 0; % 0 means ignore, otherwise b = 1,2,3 .. is bbit 
  
  % We give this framework to demonstrate this datasets and
  % hashing algorithm of choice

  % Inputs: data_name - string, loads appropriate datafile (see below)
  %          we have given a few examples, but feel free to add
  %          your own. 
  %          Data files are not provided, but they can be
  %          downloaded from UCI machine learning repository
  %
  %         algo_name - name of hashing algorithm, used in several
  %                     helper functions below
  %
  %                     valid names: 'SRP', 'SBLSH', 'minhash', 'bbit"

  % Note that rows of X denote observations, p denote parameters
  

  writeto_info.algo_name = algo_name;
  para.algo_name = algo_name;
  writeto_info.data_name = data_name;
  
  clear algo_name;
  clear data_name;
  
  
  % Do any relevant data pre-processing here
  %data_type = 'ordinary';
  if strcmp(writeto_info.data_name, 'kos')
    X = load_kos();
    % word data uncentered 
    writeto_info.cent_text = 'uncentered'
    X = sparse(X);


  elseif strcmp(writeto_info.data_name, 'nips')
    X = load_nips();
    % word data uncentered
    writeto_info.cent_text = 'uncentered'


  elseif strcmp(writeto_info.data_name, 'arcene')
    X1 = sparse(feval('load', 'arcene_train.data'));
    X2 = sparse(feval('load', 'arcene_valid.data'));
    X3 = sparse(feval('load', 'arcene_test.data'));

    X = [X1;X2;X3];
    clear X1;
    clear X2;
    clear X3;

    writeto_info.cent_text = 'uncentered'
    %X = X - mean(X,1);
    X = normalize_matrix_obs(X);  
    X = full(X);
  elseif strcmp(writeto_info.data_name, 'gisette')
    XTrain = sparse(feval('load', 'gisette_train.data'));
    XTest = sparse(feval('load', 'gisette_test.data'));
    XValid = sparse(feval('load', 'gisette_valid.data'));
    X = [XTrain ; XTest ; XValid];
    clear XTrain;
    clear XTest;
    clear XValid;
    % Normalize the matrix
    
    % note: Normalizing does not affect angles between vectors
    X = normalize_matrix_obs(X);  
    X = full(X);
    writeto_info.cent_text = 'uncentered'
  elseif strcmp(writeto_info.data_name, 'mnist')
    X = loadMNISTImages('t10k-images-idx3-ubyte')';
    writeto_info.cent_text = 'uncentered'
  end    


  % initialize the num observations and num rows

  para.N = size(X,1);
  para.p = size(X,2);
    
  % kvec really depends on hashing algorithm - probably should tweak this
  % Note: small kvec can cause our MLE to go haywire

  [para] = get_hash_Y_passon(iterVals, para, X,writeto_info, [], 'kvec_and_contingency');

  % Generate extra vector here
  [para.e] = get_hash_Y_passon(iterVals, para, X,writeto_info, [], 'gen_extra_vec');

%   
  % Normalize the matrix
  
  % note: Normalizing does not affect angles between vectors
  %X = normalize_matrix_obs(X);  
  %X = full(X);


  % Store probabilities here

  [para.stored_prob] = get_hash_Y_passon(iterVals, para, X,writeto_info, [], 'store_prob');
 



  % Note: Partition here is the size of matrices we'll vectorize
  %       at once. Set to 250 for large datasets.
  
  
  para.partition = min(250, para.N);

  % Get the partition indexes
  [para] = get_partitions_for_data(para, para.kvec);

  
  para.K = max(para.kvec);
  
  % Matrix to store the results

  [results] = get_hash_Y_passon(iterVals, para, X,writeto_info, [], 'create_results_vec');
 


  % Total number of pairwise similarities we check. Not including diagonal.

  para.tot_num = (para.N*(para.N-1))/2; 
  


  for iter_num = 1:iterVals.max_iter;
    %iter_num
    iterVals.iter_num = iter_num;

    iterVals.Y = get_hash_Y_passon(iterVals, para, [X; para.e],writeto_info, 'gen_Y');
    iterVals.e = iterVals.Y(end,:,:);
    
    for xseg = 1:length(para.partition_start)
      iterVals.xseg = xseg;
      disp(['iter_num is ', num2str(iterVals.iter_num)  '  xseg is ', num2str(iterVals.xseg)])
      iterVals.Y1 =  iterVals.Y(para.partition_start(iterVals.xseg):para.partition_end(iterVals.xseg),:,:);
      iterVals.lenY1 = size(iterVals.Y1,1);
      for yseg = iterVals.xseg:length(para.partition_start)
        iterVals.yseg = yseg;
        iterVals.Y2 =  iterVals.Y(para.partition_start(iterVals.yseg):para.partition_end(iterVals.yseg),:,:);
        iterVals.lenY2 = size(iterVals.Y2,1);

        % Goal here is to vectorize everything.
        % So we create "block" values of what we want
        %    i.e. true_val, pie, pje, nA, nB, nC, nD

        % what is the true value?
        [iterVals.true_vals] = get_hash_Y_passon(iterVals, para, X,writeto_info, [], 'true_vals');

        iterVals.p_ie = repmat(para.stored_prob(para.partition_start(iterVals.xseg):para.partition_end(iterVals.xseg)),1,iterVals.lenY2);
        iterVals.p_je = repmat(para.stored_prob(para.partition_start(iterVals.yseg):para.partition_end(iterVals.yseg))',iterVals.lenY1,1);

        % Motivation for para.kidx
        % We don't want to duplicate computations
        
        % so compute each partition of k before using cumsum
        % Only need: nA, nB, nC, nD really..
                  
        iterVals.nA = zeros(iterVals.lenY1, iterVals.lenY2, size(para.kidx,1));
        iterVals.nB = iterVals.nA;
        iterVals.nC = iterVals.nA;
        iterVals.nD = iterVals.nA;
        if para.is_bin == false
          iterVals.nE = iterVals.nA;
        end

        % Now, compute each individual parts. 
        for kvals = 1:length(para.kvec)   
          iterVals.kvals = kvals;      
          [iterVals] = get_hash_Y_passon(iterVals, para, X, writeto_info, [], 'compute_ests');
        end
        
        iterVals.nA = cumsum(iterVals.nA,3);         
        iterVals.nB = cumsum(iterVals.nB,3);
        iterVals.nC = cumsum(iterVals.nC,3);
        iterVals.nD = cumsum(iterVals.nD,3);
        if para.is_bin == false
          iterVals.nE = cumsum(iterVals.nE,3);
        end
        

        for kvals = 1:length(para.kvec) 
          iterVals.kvals = kvals; 
          % Now, record each estimate
            
          if para.is_bin == false
            iterVals.naive_prob = (iterVals.nA(:,:,kvals) + iterVals.nD(:,:,kvals)) / para.kvec(kvals);
          elseif para.is_bin == true
              iterVals.naive_prob = (iterVals.nB(:,:,kvals) + iterVals.nC(:,:,kvals)) / para.kvec(kvals);
          end

          iterVals.small_nA = iterVals.nA(:,:,kvals);
          iterVals.small_nB = iterVals.nB(:,:,kvals);
          iterVals.small_nC = iterVals.nC(:,:,kvals);
          iterVals.small_nD = iterVals.nD(:,:,kvals);
          
          if para.is_bin == false
            iterVals.small_nE = iterVals.nE(:,:,kvals);
            [iterVals] = newton_raphson_for_discrete_prob(iterVals);
          elseif para.is_bin == true
            [iterVals] = newton_raphson_for_binary_prob(iterVals);
          end


          
          [iterVals.sim_naive] = get_hash_Y_passon(iterVals, para, X,writeto_info, [], 'convert_naive_prob_to_est');

          [iterVals.sim_better] = get_hash_Y_passon(iterVals, para, X,writeto_info, [], 'convert_better_prob_to_est');

          [results] = get_hash_Y_passon(iterVals, para, X,writeto_info, results, 'update_results');

        end
      end
    end

    for kvals = 1:length(para.kvec)  

      results.ord_RMSE(iter_num,kvals)  = sqrt(results.ord_RMSE(iter_num,kvals)  / para.tot_num);
      results.MLE_RMSE(iter_num,kvals) = sqrt(results.MLE_RMSE(iter_num,kvals) / para.tot_num);
    end

    if mod(iter_num,10) == 0;
      save([writeto_info.algo_name, '_', writeto_info.data_name,'_', writeto_info.cent_text, '_', savefilename, '_', num2str(iter_num), 'iterations'],'results');
    end

  end
  
  save([writeto_info.algo_name, '_', writeto_info.data_name,'_', writeto_info.cent_text, '_', savefilename, '_FINAL'],'results');

end






