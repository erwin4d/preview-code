function [val] = get_hash_Y_passon(iterVals, para, X,writeto_info, results, compute_type)
 
  
  if strcmp(compute_type, 'update_results')

  	val = update_results_expt(iterVals,para,X,writeto_info, results);

  elseif strcmp(writeto_info.algo_name, 'SRP') || strcmp(writeto_info.algo_name, 'SBLSH')
    [val] = SRP_SBLSH_hash_info(iterVals, para, X, writeto_info, results, compute_type);
  elseif strcmp(writeto_info.algo_name, 'minhash') || strcmp(writeto_info.algo_name, 'bbit') 
    [val] = minwise_hash_info(iterVals, para, X, writeto_info, results, compute_type);
  end

end