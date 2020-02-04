
typeof = 'minhash'
name = 'NIPS';
cent = 'uncentered';

patched_results.ord_RMSE = zeros(1000,30);
patched_results.MLE_RMSE = zeros(1000,30);
patched_results.prop_ord_id = zeros(4,20,1000,30);
patched_results.prop_MLE_id = zeros(4,20,1000,30);
patched_results.prop_ord_id_cumulative = zeros(4,20,1000,30);
patched_results.prop_MLE_id_cumulative = zeros(4,20,1000,30);

%patched_results.prop_ord_id_abs = zeros(4,20,1000,30);
%patched_results.prop_MLE_id_abs = zeros(4,20,1000,30);
%patched_results.prop_ord_id_cumulative_abs = zeros(4,20,1000,30);
%patched_results.prop_MLE_id_cumulative_abs = zeros(4,20,1000,30);

idx_start = 1:100:901;
idx_end = 100:100:1000;


file_to_load = [typeof, '_',name,'_',cent,'_FINAL'];

file_to_save = [typeof, '_', cent, '_',name, '_1000_iterations']


for j = 1:10
  
  if j < 10
  	filestr = [file_to_load, '0',num2str(j)];
  else
    filestr = [file_to_load, '10'];
  end
  load(filestr)
  ['patching ' filestr]
  % place here
	patched_results.ord_RMSE(idx_start(j):idx_end(j),:) = results.ord_RMSE;
	patched_results.MLE_RMSE(idx_start(j):idx_end(j),:) = results.MLE_RMSE;

	patched_results.prop_ord_id(:,:,idx_start(j):idx_end(j),:) = results.prop_ord_id;
	patched_results.prop_MLE_id(:,:,idx_start(j):idx_end(j),:) = results.prop_MLE_id;
	patched_results.prop_ord_id_cumulative(:,:,idx_start(j):idx_end(j),:) = results.prop_ord_id_cumulative;
	patched_results.prop_MLE_id_cumulative(:,:,idx_start(j):idx_end(j),:) = results.prop_MLE_id_cumulative;

%  patched_results.prop_ord_id_abs(:,:,idx_start(j):idx_end(j),:) = results.prop_ord_id_abs;
%  patched_results.prop_MLE_id_abs(:,:,idx_start(j):idx_end(j),:) = results.prop_MLE_id_abs;
%  patched_results.prop_ord_id_cumulative_abs(:,:,idx_start(j):idx_end(j),:) = results.prop_ord_id_cumulative_abs;
%  patched_results.prop_MLE_id_cumulative_abs(:,:,idx_start(j):idx_end(j),:) = results.prop_MLE_id_cumulative_abs;

  clear results;
end

results = patched_results;

save(file_to_save,'results')




