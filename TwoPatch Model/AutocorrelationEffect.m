gen = 250;

rbar = -0.1;
I = 1-exp(rbar);
phi_vec = linspace(-0.9,0.9,11);
colors = jet(length(phi_vec));
sigmar = sqrt(0.02);

plot(0, 0, 'LineStyle','none');
yline(N(1), '-', 'Color', 'black', 'LineWidth',3);
xlabel('Time'); ylabel('Population Size');
ylim([0.1,10]); xlim([0,gen]);
hold on;

X = normrnd(0,1,[1,gen]);
Xr = nan(1,gen);
Xr(1) = rbar;

for i = 1:length(phi_vec)

    phi = phi_vec(i);

    N = nan(1,gen);
    N(1) = I/(1-exp(rbar));

    for t = 2:gen
        Xr(t) = Xr(t-1)*phi + sqrt(1-phi^2)*X(t-1);
    end

    r = rbar + sigmar*Xr;
    % plot(r)
    % scatter(r(1:gen-1), r(2:gen))

    for t = 2:gen
        N(t) = N(t-1).*exp(r(t-1)) + I;
    end

    plot(1:gen, N, 'Color', colors(i,:));
end
hold off;