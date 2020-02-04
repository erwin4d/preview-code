

parpool

% arcene has 10000 elements ; starting seed of 0
[seed_array] = get_seed_num(10000, 0) 

% assume X is a n by p dataset, n = 900 observations, p = 10000 features

parfor i = 1:10
    if i == 1
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '01', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '01', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '01', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '01', false);
    elseif i == 2
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '02', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '02', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '02', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '02', false);
    elseif i == 3
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '03', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '03', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '03', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '03', false);
    elseif i == 4
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '04', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '04', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '04', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '04', false);
    elseif i == 5
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '05', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '05', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '05', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '05', false);
    elseif i == 6
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '06', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '06', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '06', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '06', false);
    elseif i == 7
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '07', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '07', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '07', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '07', false); 
    elseif i == 8
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '08', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '08', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '08', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '08', false);
    elseif i == 9
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '09', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '09', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '09', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '09', false);
    elseif i == 10
      i
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '10', true);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '10', true);
    [results] = run_expt_parallel(X,'arcene', 'SRP', seed_array((i-1)*100 + 1), '10', false);
    [results] = run_expt_parallel(X,'arcene', 'SBLSH', seed_array((i-1)*100 + 1), '10', false);
    end
end





