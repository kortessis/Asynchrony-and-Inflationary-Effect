clear
clc

rho_ext = [0,0.75];
rho_col = 0;
patches = 100;
tsteps = 200;
seed = 16;
ext_prob = 0.25;
c = 0.5*patches;
init_frac_occ = 0.5;

plot(1:tsteps, -ones(1,tsteps));
ylim([0,1]); xlabel('Time, {\itt}'); 
ylabel('Fraction of Patches Occupied, {\it p}({\itt})');
ax = gca; ax.FontSize = 20; ax.FontName = 'Times New Roman';
hold on;

for i = 1:2
    O = HanskiIncidence(rho_col, rho_ext(i), patches, tsteps, seed,...
        ext_prob, c, init_frac_occ);
    N = ones(1,patches)*O;
    plot(1:tsteps, N/patches, '-o', 'Color', 0.75*ones(1,3));
end
hold off;


%% Metapopulation Extinction Probabilities

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
rho_ext = linspace(0.05,0.95,10);
ext_prob = 0.25;
c = 0.5*patches;

% Number of time steps to evaluate extinction
tsteps = 100;

% Initial occupancy
init_frac_occ = 0.5;

% Number of replicate simulations to evaluate extinciton times
reps = 100;

% Empty vectors to hold times to extinction and conditional mean occupancy.
ext_time = nan(length(rho_ext),reps);
cond_mean_occ = ext_time;

% Loop over different values of rho_ext
for i = 1:length(rho_ext)

    % Loop over different replicate simulations
    for r = 1:reps

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
            O = HanskiIncidence(rho_col, rho_ext(i), patches, tsteps, nan, ...
                ext_prob, c, N(end)/patches);

            % Figure out population size and keep track.
            N = [N,ones(1,patches)*O(:,2:end)];
            % Keep track of the number of "tsteps" simulations that have
            % been done.
            count = count+1;
        end

        % After the while loop has ended
        ext_time(i,r) = find(N==0,1,'first')-1;

        Npers = N(N>0);
        cond_mean_occ(i,r) = mean(Npers)/patches;

        ['rho vector ', num2str(i/length(rho_ext)*100), '% done. replicates ',...
            num2str(r/reps*100), '% done']
    end
end

% Generate a colormap for the data
pt_colors = viridis(length(rho_ext)+2);
pt_colors = pt_colors(2:end-1,:);


% Plot the time to extinction information
figure;
semilogy(2,1); xlim([0,1]); ylim([1,max(max(ext_time))]);
grid on; hold on;
for i = 1:length(rho_ext)
    scatter(rho_ext(i)*ones(1,reps) + normrnd(0,0.005,[1,reps]), ...
        ext_time(i,:), 'filled', 'SizeData', 75,...
        'MarkerEdgeColor','black','MarkerFaceColor',pt_colors(i,:));
end
plot(rho_ext, exp(mean(log(ext_time),2)),'black')
scatter(rho_ext, exp(mean(log(ext_time),2)), 'Filled', 'Marker', 'square',...
    'SizeData', 350, 'CData',pt_colors, 'MarkerEdgeColor','black');
hold off;

ax = gca; ax.FontSize = 25; ax.FontName = 'Times New Roman';
xlabel('Correlation among patch extinction events, \rho_{\itE}');
ylabel('Time to Extinction');
title('Asynchrony drastically extends time to extinction');
ax.YTickLabels = [1, 100, 10000, 1000000];


% Plot the conditional mean population size
figure;
plot(2,1); xlim([0,1]); ylim([0,1]);
hold on;
for i = 1:length(rho_ext)
    scatter(rho_ext(i)*ones(1,reps) + normrnd(0,0.005,[1,reps]), ...
        cond_mean_occ(i,:), 'filled', 'SizeData', 75,...
        'MarkerEdgeColor','black','MarkerFaceColor',pt_colors(i,:));
end
plot(rho_ext, mean(cond_mean_occ,2),'black')
scatter(rho_ext, mean(cond_mean_occ,2), 'Filled', 'Marker', 'square',...
    'SizeData', 250, 'CData',pt_colors, 'MarkerEdgeColor','black');
hold off;

ax = gca; ax.FontSize = 25; ax.FontName = 'Times New Roman';
xlabel('Correlation among patch extinction events, \rho_{\itE}');
ylabel('Conditional Mean Occupancy');
title('Asynchrony drastically reduces mean occupancy');
