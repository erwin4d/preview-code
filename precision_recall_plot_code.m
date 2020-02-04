% only plot RMSE, not relative RMSE, since our estimates range from -1 to 1.

name1 = 'arcene';
name = 'Arcene';

%% What's the best way to plot this over 3 dimensions?
%%

[prec_100, prec_sd_100, recall_100, recall_sd_100] = find_prec_recall(results.prop_ord_id, results.prop_MLE_id, 100)

[prec_200, prec_sd_200, recall_200, recall_sd_200] = find_prec_recall(results.prop_ord_id, results.prop_MLE_id, 200)

[prec_500, prec_sd_500, recall_500, recall_sd_500] = find_prec_recall(results.prop_ord_id, results.prop_MLE_id, 500)

[prec_1000, prec_sd_1000, recall_1000, recall_sd_1000] = find_prec_recall(results.prop_ord_id, results.prop_MLE_id, 1000)

[prec_1500, prec_sd_1500, recall_1500, recall_sd_1500] = find_prec_recall(results.prop_ord_id, results.prop_MLE_id, 1500)

[prec_2000, prec_sd_2000, recall_2000, recall_sd_2000] = find_prec_recall(results.prop_ord_id, results.prop_MLE_id, 2000)

[prec_2500, prec_sd_2500, recall_2500, recall_sd_2500] = find_prec_recall(results.prop_ord_id, results.prop_MLE_id, 2500)

[prec_3000, prec_sd_3000, recall_3000, recall_sd_3000] = find_prec_recall(results.prop_ord_id, results.prop_MLE_id, 3000)




%set(h(1), 'position', [0.0545 0.5500 0.125 0.3900] );
%set(h(2), 'position', [0.2145 0.5500 0.125 0.3900] );
%set(h(3), 'position', [0.3745 0.5500 0.125 0.3900] );
%set(h(4), 'position', [0.5495 0.5500 0.120 0.3900] );
%set(h(5), 'position', [0.7075 0.5500 0.120 0.3900] );
%set(h(6), 'position', [0.8675 0.5500 0.120 0.3900] );


