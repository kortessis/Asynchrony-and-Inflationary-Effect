clear
clc

%% Section showing that increasing cycle length makes the effect bigger

% Set parameters for the cycle length, movement, and asynchrony
cycle_length = 2:2:120;
m = linspace(0.001, 0.005, 5);
asynchrony = [0.25, 0.5, 0.75];
overlap = 1 - asynchrony;

% Other parameters
rbar = -0.0008; % Average beta - gamma over time
deltar = 0.05; % Difference between high and low values of beta
inf_duration = 4.5; % Infectious durations = 1/gamma
gamma = 1/inf_duration; % Recovery rate

% Calculating the high and low values of the per-infectious growth rate. 
rhi = rbar + deltar;
betahi = rhi + gamma;
rlo = rbar - deltar;
% Calculate epsilon from the growth rate specification
epsilon = 1 - (rlo+gamma)/betahi;

% Set plotting parameters
colors = viridis(length(m)+2);
colors = colors(2:length(m)+1,:);

figure()

% Loop over overlap values, movement rates, and cycle lengths
for k = 1:length(overlap)
    
    % Set a vector to hold metapopulation growth rates
    global_r = zeros(length(m), length(cycle_length));

    for i = 1:length(m)
        for j = 1:length(cycle_length)
            % Calcualte growth rate from the looped parameters using the
            % function TwoPatch_Global_r
            global_r(i,j) = TwoPatch_Global_r(rhi, rlo, m(i), overlap(k), cycle_length(j));
        end
        disp([k, i/length(m)]) % Print progress
    end

    % Turn the growth into the correct units by dividing by the cycle
    % lenght. This converts the growth into an average rate over the
    % duration of the cycle.
    scaled_global_r = global_r./(ones(length(m),1)*cycle_length);
    
    % Plot results
    subplot(1,length(overlap),k)
    p = plot(cycle_length/2, scaled_global_r, 'LineWidth', 2);
    hold on
    yline(rbar, '--', 'Color', 'black');
    yline(0, 'Color', 'black');
    hold off
    set(p, {'Color'}, num2cell(colors,2), {'LineWidth'}, {3});
    xlabel('Duration of Lockdown {\itT}')
    ylabel({'Metapopulation Scale Infectious','Growth Rate (per day)'})
    title(['NPI Overlap = ', num2str(overlap(k))])
    set(gca, 'FontSize', 25)
    set(gca, 'FontName', 'Times New Roman')
    ylim([-0.001, 0.006])
    if k == 1
        lgd = legend(strsplit(num2str(m, 2)));
        title(lgd, '$m$', 'Interpreter', 'Latex')
    end
end


%% Section showing that increasing delta r increases the growth rate per day

% Set parameters to loop over, including the movement rate, asynchrony, and
% effectiveness of the intervention
NPIduration = 45;
cycle_length = NPIduration*2;
m = linspace(0.001, 0.005, 5);
asynchrony = [0.25, 0.5, 0.75];
epsilon = linspace(0, 1, 30);

overlap = 1 - asynchrony;

% Set epidemiological parameters
gamma = 1/inf_duration;
beta0 = (gamma - 0.065)*2;

% Set colors
colors = viridis(length(m)+2);
colors = colors(2:length(m)+1,:);

figure()

% Loop over NPI overlap (1- asynchrony), movement, and NPI effectiveness
% (epsilon)
for k = 1:length(overlap)
    
    global_r = zeros(length(m), length(epsilon));

    for i = 1:length(m)
        for j = 1:length(epsilon)
            
            rhi = beta0 - gamma;
            rlo = beta0*(1-epsilon(j)) - gamma;
            
            % Calculate the growth rate
            global_r(i,j) = TwoPatch_Global_r(rhi, rlo, m(i), overlap(k), cycle_length);
        end
        disp([k, i/length(m)])
    end
    
    scaled_global_r = global_r./cycle_length;
    
    subplot(1,length(overlap),k)
    p = plot(epsilon, scaled_global_r, 'LineWidth', 1);
    hold on
    yline(0, 'Color', 'black');
    plot(epsilon, beta0*(1-epsilon/2)-gamma, '--', 'Color', 'black')
    hold off

    set(p, {'Color'}, num2cell(colors,2), {'LineWidth'}, {3});
    
    xlabel('NPI effectiveness (\epsilon)')
    ylabel({'Metapopulation Scale Infectious','Growth Rate (per day)'})
    title(['NPI Overlap = ', num2str(overlap(k))])
    
    set(gca, 'FontSize', 25)
    set(gca, 'FontName', 'Times New Roman')
    
    if k == 1
        lgd = legend(strsplit(num2str(m, 2)));
        title(lgd, '$m$', 'Interpreter', 'Latex')
    end
end

