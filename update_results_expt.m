function [results] = update_results_expt(iterVals,para,X,writeto_info, results)
 

    expr = iterVals.xseg == iterVals.yseg;

    iter_num = iterVals.iter_num;
    kvals = iterVals.kvals;

    results.ord_RMSE(iter_num,kvals) = results.ord_RMSE(iter_num,kvals) + find_generic_rmse(iterVals.sim_naive, iterVals.true_vals, expr);

    results.MLE_RMSE(iter_num,kvals) = results.MLE_RMSE(iter_num,kvals) + find_generic_rmse(iterVals.sim_better, iterVals.true_vals, expr);


    iterVals.naive_contingency = get_hash_Y_passon(iterVals, [], [],writeto_info, [], 'convert_naive_to_contingency');
    iterVals.better_contingency = get_hash_Y_passon(iterVals, [], [],writeto_info, [], 'convert_better_to_contingency');
    iterVals.true_contingency = get_hash_Y_passon(iterVals, [], [],writeto_info, [], 'convert_true_to_contingency');
        

    results.prop_ord_id(:,:,iter_num,kvals) = results.prop_ord_id(:,:,iter_num,kvals) + find_ests_prop(iterVals.true_contingency, iterVals.naive_contingency, expr, para.val_vec);
    results.prop_MLE_id(:,:,iter_num,kvals) = results.prop_MLE_id(:,:,iter_num,kvals) + find_ests_prop(iterVals.true_contingency, iterVals.better_contingency, expr,para.val_vec);

    results.prop_ord_id_cumulative(:,:,iter_num,kvals) = results.prop_ord_id_cumulative(:,:,iter_num,kvals) + find_ests_prop_cumulative(iterVals.true_contingency, iterVals.naive_contingency, expr,para.val_vec);
    results.prop_MLE_id_cumulative(:,:,iter_num,kvals) = results.prop_MLE_id_cumulative(:,:,iter_num,kvals) + find_ests_prop_cumulative(iterVals.true_contingency, iterVals.better_contingency, expr,para.val_vec);   

    if strcmp(writeto_info.algo_name, 'SRP') || strcmp(writeto_info.algo_name, 'SBLSH')
      results.prop_ord_id_abs(:,:,iter_num,kvals) = results.prop_ord_id_abs(:,:,iter_num,kvals) + find_ests_prop(abs(iterVals.true_contingency), abs(iterVals.naive_contingency), expr, para.val_vec_abs);
      results.prop_MLE_id_abs(:,:,iter_num,kvals) = results.prop_MLE_id_abs(:,:,iter_num,kvals) + find_ests_prop(abs(iterVals.true_contingency), abs(iterVals.better_contingency), expr,para.val_vec_abs);

      results.prop_ord_id_cumulative_abs(:,:,iter_num,kvals) = results.prop_ord_id_cumulative_abs(:,:,iter_num,kvals) + find_ests_prop_cumulative(abs(iterVals.true_contingency), abs(iterVals.naive_contingency), expr,para.val_vec_abs);
      results.prop_MLE_id_cumulative_abs(:,:,iter_num,kvals) = results.prop_MLE_id_cumulative_abs(:,:,iter_num,kvals) + find_ests_prop_cumulative(abs(iterVals.true_contingency), abs(iterVals.better_contingency), expr,para.val_vec_abs);   
    end
    
end


