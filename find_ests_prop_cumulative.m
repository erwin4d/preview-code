function [prop_arr] = find_ests_prop_cumulative(true_sim, est_sim, is_diag,val_vec)

  prop_arr = zeros(4,length(val_vec));

  if is_diag == true
    true_val = (triu(true_sim,1));
    est_val = (triu(est_sim,1));

    true_val_t = true_val.';
    tm = tril(true(size(true_val_t)),-1);
    true_val = true_val_t(tm).';

    est_val_t = est_val.';
    tm = tril(true(size(est_val_t)),-1);
    est_val = est_val_t(tm).';    
  else    
    true_val = (reshape(true_sim,1,size(true_sim,1) * size(true_sim,2)));
    est_val = (reshape(est_sim,1,size(est_sim,1) * size(est_sim,2)));

    true_val = (true_sim);
    est_val = (est_sim);
  end        
  
  for val_num = 1:length(val_vec);
    %true_pos_idx = find((true_val < val_vec(val_num)) == 1);
    %true_neg_idx = setdiff(1:length(true_val), true_pos_idx);
    %est_pos_idx = find((est_val < val_vec(val_num)) == 1);
    %est_neg_idx = setdiff(1:length(est_val), est_pos_idx);

    true_pos_idx = true_val < val_vec(val_num);
    est_pos_idx = est_val < val_vec(val_num);

    prop_arr(1,val_num) = length(find(true_pos_idx == 1 & est_pos_idx == 1)); % is pos, pred pos
    prop_arr(2,val_num) = length(find(true_pos_idx == 0 & est_pos_idx == 1)); % is neg, pred pos
    prop_arr(3,val_num) = length(find(true_pos_idx == 1 & est_pos_idx == 0)); % is pos, pred neg
    prop_arr(4,val_num) = length(find(true_pos_idx == 0 & est_pos_idx == 0)); % is neg, pred neg

    
    %prop_arr(1,val_num) = length(intersect(true_pos_idx, est_pos_idx)); % is pos, pred pos
    %prop_arr(2,val_num) = length(intersect(true_neg_idx, est_pos_idx)); % is neg, pred pos
    %prop_arr(3,val_num) = length(intersect(true_pos_idx, est_neg_idx)); % is pos, pred neg
    %prop_arr(4,val_num) = length(intersect(true_neg_idx, est_neg_idx)); % is neg, pred neg

  end

end





