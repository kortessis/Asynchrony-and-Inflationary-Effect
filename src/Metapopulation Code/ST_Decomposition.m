clear; clc;

%% Model for generating environmental variation in space and time
x = 0:0.1:1; % Spatial locations
t = 0:0.1:1;

a = 2; % Temporal amplitude in fluctuations
tau = 0.5; % Maximum temporal shift across space 
b = 2; % Spatial gradient slope

% Stochastic component of variation
rng(5); % Set random number generator seed for reproducibility
sigma = 0.25; % Standard deviation of stochastic component
X = normrnd(0,1,length(x), length(t)); % Random variables

% Generate the fitness factor across space and time
F = -0.25 + b*x'*ones(size(t))...
    + a*(1 - x'*ones(size(t))).*sin(2*pi*(ones(size(x'))*t - tau*x'*ones(size(t))))...
    + sigma*X;

%% Decomposing fitness factor variation
Fvec = reshape(F, [size(F,1)*size(F,2),1]);
Ft = sum(F,1)/length(x);
Fx = sum(F,2)/length(t);
varT = mean(Ft.^2) - mean(Ft)^2;
varS = mean(Fx.^2) - mean(Fx)^2
varFx = sum(F.^2,2)/length(t) - (sum(F,2)/length(t)).^2;
varST = mean(varFx) - varT
act_varF = mean(Fvec.^2) - mean(Fvec).^2
theo_total = varS + varT + varST;
error = (theo_total - act_varF)/act_varF


%% Visualizing the variation
tl = tiledlayout('flow');

% First show the variation map in space by time coordinates
nexttile
image(t,x,F,'CDataMapping','scaled'); colormap(viridis);
title('Full Variation', 'FontSize', 20, 'FontName', ...
    'Times New Roman')
ax = gca; ax.CLim = [min(Fvec),max(Fvec)];
ax.XTick = []; ax.YTick = [];

% Now visualize the variation for a spatial model
nexttile
image(t,x,Fx*ones(size(t)), 'CDataMapping', 'scaled')
title('Spatial Only', 'FontSize', 20, 'FontName', ...
    'Times New Roman')
ax = gca; ax.CLim = [min(Fvec),max(Fvec)];
ax.XTick = []; ax.YTick = [];

% Now visualize the variation for a temporal model
nexttile
image(t,x,ones(size(x'))*Ft, 'CDataMapping', 'scaled')
title('Temporal Only', 'FontSize', 20, 'FontName', ...
    'Times New Roman')
ax = gca; ax.CLim = [min(Fvec),max(Fvec)];
ax.XTick = []; ax.YTick = [];

% Plot spatio-temporal component of variability
Fst = F - ones(size(Fx))*Ft - Fx*ones(size(Ft));
nexttile
image(t,x,Fst, "CDataMapping",'scaled')
title('Spatio-Temporal Only', 'FontSize', 20, 'FontName', ...
    'Times New Roman')
ax = gca; ax.CLim = [min(Fvec),max(Fvec)];
ax.XTick = []; ax.YTick = [];

% Set global figure properties
set(tl, 'TileSpacing','compact')
set(tl, 'Padding', 'compact')
title(tl, 'Patterns of Environmental Variation by Dimension', ...
    'FontSize', 30, 'FontName', 'Times New Roman')
xlabel(tl, 'Time, {\itt}', 'FontSize', 30', 'FontName', 'Times New Roman');
ylabel(tl, 'Location, {\itx}', 'FontSize', 30', 'FontName', 'Times New Roman')

% Put in a colorbar and set its properties
cb = colorbar;
cb.Layout.Tile = 'east';
cb.TickLabels = [];
title(cb, '{\itF}', 'FontSize', 16, 'FontName', 'Times New Roman');

%% Figure showing contribution of each source of variation
var_comp = [act_varF, varST, varS, varT]/act_varF*100;

% Plotting parameters to determine the ordering of plotting
order_vec = [4,1,3,2];
label_order = [2,4,3,1];

% Labels
Y_Tick_Labels = {'\sigma^2', '\sigma_{{\itST}}', '\sigma^2_{{\itS}}', '\sigma^2_{{\itT}}'};

% Start horizontal bar plot
figure()
barh(order_vec, var_comp);
xlabel('Variance Contribution (% Total)')
title('Variance Decomposition')
ax = gca; ax.YTick = 1:4;
ax.YTickLabels = Y_Tick_Labels(label_order);
ax.FontSize = 20; ax.FontName = 'Times New Roman';
xlim([0,115])

% Add text next to the bars showing the source of variation
label_string = {'Total', 'Spatio-Temporal', 'Spatial', 'Temporal'};
for i = 1:length(var_comp)
    txt = text(var_comp(i)+1, order_vec(i), label_string{i});
    txt.FontSize = 20; txt.FontName = 'Times New Roman';
    txt.HorizontalAlignment = 'left';
end




