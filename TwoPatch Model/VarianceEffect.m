gen = 100;
reps = 10;

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
semilogy(0, 0, 'LineStyle','none', 'HandleVisibility','off');
yline(N(1), '-', 'Color', 'black', 'LineWidth',3);
xlabel('Time'); ylabel('Population Size');
ylim([0.1,10]); xlim([0,gen]);
hold on;


for t = 2:gen
    Xr(t) = Xr(t-1)*phi + sqrt(1-phi^2)*X(t-1);
end

for i = 1:length(sigmar)
    r = rbar + sigmar(i)*Xr;

    for t = 2:gen
        N(t) = N(t-1).*exp(r(t-1)) + I;
    end

    semilogy(1:gen, N, 'Color', colors(i,:), 'LineWidth', 2);
end
hold off;

lgd = legend(strcat('\sigma^2 = ', num2str(round(sigmar'.^2,2))));
ax = gca; ax.FontSize = 20;
ax.FontName = 'Times New Roman';
