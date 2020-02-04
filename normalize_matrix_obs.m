function [ X_norm ] = normalize_matrix_obs( X )
  
  X_norm = X ./ sqrt(sum(X.^2,2));


end

