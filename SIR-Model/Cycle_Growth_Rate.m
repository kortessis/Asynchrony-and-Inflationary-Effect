% This script generates a single figure that shows how the global growth
% rate changes with movement and asynchrony.

% Note that, for there is a timescale feature here. Everything is done for
% an arbitrary cycle length = 1. For the exmaple, we assume a cycle is 2
% months (i.e. 60 days). This means we need to translate between day
% parameters in terms of the their values per day and their values in the
% model, which assumes a timescale of a single cycle. 

% For example, if the cycle occurs in a single day, the daily parameters
% are the same as the model parameters.

% If the cycle occurs over 60 days, we need to divide each parameter by 60
% to get daily values. Or do the reverse of specify a value at the level of
% a day and then multiply by 60 to get the parameters for the model. 

% This is important for interpreting the values of r and m. r = 1 means
% means a change in log population sizes of 1 over a whole month, which is
% much slower at the scale of a day. Indeed, the daily rate of increase in
% this case is 1/60 = 0.0167, which is very modest increase. Hence, r = 2
% is not that unreasonable a value as used here because it implies a rate
% of change of 0.333, which is a doubling of current cases every 3 days. 

clear
clc

figure()
% Make some diagrams showing the global growth rate
cycle_length = 60; % in units of days

fraction_move_per_day = linspace(0,0.05,25);
m = -log(1 - fraction_move_per_day);
overlap = linspace(0,1,25);

beta0 = 0.375;
inf_duration = 4.5;
gamma = 1/inf_duration;
epsilon = 0.95;

rhi = beta0 - gamma;
rlo = beta0*(1-epsilon) - gamma;

global_r = zeros(length(m), length(overlap));

for i = 1:length(m)
    for j = 1:length(overlap)
        global_r(i,j) = TwoPatch_Global_r(rhi, rlo, m(i), overlap(j), cycle_length);
    end
    
    if any(i == 10:10:length(m))
        disp(i/length(m))
    end
end

s = contourf(fraction_move_per_day, overlap, global_r');
colormap(viridis)
hold on
contour(fraction_move_per_day, overlap, global_r', [0,0], 'LineWidth', 4, 'Color', ones(1,3))
hold off
colorbar()
xlabel('Fraction Moving Per Day')
ylabel('Asynchrony, \Omega')
set(gca, {'FontSize', 'FontName'}, {20, 'Times New Roman'})

figure()
colormap(viridis)
colorbar()

