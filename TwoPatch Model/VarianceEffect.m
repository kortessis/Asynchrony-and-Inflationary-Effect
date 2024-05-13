gen = 100;

rbar = -0.2;
I = 1-exp(rbar);
phi = 0;
sigmar = sqrt(linspace(0,0.5,10));

colors = viridis(length(sigmar)+2);
colors = colors(2:(end-1),:);

rng(0)
N = nan(1,gen);
N(1) = I/(1-exp(rbar));
X = normrnd(0,1,[1,gen]);
Xr = nan(1,gen);
Xr(1) = rbar;

figure();
subplot(1,3,[1,2])
semilogy(0, 0, 'LineStyle','none', 'HandleVisibility','off');
yline(N(1), '-', 'Color', 'black', 'LineWidth',3);
xlabel('Time'); ylabel('Sink Population Size');
title({'Spatiotemporal Heterogeneity', 'Boosts Sink Population Size'})
ylim([0.22,5900]); xlim([0,gen]);
hold on;


for t = 2:gen
    Xr(t) = Xr(t-1)*phi + sqrt(1-phi^2)*X(t-1);
end

arthN = zeros(1,length(sigmar));
geomN = zeros(1,length(sigmar));

for i = 1:length(sigmar)
    r = rbar + sigmar(i)*Xr;

    for t = 2:gen
        N(t) = N(t-1).*exp(r(t-1)) + I;
    end

    semilogy(1:gen, N, 'Color', colors(i,:), 'LineWidth', 2);
    arthN(i) = mean(N);
    geomN(i) = exp(mean(log(N)));
end
hold off;

%lgd = legend(strcat('\sigma^2 = ', num2str(round(sigmar'.^2,2))));
ax = gca; ax.FontSize = 20;
ax.FontName = 'Times New Roman';


subplot(1,3,3)

semilogy(0,1,'o', 'Color', 'black', 'MarkerFaceColor', 'black', ...
    'MarkerSize', 20);
ylim([0.22,5900])
xlabel('Spatiotemporal Variation, \sigma^2_{{\itST}}'); 
ylabel('Mean Population Density');

hold on;

for i = 2:length(sigmar)
    semilogy(sigmar(i).^2/4, geomN(i), 'o', 'Color', colors(i,:), ...
        'Marker', 'square','MarkerFaceColor', colors(i,:), 'MarkerSize', 20);
    semilogy(sigmar(i).^2/4, arthN(i), 'o', 'Color', colors(i,:), ...
        'MarkerFaceColor', colors(i,:), 'MarkerSize', 20);
end
hold off;

ax = gca; ax.FontSize = 20;
ax.FontName = 'Times New Roman';
ax.YTickLabel = [1,10,100,1000];

