
%% Simulations for figure 2
% This code simulates the dynamcis of occupancy and illustrates it for 4
% case: 2 patch numbers x 2 correlation values of extinction latent
% variables
clc
clear

% Graphical parameters for color coding figures
colors = viridis(6);
colors = colors([2,5],:);

% Specifying Levins Model Parameters
rho_ext_vec = [0,0.75];
rho_col = 0;
patches = [50,500];

% Specifying time duration of the simulation
tdur = 2500;
deltat = 0.0001;
t = 0:deltat:tdur;
tsteps = length(t);

% Picking random seeds for reproducibility
seed = [3,4];

% Setting model parameters: extinction and colonization rates
e = 0.25;
c = 0.5;

% Specifying initial fraction of patches occupied
init_frac_occ = 0.5;

% Here we loop over two subpanels that will differ in the number of patches
for k = 1:2
    subplot(2,1,k)
    plot(t, -ones(1,tsteps));
    ylim([0,1]); xlabel('Time, {\itt}');
    ylabel('Fraction of Patches Occupied, {\it p}({\itt})');
    ax = gca; ax.FontSize = 20; ax.FontName = 'Times New Roman';
    hold on;

    % Within each subpanel, we simulation over two values of the rho_E
    % value.
    for i = 1:2
        O = LevinsMetaPop(rho_col, rho_ext_vec(i), patches(k), tsteps, ...
            deltat, seed(k), e, c, init_frac_occ);
        % We take the occupancy patterns of all patches to get the time
        % series of fraction of patches occupied. 
        N = ones(1,patches(k))*O;
        
        % And we add the lines for these time series to the specified plots 
        p = plot(t, N/patches(k), '-', 'Color', colors(i,:));
        p.LineWidth = 1.75;
        [mean(N)/patches(k)]
    end
    yline(1 - e/c, '--', 'LineWidth', 1.5)
    hold off;

end

%% Metapopulation Extinction Probabilities for Figure 3

clear
clc

% Here we calculate the extinction times and the conditional average 
% population occupancy. 
% 
% We define extinction times as the amount of time
% until the population goes extinct when starting from an initial
% population occupancy of 1/2. 
%
% We define conditional average population occupancy as the time average
% fraction of patches occupied, conditional on the population being present
% (i.e., occupancy > 0). 

% Number of patches
patches = 25;

% Model parameters for colonization and extinction probabilities
rho_col = 0;
rho_ext_vec = linspace(0.05,0.95,10);
e = 0.25;
c = 0.5;

% Number of time steps to evaluate extinction
tdur = 100;
deltat = 0.0001;%0.0005;
t = 0:deltat:tdur;
tsteps = length(t);

% Initial occupancy
init_frac_occ = 0.5;

% Number of replicate simulations to evaluate extinciton times
reps = 100;

% Empty vectors to hold times to extinction and conditional mean occupancy.
ext_time = nan(length(rho_ext_vec),reps);
cond_mean_occ = ext_time;

% Loop over different values of rho_ext
for i = 1:length(rho_ext_vec)
    rho_ext = rho_ext_vec(i);
    % Loop over different replicate simulations
    parfor r = 1:reps

        % Write the initial number of patches as the based on the initial
        % occupancy and the number of patches in the landscape.
        N = init_frac_occ*patches;

        % Counter to decide how long the simulation has run
        count = 0;

        % Continue simulating while the population is persistent. This
        % while loop ends when the population has gone extinct. 
        while N(end) ~= 0

            % Run the HanskiIncidence function. We set seed = nan to make
            % the sequence of extinction and colonization events differ
            % over time. We only consider tsteps at a time.
            O = LevinsMetaPop(rho_col, rho_ext, patches, tsteps, deltat, ...
                nan, e, c, N(end)/patches);

            % Figure out population size and keep track.
            N = [N,ones(1,patches)*O(:,2:end)];
            % Keep track of the number of "tsteps" simulations that have
            % been done.
            count = count+1;
        end

        % After the while loop has ended
        ext_time(i,r) = (find(N==0,1,'first')-1)*deltat;

        Npers = N(N>0);
        cond_mean_occ(i,r) = mean(Npers)/patches;

        ['rho vector ', num2str(i/length(rho_ext_vec)*100), '% done. replicates ',...
            num2str(r/reps*100), '% done']
    end
end

% Generate a colormap for the data
pt_colors = viridis(length(rho_ext_vec)+2);
pt_colors = pt_colors(2:end-1,:);


% Plot the time to extinction information
figure;
subplot(1,2,1)
semilogy(2,1); xlim([0,1]); ylim([1,max(max(ext_time))]);
grid on; hold on;
for i = 1:length(rho_ext_vec)
    scatter(rho_ext_vec(i)*ones(1,reps) + normrnd(0,0.005,[1,reps]), ...
        ext_time(i,:), 'filled', 'SizeData', 75,...
        'MarkerEdgeColor','black','MarkerFaceColor',pt_colors(i,:));
end
plot(rho_ext_vec, exp(mean(log(ext_time),2)),'black')
scatter(rho_ext_vec, exp(mean(log(ext_time),2)), 'Filled', 'Marker', 'square',...
    'SizeData', 350, 'CData',pt_colors, 'MarkerEdgeColor','black');
hold off;

ax = gca; ax.FontSize = 25; ax.FontName = 'Times New Roman';
xlabel('Correlation among patch extinction events, \rho_{\itE}');
ylabel('Time to Extinction');
title('Asynchrony drastically extends time to extinction');
ax.YTickLabels = [1, 100, 10000, 1000000];


% Plot the conditional mean population size
subplot(1,2,2)
plot(2,1); xlim([0,1]); ylim([0,1]);
hold on;
for i = 1:length(rho_ext_vec)
    scatter(rho_ext_vec(i)*ones(1,reps) + normrnd(0,0.005,[1,reps]), ...
        cond_mean_occ(i,:), 'filled', 'SizeData', 75,...
        'MarkerEdgeColor','black','MarkerFaceColor',pt_colors(i,:));
end
plot(rho_ext_vec, mean(cond_mean_occ,2),'black')
scatter(rho_ext_vec, mean(cond_mean_occ,2), 'Filled', 'Marker', 'square',...
    'SizeData', 250, 'CData',pt_colors, 'MarkerEdgeColor','black');
hold off;

ax = gca; ax.FontSize = 25; ax.FontName = 'Times New Roman';
xlabel('Correlation among patch extinction events, \rho_{\itE}');
ylabel('Conditional Mean Occupancy');
title('Asynchrony minimially affects mean occupancy');
