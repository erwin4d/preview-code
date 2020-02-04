% only plot RMSE


name1 = ' Arcene';
kvec = 100:100:3000;


%ybds2 = max([3*sqrt(var(SRP_results.ord_RMSE,0,1)), 3*sqrt(var(SRP_results.MLE_RMSE,0,1)),3*sqrt(var(SBLSH_results.ord_RMSE,0,1)),3*sqrt(var(SBLSH_results.MLE_RMSE,0,1))   ])
h(1) = subplot(1,2,1)

load('minhash_uncentered_NIPS_1000_iterations.mat');
SBLSH_results = results;

load('SRP_centered_KOS_1000_iterations.mat');
SRP_results = results;

clear results;

% want RMSE plot so...

SRP_ord = mean(SRP_results.ord_RMSE);
SRP_MLE = mean(SRP_results.MLE_RMSE);
SBLSH_ord = mean(SBLSH_results.ord_RMSE);
SBLSH_MLE = mean(SBLSH_results.MLE_RMSE);

ybds1 = max([SRP_ord,SRP_MLE,SBLSH_ord,SBLSH_MLE])

% x axis:

% Plot RMSE of angle
plot(kvec,SRP_ord, 'k', 'DisplayName', 'SRP'); hold all
grid on;
plot(kvec,SRP_MLE, '--k', 'DisplayName', 'SRP with MLE');
plot(kvec,SBLSH_ord, 'b', 'DisplayName', 'SBLSH');
plot(kvec,SBLSH_MLE, '--b', 'DisplayName', 'SBLSH with MLE');

title(['RMSE for', name1, ' (Centered)'], 'FontWeight', 'bold','FontSize', 30);
xlabel('Number of columns k', 'FontWeight', 'bold','FontSize', 30);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 25)
ylabel('Average RMSE', 'FontWeight', 'bold','FontSize', 30);
yt = get(gca, 'YTick');
set(gca, 'FontSize', 25)

lgd = legend('-DynamicLegend', 'location', 'northeast');
lgd.FontSize = 25;
xlim([100,3000])
ylim([0,ybds1+0.01])


h(2) = subplot(1,2,2)

load('SBLSH_uncentered_arcene_1000_iterations.mat');
SBLSH_results = results;

load('SRP_uncentered_arcene_1000_iterations.mat');
SRP_results = results;


clear results;

% want RMSE plot so...

SRP_ord = mean(SRP_results.ord_RMSE);
SRP_MLE = mean(SRP_results.MLE_RMSE);
SBLSH_ord = mean(SBLSH_results.ord_RMSE);
SBLSH_MLE = mean(SBLSH_results.MLE_RMSE);

ybds1 = max([SRP_ord,SRP_MLE,SBLSH_ord,SBLSH_MLE])

% x axis:

% Plot RMSE of angle
plot(kvec,SRP_ord, 'k', 'DisplayName', 'SRP'); hold all
grid on;
plot(kvec,SRP_MLE, '--k', 'DisplayName', 'SRP with MLE');
plot(kvec,SBLSH_ord, 'b', 'DisplayName', 'SBLSH');
plot(kvec,SBLSH_MLE, '--b', 'DisplayName', 'SBLSH with MLE');

title(['RMSE for', name1, ' (Uncentered)'], 'FontWeight', 'bold','FontSize', 30);
xlabel('Number of columns k', 'FontWeight', 'bold','FontSize', 30);
xt = get(gca, 'XTick');
set(gca, 'FontSize', 25)
%ylabel('Average RMSE', 'FontWeight', 'bold','FontSize', 30);
yt = get(gca, 'YTick');
set(gca, 'FontSize', 25)

lgd = legend('-DynamicLegend', 'location', 'northeast');
lgd.FontSize = 25;
xlim([100,3000])
ylim([0,ybds1+0.01])



set(h(1), 'position', [0.0570 0.1400 0.18 0.7932] );
set(h(2), 'position', [0.2970 0.1400 0.18 0.7932] );
set(h(3), 'position', [0.5370 0.1400 0.18 0.7932] );
set(h(4), 'position', [0.7770 0.1400 0.18 0.7932] );
