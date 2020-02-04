function [iterVals] = newton_raphson_for_binary_prob(iterVals)
  
  nA = iterVals.small_nA;
  nB = iterVals.small_nB;
  nC = iterVals.small_nC;
  nD = iterVals.small_nD;

  p_je = iterVals.p_je;
  p_ie = iterVals.p_ie; 


  TOL = 1e-8;          % Initialize tolerance
  max_iter = 100;      % and max iterations
  iter = 0;            % and starting number of iter


  tot_size = prod(size(nA));
  orig_size = size(nA);

  nA = reshape(nA, 1, tot_size);
  nB = reshape(nB, 1, tot_size);
  nC = reshape(nC, 1, tot_size);
  nD = reshape(nD, 1, tot_size);
  p_je = reshape(p_je, 1, tot_size);
  p_ie = reshape(p_ie, 1, tot_size);

  % find zeroidx
  un1 = union(find(nA == 0), find(nB == 0));
  un2 = union(find(nC == 0), find(nD == 0));
  badvaridx = union(un1,un2);


  a_now = ones(1,tot_size) .* nC./(nA+nB+nC+nD);

  len_a = length(nA);

  a_prev = zeros(1, len_a);

  % Terminate also when no more elements to do NR over 
  is_term = len_a;
  
  % Check number of idxes to go ; we stop iterating an element when TOL is met
  idx_to_go = 1:len_a;

  while is_term > 0 && iter < max_iter

    iter = iter + 1;
    
    % Update the indexes where we need to continue doing NR

    % Update steps
    % Gotta ifcheck for appropriate idx_to_go (above >0 or not)
    a_prev(idx_to_go) = a_now(idx_to_go);

	  [ fx, dfx ] = local_NR_for_pC( a_now(idx_to_go), nA(idx_to_go), nB(idx_to_go), nC(idx_to_go), nD(idx_to_go), p_ie(idx_to_go), p_je(idx_to_go));       

	    a_now(idx_to_go) = a_now(idx_to_go) - fx./dfx;

	    % check which points to still iterate on    
	    idx_to_go = idx_to_go(abs(a_now(idx_to_go) - a_prev(idx_to_go)) > TOL);
	  
    is_term = length(idx_to_go) ;%+ length(idx_to_go_theta2);

  end

  pB = 1 + a_now - p_ie - p_je;
  
  iterVals.better_prob = pB + a_now;
  naive_prob = reshape(iterVals.naive_prob, 1, tot_size);

  iterVals.better_prob(idx_to_go) = naive_prob(idx_to_go);
  iterVals.better_prob(badvaridx) = naive_prob(badvaridx);

  iterVals.better_prob(isnan(iterVals.better_prob)) = naive_prob(isnan(iterVals.better_prob));
  iterVals.better_prob(iterVals.better_prob < 0) = 0;
  iterVals.better_prob(iterVals.better_prob > 1) = 1;

  
  iterVals.better_prob = reshape(iterVals.better_prob, orig_size);
  
  % converge to wrong root
  %this_est.better_prob(this_est.better_prob < 0) = this_est.naive_prob(this_est.better_prob < 0);
  %this_est.better_prob(this_est.better_prob > 1) = this_est.naive_prob(this_est.better_prob > 1);

end



function [ fx, dfx ] = local_NR_for_pC( pC, nA, nB, nC, nD, p_ie, p_je )


  a3coef = (nA + nB + nC + nD);



  a2coef = nC + nD - nB .* p_ie - 2 * nC .* p_ie - nD .*p_ie - nB .*p_je - 2 * nC .* p_je - 2 * nD .* p_je -  nA .* (-1 + 2 * p_ie + p_je);


  a1coef = nA .* p_ie .* (-1 + p_ie + p_je) + p_je .* (nB .* p_ie + nD .* (-1 + p_ie + p_je)) +  nC.* (p_ie.^2 + (-1 + p_je) .* p_je + p_ie .* (-1 + 3 * p_je));


  a0coef = -nC .* p_ie .* p_je .* (-1 + p_ie + p_je);


  fx = a3coef .* pC.^3 + a2coef .* pC.^2  + pC .* a1coef + a0coef;
  dfx = 3 * a3coef .* pC.^2 + 2 * (pC .* a2coef) +a1coef;

end
