clear
clc

% This is a script to illustrate the reaction norm approach to modeling
% extinction and colonization events.

% It has two components that illustrate how the reaction norm works. This
% approach is used to create correlated exinction events. There are no
% known bivariate distributions to create correlated sets of bernoulli
% outcomes (extinction/persistence). We used copulas to do this. 

% Copulas rely on generating correlated variables (typically normals) and
% then translating them to a space that matches the desired distribution.
% Here we wish to produce correlated bernoullis. This first relies on using
% cdfs to create uniform variables, and then to transform them back another
% distribution using inverse cdfs. 

% The procedure is detailed in the supplementary material and illustrated
% in Figures S1 and S2. This code produces the illustrative figures. 

%% Figure S1 - Normal to Uniform Random Variables %%

% First, a sample 200 time points from a random normal and convert them to
% a uniform distribution using the normal cdf. 
n = 200;
X = normrnd(0,1,[1,n]);
U = normcdf(X);

% Create a figure with mutiple panels.
t = tiledlayout('flow');

% Create a dummy vector to plot the cdf of the normal distribution. 
xvec = linspace(-3,3,100);

% For the first 
nexttile([2,2]);

% Plot the cdf
plot(xvec,normcdf(xvec),'Color', 'black', 'LineWidth',3);
ylim([-0.1,1])
hold on;
yline(0, 'Color', 'black', 'LineWidth',2);
% Place the normal data points just below the x-axis
scatter(X, normrnd(-0.05, 0.01, size(X)), 'filled')
% Add vertical lines showing the map to the cdf for each normal sample
plot(ones(2,1)*X, [U; zeros(1,n)], 'Color', 0.5*ones(1,3));
% Add horizontal lines going to the y-axis
plot([X;3*ones(1,n)], ones(2,1)*U, 'Color', 0.5*ones(1,3));
xlim([-3,3.3])
xline(3,'Color', 'black', 'LineWidth',2);

% Add the uniform distribution points outside the y-axis at the location of
% the cdf.
scatter(normrnd(3.2, 0.025, size(X)), U, 'filled');
hold off;
h1 = gca;

% Add figure labels.
title('Normal Cumulative Distribution Function');
xlabel('X ~ Standard Normal');
ylabel('Standard Normal Cumulative Density, \Phi')
txt = text(3.5, 0.5, 'U ~ Uniform(0,1)', 'Rotation', -90);
txt.HorizontalAlignment = 'center'; 
txt.FontName = 'Times New Roman'; txt.FontSize = 30;
ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 30;


% Add a histogram of the transformed, uniform values on the y-axis
nexttile([2,1]);
histogram(U, 'Orientation', 'horizontal');
%axis('off');
h2 = gca;
ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 30;
xlim([-3,3.3]);

% Add a histogram of the normal values on the x-axis
nexttile([1,2]);
histogram(X);
view([0,270]);
%axis('off');
ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 30;
ylim([-0.1,1])


%% Figure S2 - Normals to Bernoulli Extinctions
% Global Plotting Parameters
FtSize = 16;
FtName = 'Times New Roman';

% Pick a probability of extinction
e = 1/2;

% Define the environment as a bivariate normal with correlation 0.85
X = linspace(-3,3,100);
% Make bivariate normal pdf with random points
rng(7); pts = 75;
rho = 0.85;
MU = [0,0]; SIGMA = [1,rho;rho,1];
[X1,X2] = meshgrid(X,X);
Xvec = [X1(:) X2(:)];
y = mvnpdf(Xvec,MU, SIGMA);
y = reshape(y,length(X),length(X));

% Translate to a [0,1] scale using the cdf transform
U = normcdf(X);

% Take the inverse cdf for a bernoulli of extinction.
Ext = nan(size(X));
Ext(U < e) = 1;
Ext(U > e) = 0;

% Create a multi-panel figure
t = tiledlayout('flow');

% First, show the multivariate normal pdf.
nexttile([2,2])
surf(X,X,y)
grid off;
clim([min(y(:))-0.5*range(y(:)),max(y(:))])
xlabel('Patch 1 Environment, X_1')
ylabel('Patch 2 Environment, X_2')
zlabel('Probability Density')
title('Correlated Bivariate Normal')
colormap("gray")

% Randomly Sample from the bivariate pdf 
Xrand = mvnrnd(MU, SIGMA, pts);
Yrand = Xrand(:,2);
Xrand = Xrand(:,1);
hold on;
scatter3(Xrand, Yrand, mvnpdf([Xrand,Yrand], MU, SIGMA)+0.001, 'filled', 'o', ...
    'MarkerEdgeColor','black','MarkerFaceColor',0.8*ones(1,3), 'SizeData', ...
    300);
hold off;
ax = gca; ax.FontSize = FtSize; ax.FontName = FtName;

% Transform normal random sample to uniform random sample for each patch
U1rand = normcdf(Xrand);
Ext1rand = zeros(size(U1rand));
Ext1rand(U1rand < e) = 1;

U2rand = normcdf(Yrand);
Ext2rand = zeros(size(U2rand));
Ext2rand(U2rand < e) = 1;


% Now plot the translation from X to Ext for the two patches
nexttile([1,1])
plot(X, Ext, 'LineWidth', 3);
hold on;
% Add the random sample
scatter(Xrand, Ext1rand, 'filled', 'o');
hold off;
xlabel('Environmental Factor in patch 1, {\itX}_1');
ylabel('Extinction');
title('Patch 1 Reaction Norm')
ax = gca; ax.FontSize = FtSize; ax.FontName = FtName;

% For patch 2
nexttile([1,1])
plot(X, Ext, 'LineWidth', 3);
hold on;
scatter(Yrand, Ext2rand, 'filled', 'o');
hold off;
xlabel('Environmental Factor in patch 2, {\itX}_2');
ylabel('Extinction');
title('Patch 2 Reaction Norm')
ax = gca; ax.FontSize = FtSize; ax.FontName = FtName;

% Now show the pattern of extinction over time in teh two patches
nexttile([1,2])
image(1:pts, [1,2], [Ext1rand,Ext2rand]', 'CDataMapping','scaled')
colormap('bone')
ax = gca; ax.YTick = 1:2;
hold on;
yline(1.5, 'Color', 0.25*ones(1,3), 'LineWidth',2);
xline(0.5+[0:pts], 'Color', 0.25*ones(1,3), 'LineWidth',2)
hold off;
xlabel('Time'); ylabel('Patch'); 
title(["Extinction State, Kendall's \rho = ",num2str(rho)])
ax = gca; ax.FontSize = FtSize; ax.FontName = FtName;

