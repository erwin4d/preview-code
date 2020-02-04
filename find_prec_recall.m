function [prec, prec_sd, recall, recall_sd] = find_prec_recall(prop_array_ord, prop_array_MLE, k)
  
  k_idx = k/100;

  % TP    /   TP + FP (precision)
  % TP    /   TP + FN (recall)

  % 1 - TP
  % 2 - FP
  % 3 - FN
  % 4 - TN
    
  prec_ord = prop_array_ord(1,:,:,:) ./ (prop_array_ord(1,:,:,:) + prop_array_ord(2,:,:,:));
  prec_sd_ord = 3*std(squeeze(prec_ord(:,:,:,k_idx))');
  prec_ord = mean(squeeze(prec_ord(:,:,:,k_idx))');

  recall_ord = prop_array_ord(1,:,:,:) ./ (prop_array_ord(1,:,:,:) + prop_array_ord(3,:,:,:));
  recall_sd_ord = 3*std(squeeze(recall_ord(:,:,:,k_idx))');
  recall_ord = mean(squeeze(recall_ord(:,:,:,k_idx))');

  prec_MLE = prop_array_MLE(1,:,:,:) ./ (prop_array_MLE(1,:,:,:) + prop_array_MLE(2,:,:,:));
  prec_sd_MLE = 3*std(squeeze(prec_MLE(:,:,:,k_idx))');
  prec_MLE = mean(squeeze(prec_MLE(:,:,:,k_idx))');

  recall_MLE = prop_array_MLE(1,:,:,:) ./ (prop_array_MLE(1,:,:,:) + prop_array_MLE(3,:,:,:));
  recall_sd_MLE = 3*std(squeeze(recall_MLE(:,:,:,k_idx))');
  recall_MLE = mean(squeeze(recall_MLE(:,:,:,k_idx))');
  
  prec = [prec_ord ; prec_MLE];
  prec_sd = [prec_sd_ord ; prec_sd_MLE];
  recall = [recall_ord ; recall_MLE];
  recall_sd = [prec_sd_MLE ; recall_sd_MLE];
  
end
