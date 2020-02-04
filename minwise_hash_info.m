function [val] = minwise_hash_info(iterVals, para, X, writeto_info, results,compute_type)

  % Place the following here, generally in order
  %  - kvec_and_contingency table (initialize num hashes, table)
  %  - gen_extra_vec (type of extra_vec)
  %  - store_prob (store p_ie, p_je)
  %  - gen_Y (get Y after random hashes)
  %  - true_vals (compute true values of quantity of interest)
  %  - compute_ests (compute estimates using extra info)
  %  - convert_naive_prob_to_est (covert prob to estimates)
  %  - convert_better_prob_to_est (covert prob to estimates)

  if strcmp(compute_type, 'kvec_and_contingency')
    para.kvec = [100:100:3000]; 

    if para.b == 1
      para.is_bin = true;
    else
      para.is_bin = false
    end
    % partition resemblance in intervals of 0.05 
    para.partition_contingency_table = 20;
    para.val_vec = 0.05:0.05:1;
    val = para;
  
  elseif strcmp(compute_type, 'gen_extra_vec')
    
    % how should extra vector go? 

    % Then, find 
    val = zeros(1, size(X,2));
    medX = median(sum(X,2));
    sumX = sum(X,1);
    [tmp ind] = sort(sumX,'descend');
    val(ind(1:medX)) = 1;
    
 
    tmp_intersect = (X*transpose(val))';
    tmp_unioned = sum(bsxfun(@or, val,X),2)';
    tmp_res = tmp_intersect./ tmp_unioned;  

  elseif strcmp(compute_type, 'store_prob')
    % What p_xe is this algorithm storing?
    % See get_true_vals_algo.m where this is used.
    %  Given an extra vector e_{1 x p}, compute and store the true
    %  probability p(e,x_i) for all i
    % ordinary minhash
    val = (X * para.e')./sum(bitor(full(X), full(para.e)),2);
    if para.b > 0 % bbit
      b = para.b;
      r1 = full(sum(X,2))/para.p;
      r2 = sum(para.e)/para.p;
    
      A1 = r1 .* (1- r1).^(2^b - 1) ./ (1 - (1-r1).^(2^b));
      A2 = r2 .* (1- r2).^(2^b - 1)  ./ (1 - (1-r2).^(2^b));

      C1 = r2 .* A1 ./ (r1 + r2) + A2 .* r1 ./ (r1+r2);
      C2 = r1 .* A1 ./ (r1 + r2) + A2 .* r2 ./ (r1+r2);

      val = C1 + (1 - C2) .* val;
    end

  elseif strcmp(compute_type, 'create_results_vec')

  
    val.ord_RMSE = zeros(iterVals.max_iter,length(para.kvec));
    val.MLE_RMSE = zeros(iterVals.max_iter,length(para.kvec));
    val.prop_ord_id = zeros(4,length(para.val_vec), iterVals.max_iter, length(para.kvec));    
    val.prop_MLE_id = zeros(4,length(para.val_vec), iterVals.max_iter, length(para.kvec));
    val.prop_ord_id_cumulative = zeros(4,length(para.val_vec), iterVals.max_iter, length(para.kvec));
    val.prop_MLE_id_cumulative = zeros(4,length(para.val_vec), iterVals.max_iter, length(para.kvec));

  elseif strcmp(compute_type, 'gen_Y')
    % What smaller Y is this algorithm storing?

    k = para.K;
    p = para.p;
    n = para.N;
    val = zeros(size(X,1),k);
    for j = 1:k
      [~,val(:,j)] = max(X(:,randsample(p,p)),[],2);
    end
    val = reshape(val,size(val,1),para.kidx(1,3),size(para.kidx,1));

    if para.b > 0
      val = mod(val, 2^para.b);
    end

    if para.b == 1
      val(val == 0) = -1;
    end

  elseif strcmp(compute_type, 'true_vals')
    % What true_vals does this algorithm compute?
    %   In general, given two matrices X1_{n1 x p), X2_{n2 x p)} ; compute
    %   the true distance matrix D_{n1 x n2}, where d_{ij} is the distance
    %   between X1_{i.} and X2_{j.}

    % minhash / bbit computes resemblance
    Y1 = X(para.partition_start(iterVals.xseg):para.partition_end(iterVals.xseg),:);
    Y2 = X(para.partition_start(iterVals.yseg):para.partition_end(iterVals.yseg),:);

    intersected = full(Y1 *Y2');  
  
    unioned = zeros(iterVals.lenY1,iterVals.lenY2);
      
    for i = 1:iterVals.lenY1
      unioned(i,:) = sum(bsxfun(@or, (Y1(i,:)),(Y2)),2)';
    end

    val = intersected ./ unioned;
    % for 0/0 cases, i.e. must have zero resemblance
    val(isnan(val)) = 0;


  elseif strcmp(compute_type, 'compute_ests')
    % How are the estimates in contingency table computed?

    if para.b == 1
      val = compute_binary_extra_info(para, iterVals);
    elseif para.b ~=1 
      val = compute_discrete_extra_info(para, iterVals);
    end

  elseif strcmp(compute_type, 'convert_naive_prob_to_est') || strcmp(compute_type, 'convert_better_prob_to_est')

    if strcmp(compute_type, 'convert_naive_prob_to_est') 
      prob_to_use = iterVals.naive_prob;
    elseif strcmp(compute_type, 'convert_better_prob_to_est')
      prob_to_use = iterVals.better_prob;
    end

    if para.b == 0 % ordinary minhash
      val = prob_to_use;
    elseif para.b > 0 % bbit
      b = para.b;
      Y1 = X(para.partition_start(iterVals.xseg):para.partition_end(iterVals.xseg),:);
      Y2 = X(para.partition_start(iterVals.yseg):para.partition_end(iterVals.yseg),:);

      r1 = repmat(full(sum(Y1,2))/para.p,1,iterVals.lenY2);
      r2 = repmat((full(sum(Y2,2))/para.p)',iterVals.lenY1,1);

    
      A1 = r1 .* (1- r1).^(2^b - 1) ./ (1 - (1-r1).^(2^b));
      A2 = r2 .* (1- r2).^(2^b - 1)  ./ (1 - (1-r2).^(2^b));

      C1 = r2 .* A1 ./ (r1 + r2) + A2 .* r1 ./ (r1+r2);
      C2 = r1 .* A1 ./ (r1 + r2) + A2 .* r2 ./ (r1+r2);
      val = (prob_to_use - C1)./(1-C2);

      val(val > 1) = 1;
      val(val < 0) = 0;
      val(isnan(val)) = 0;
    else
     'error'
    end    
  elseif strcmp(compute_type, 'convert_naive_to_contingency')
    val = iterVals.sim_naive;
  elseif strcmp(compute_type, 'convert_better_to_contingency')
    val = iterVals.sim_better;
  elseif strcmp(compute_type, 'convert_true_to_contingency')
    val = iterVals.true_vals;
  end
end


