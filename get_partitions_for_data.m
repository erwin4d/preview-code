function [para] = get_partitions_for_data(para, kvec)

  para.partition_start = 1:para.partition:para.N;
  para.partition_end = para.partition:para.partition:para.N;

  if(para.partition_end(end)) ~= para.N
    para.partition_end = [para.partition_end, para.N];
  end
  para.kidx = zeros(length(kvec),3);
  para.kidx(:,3) = kvec - [0 kvec(1:end-1)];
  para.kidx(:,1) = [0 kvec(1:end-1)] + 1; % start pos
  para.kidx(:,2) = kvec;

end
  