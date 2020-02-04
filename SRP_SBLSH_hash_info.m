function [val] = SRP_SBLSH_hash_info(iterVals, para, X, writeto_info, results, compute_type)
  
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

    % for SRP, use up to 2000 hashes
    para.kvec = [100:100:3000]; 
    para.is_bin = true;
    para.val_vec = -0.95:0.05:1;
    para.val_vec_abs = 0.05:0.05:1;
    val = para;

  elseif strcmp(compute_type, 'gen_extra_vec')
    
    % default use first eigenvector
    % question: is there a better direction?

    [~,~,val] = svds(X,1);
    val = val';

  elseif strcmp(compute_type, 'store_prob')

    % What p_xe is this algorithm storing?
    %  Given an extra vector e_{1 x p}, compute and store the true
    %  probability p(e,x_i) for all i
    
    tmp_val = acos(X* para.e');
    val = 1 - tmp_val/pi;

  elseif strcmp(compute_type, 'create_results_vec')

  
    val.ord_RMSE = zeros(iterVals.max_iter,length(para.kvec));
    val.MLE_RMSE = zeros(iterVals.max_iter,length(para.kvec));
    val.prop_ord_id = zeros(4,length(para.val_vec), iterVals.max_iter, length(para.kvec));    
    val.prop_MLE_id = zeros(4,length(para.val_vec), iterVals.max_iter, length(para.kvec));
    val.prop_ord_id_cumulative = zeros(4,length(para.val_vec), iterVals.max_iter, length(para.kvec));
    val.prop_MLE_id_cumulative = zeros(4,length(para.val_vec), iterVals.max_iter, length(para.kvec));

    val.prop_ord_id_abs = zeros(4,length(para.val_vec_abs), iterVals.max_iter, length(para.kvec));
    val.prop_MLE_id_abs = zeros(4,length(para.val_vec_abs), iterVals.max_iter, length(para.kvec));
    val.prop_ord_id_cumulative_abs = zeros(4,length(para.val_vec_abs), iterVals.max_iter, length(para.kvec));
    val.prop_MLE_id_cumulative_abs = zeros(4,length(para.val_vec_abs), iterVals.max_iter, length(para.kvec));
  

  elseif strcmp(compute_type, 'gen_Y')

    % What smaller Y is this algorithm storing?
      
      k = para.K;
      p = para.p;
      R_ord = normrnd(0,1, p,k);
    if strcmp(para.algo_name, 'SRP')
      val = sign(X * R_ord);
      val = reshape(val,size(val,1),para.kidx(1,3),size(para.kidx,1));
    elseif strcmp(para.algo_name, 'SBLSH')
      R = normalize_matrix_obs(R_ord);
      if k <= p;
        [R_new, ~] = qr(R,0);
      else
        % for small-ish datasets
        L = floor(k/p);
        N = p;
        R_new = zeros(p, k);
        for j = 1:L % number of super bit depths
          [R_new(:,((j-1)*p + 1):j*p),~] = qr(R(:,((j-1)*p + 1):j*p),0);
        end    
        if (j*p+1 <= k)
          [R_new(:,j*p+1:end),~] = qr(R(:, j*p+1:end),0);
        end
      end
      val = sign(X * R_new);
      val = reshape(val,size(val,1),para.kidx(1,3),size(para.kidx,1));
    end

  elseif strcmp(compute_type, 'true_vals')
    % What true_vals does this algorithm compute?
    %   In general, given two matrices X1_{n1 x p), X2_{n2 x p)} ; compute
    %   the true distance matrix D_{n1 x n2}, where d_{ij} is the distance
    %   between X1_{i.} and X2_{j.}

    % SRP / SBLSH computes the angle
    tmp_store = X(para.partition_start(iterVals.xseg):para.partition_end(iterVals.xseg),:) * X(para.partition_start(iterVals.yseg):para.partition_end(iterVals.yseg),:)';
    tmp_store(tmp_store > 1) = 1;
    tmp_store(tmp_store < -1) = -1;
     
    val = acos(tmp_store);

  elseif strcmp(compute_type, 'compute_ests')
    % How are the estimates in contingency table computed?
    val = compute_binary_extra_info(para, iterVals);
  elseif strcmp(compute_type, 'convert_naive_prob_to_est') || strcmp(compute_type, 'convert_better_prob_to_est')

    if strcmp(compute_type, 'convert_naive_prob_to_est') 
      prob_to_use = iterVals.naive_prob;
    elseif strcmp(compute_type, 'convert_better_prob_to_est')
      prob_to_use = iterVals.better_prob;
    end
    val = pi * (1 - prob_to_use);
  elseif strcmp(compute_type, 'convert_naive_to_contingency')
    val = (cos(iterVals.sim_naive));
  elseif strcmp(compute_type, 'convert_better_to_contingency')
    val = (cos(iterVals.sim_better));
  elseif strcmp(compute_type, 'convert_true_to_contingency')
    val = (cos(iterVals.true_vals));
  end
end


