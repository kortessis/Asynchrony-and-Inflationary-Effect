% Stochastic 2-patch model of infectious disease growth

clear
clc

colors = viridis(4); colors = colors(2:3,:);

inf_duration = 4.5; % Number of days infectious
gamma = 1/inf_duration; % Recovery rate
beta0 = 0.375; % Transmission rate per contact
epsilon = 0.95; % Proportional reduction in transmission
betaNPI = beta0*(1-epsilon);

% Movement rate
m = 0.025;

% r = infectious class growth rate in any given time
rBusUsual = beta0 - gamma; % Business as usual rate of infectious spread
rNPI = betaNPI - gamma; % Same when NPIs implemented

% Square wave function

% Set the length of NPIs and "opening up" as 30 days. A whole period of the
% square wave is then 60 days.
period = 60; % Period length in units of days; needs to be even
num_per = 3; % Number of periods to cycle

% Error catch if the period is set to an odd number of days.
if rem(period,2) > 0
    disp('Period not even; Choose even period')
end

% Consider two overlaps, 0 and 1.
overlap = [1,0.5];
% This is the day difference in policy enaction
tau = floor(period*(1 - overlap)/2);

% Variance in the stocahstic component of beta
rng default

% Variance-covariance matrix. Set to have independent stochastic variation
% across the two patches.
variance = 0.01;
sigma = variance*eye(2);
R = chol(sigma);
% e is the residual "error" in beta.
e = randn(period*num_per,2)*R;

figure(1)
figure(2)
figure(3)

% Initial infectious
I_init = 5*ones(1,2);

cum_I = sum(I_init);

plotindx = [1,3;2,4];

for i = 1:length(overlap)
    % Patch one switches to social distancing on day period/2 + 1;
    % Patch two switches to social distancing on day tau + 1
    patch1beta = [beta0*ones(period/2,1); betaNPI*ones(period/2,1)];
    patch2beta = [beta0*ones(period/2 -tau(i),1);...
        betaNPI*ones(period/2,1);beta0*ones(tau(i),1)];
    
    detbeta = [patch1beta, patch2beta]; 
    detbeta = repmat(detbeta, num_per, 1);

    beta_stoc = detbeta + e;
    beta_stoc(beta_stoc < 0) = 0;

    % This creates a discrete-time growth rate for infectious individuals
    lambdat = exp(beta_stoc - gamma);

    I = zeros(period*num_per, 2);
    I(1,:) = I_init;

    for t = 2:period*num_per
        Iprime = lambdat(t-1,:).*I(t-1,:);
        I(t,:) = Iprime*[1-m, m; m, 1-m];
        cum_I(t) = cum_I(t-1) + sum(I(t,:));
    end

    if overlap(i) == 1
        FontType = '--';
    else
        FontType = '-';
    end

    figure(1)
    hold on
    plot(1:size(I,1), sum(I,2)/1000, FontType, 'Color', 'black', ...
        'LineWidth', 3)
    hold off

    figure(2)
    hold on
    plot(1:size(I,1), cum_I/1000, FontType, 'Color', 'black', ...
        'LineWidth', 3)
    hold off

    figure(3)
    subplot(2,2,plotindx(i,1))
    p = plot(beta_stoc);
    set(p, {'Color'}, num2cell(colors,2));

    figure(3)
    subplot(2,2,plotindx(i,2))
    p = scatter(beta_stoc(:,1), beta_stoc(:,2), 'filled');
    xlabel('Patch 1 \beta'); ylabel('Patch 2 \beta');
    
end

figure(1)
xlabel('Time (in days)')
ylabel('Number Currently Infectious (per thousand)')
title('Asynchrony Enhances Disease Spread')
legend('Overlap = 1', 'Overlap = 0.5')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})

figure(2)
xlabel('Time (in days)')
ylabel('Cumulative Infections (per thousand)')
title('Asynchrony Enhances Disease Spread')
legend('Overlap = 1', 'Overlap = 0.5')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})

figure(3)

subplot(2,2,1)
xlabel('Time (in days)')
ylabel('Daily Transmission Rate')
legend('Patch 1', 'Patch 2')
title('Synchrony; NPI overlap = 1')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})

subplot(2,2,2)
xlabel('Time (in days)')
ylabel('Daily Transmission Rate')
legend('Patch 1', 'Patch 2')
title('Asynchrony; NPI overlap = 0.5')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})