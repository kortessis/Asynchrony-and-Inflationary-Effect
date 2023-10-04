% Stochastic 2-patch model of infectious disease growth and Parrondo's
% Paradox

clear
clc

MeanDiff = 0; % Set to 1 if you want to just pick r values with a mean and 
              % an amplitude
              % Set to 0 if you want to pick epidemiological parameters.
              % You will need
                % Infectious duration in days
                % Rates of new infections during outbreak phase and during
                % social distancing phase
                
if MeanDiff == 1
    % Mean r
    rbar = -0.25;
    % Difference between r min and rmax
    rdiff = 2;
    
    rhi = rbar + rdiff/2; % Change in log(I)/day during outbreak
    rlo = rbar - rdiff/2; % Change in log(I)/day during social distancing
else
    inf_duration = 4.5; % Number of days infectious
    outbreak_case_doubling_time = 2.5;
    soc_dist_case_doubling_time = 50;
   
    % r = 1/case_doubling_time - 1/inf_duration
    rhi = 1/outbreak_case_doubling_time - 1/inf_duration;
    rlo = 1/soc_dist_case_doubling_time - 1/inf_duration;
end

% Square wave function
period = 60; % Period length in units of days; needs to be even
num_per = 3;

if rem(period,2) > 0
    disp('Period not even; Choose even period')
end

% This is the correlation in the policies of two locations
overlap = 0.5;
% This is the day difference in policy enaction 
tau = floor(period*(1 - overlap)/2);

% Patch one switches to social distancing on day period/2 + 1;
% Patch two switches to social distancing on day tau + 1
patch1r = [rhi*ones(period/2,1); rlo*ones(period/2,1)];
patch2r = [rhi*ones(tau,1);rlo*ones(period/2,1);rhi*ones(period/2-tau,1)];
meanr = [patch1r, patch2r]; meanr = repmat(meanr, num_per, 1);
variance = 0.1; % Variance in the stocahstic component

% Variability to add on square-wave r function
rng default
sigma = variance*eye(2);
R = chol(sigma);
e = randn(period*num_per,2)*R;

lambdat = exp(meanr + e);

figure(1)
figure(2)
figure(3)

% Initial infection numbers
I_init = 5*ones(1,2);

cum_I = sum(I_init);

for m = [0.025, 0]


I = zeros(period*num_per, 2);
I(1,:) = I_init;

for t = 2:period*num_per
    Iprime = lambdat(t-1,:).*I(t-1,:);
    I(t,:) = Iprime*[1-m, m; m, 1-m];
    cum_I(t) = cum_I(t-1) + sum(I(t,:));
end

    if m == 0
        FontType = '--';
    else
        FontType = '-';
    end
    
figure(1)
subplot(1,2,1)
hold on
semilogy(1:size(I,1), I, FontType)
hold off
figure(1)
subplot(1,2,2)
hold on
semilogy(1:size(I,1), sum(I,2), FontType, 'Color', 'black')
hold off

figure(2)
subplot(1,2,1)
hold on
plot(1:size(I,1), I, FontType)
hold off
figure(2)
subplot(1,2,2)
hold on
plot(1:size(I,1), sum(I,2), FontType, 'Color', 'black')
hold off

figure(3)
hold on
plot(1:size(I,1), cum_I, FontType, 'Color', 'black')
hold off
end

figure(1)
subplot(1,2,1)
xlabel('Time (in days)')
ylabel('Number of Curent Infectious in Patch')
title('Patch Infectious (Log Scale)')
legend('Patch 1, Dispersal', 'Patch 2, Dispersal','Patch 1, No Dispersal','Patch 2,No Dispersal')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})

figure(1)
subplot(1,2,2)
xlabel('Time (in days)')
ylabel('Total Curent Infectious')
title('Global Infectious (Log Scale)')
legend('Dispersal', 'No Dispersal')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})


figure(2)
subplot(1,2,1)
xlabel('Time (in days)')
ylabel('Number of Curent Infectious in Patch')
title('Patch Infectious (Arithmetic Scale)')
legend('Patch 1, Dispersal', 'Patch 2, Dispersal','Patch 1, No Dispersal','Patch 2,No Dispersal')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})

figure(2)
subplot(1,2,2)
xlabel('Time (in days)')
ylabel('Total Curent Infectious')
title('Global Infectious (Arithmetic Scale)')
legend('Dispersal', 'No Dispersal')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})

figure(3)
xlabel('Time (in days)')
ylabel('Cumulative Cases')
legend('Dispersal', 'No Dispersal')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})
