function [rmse] = find_generic_rmse(curr_est, true_val, is_diag)
 

  if is_diag == true
    rmse = sum(sum((triu(curr_est,1) - triu(true_val,1)).^2));
  else
    rmse = sum(sum((curr_est - true_val).^2));
  end        


end
      
  