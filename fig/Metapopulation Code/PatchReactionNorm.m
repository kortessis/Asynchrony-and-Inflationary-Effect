clear
clc

% This is a script to illustrate the reaction norm approach to modeling
% extinction and colonization events.
n = 200;
X = normrnd(0,1,[1,n]);
U = normcdf(X);

t = tiledlayout('flow');

xvec = linspace(-3,3,100);
nexttile([2,2]);
plot(xvec,normcdf(xvec),'Color', 'black', 'LineWidth',3);
ylim([-0.1,1])
hold on;
yline(0, 'Color', 'black', 'LineWidth',2);
scatter(X, normrnd(-0.05, 0.01, size(X)), 'filled')
plot(ones(2,1)*X, [U; zeros(1,n)], 'Color', 0.5*ones(1,3));
plot([X;3*ones(1,n)], ones(2,1)*U, 'Color', 0.5*ones(1,3));
xlim([-3,3.3])
xline(3,'Color', 'black', 'LineWidth',2);
scatter(normrnd(3.2, 0.025, size(X)), U, 'filled');
hold off;
h1 = gca;
title('Normal Cumulative Distribution Function');
xlabel('X ~ Standard Normal');
ylabel('Standard Normal Cumulative Density, \Phi')
txt = text(3.5, 0.5, 'U ~ Uniform(0,1)', 'Rotation', -90);
txt.HorizontalAlignment = 'center'; 
txt.FontName = 'Times New Roman'; txt.FontSize = 30;
ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 30;

nexttile([2,1]);
histogram(U, 'Orientation', 'horizontal');
%axis('off');
h2 = gca;
ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 30;
xlim([-3,3.3]);

nexttile([1,2]);
histogram(X);
view([0,270]);
%axis('off');
ax = gca; ax.FontName = 'Times New Roman'; ax.FontSize = 30;
ylim([-0.1,1])





% Global Plotting Parameters
FtSize = 16;
FtName = 'Times New Roman';

% Pick a probability of extinction
e = 1/2;

% Define the environment
X = linspace(-3,3,100);
% Translate to a [0,1] scale using the cdf transform
U = normcdf(X);

% Take the inverse cdf for a bernoulli of extinction.
Ext = nan(size(X));
Ext(U < e) = 1;
Ext(U > e) = 0;

t = tiledlayout('flow');


nexttile([2,2])
% Make bivariate normal pdf with random points
rng(7); pts = 75;
rho = 0.85;
MU = [0,0]; SIGMA = [1,rho;rho,1];
[X1,X2] = meshgrid(X,X);
Xvec = [X1(:) X2(:)];
y = mvnpdf(Xvec,MU, SIGMA);
y = reshape(y,length(X),length(X));
surf(X,X,y)
grid off;
caxis([min(y(:))-0.5*range(y(:)),max(y(:))])
xlabel('Patch 1 Environment, X_1')
ylabel('Patch 2 Environment, X_2')
zlabel('Probability Density')
title('Correlated Bivariate Normal')
colormap("gray")
Xrand = mvnrnd(MU, SIGMA, pts);
Yrand = Xrand(:,2);
Xrand = Xrand(:,1);
hold on;
scatter3(Xrand, Yrand, mvnpdf([Xrand,Yrand], MU, SIGMA)+0.001, 'filled', 'o', ...
    'MarkerEdgeColor','black','MarkerFaceColor',0.8*ones(1,3), 'SizeData', ...
    300);
hold off;
ax = gca; ax.FontSize = FtSize; ax.FontName = FtName;


% Generate Some Random Samples of 
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
scatter(Xrand, Ext1rand, 'filled', 'o');
hold off;
xlabel('Environmental Factor in patch 1, {\itX}_1');
ylabel('Extinction');
title('Patch 1 Reaction Norm')
ax = gca; ax.FontSize = FtSize; ax.FontName = FtName;

nexttile([1,1])
plot(X, Ext, 'LineWidth', 3);
hold on;
scatter(Yrand, Ext2rand, 'filled', 'o');
hold off;
xlabel('Environmental Factor in patch 2, {\itX}_2');
ylabel('Extinction');
title('Patch 2 Reaction Norm')
ax = gca; ax.FontSize = FtSize; ax.FontName = FtName;

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

