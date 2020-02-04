function [seed_array] = get_seed_num(sizeofX, starting_seed)
  
  rng(starting_seed);
  for j = 1:1000
  	j
    seed_array(j) = rng;
    normrnd(0,1,sizeofX,3000);
  end



end

