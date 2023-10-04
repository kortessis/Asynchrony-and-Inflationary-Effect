clear
clc

n = 200;
rbar = 0;
deltar = 0.5;
T = 10;
m = 0.50;
tau = 1*T;
cycles = 2;

deltat = 0.001;
t = 0:deltat:cycles*T;

tauvec = tau*([1:n] - 1)/n;
r = rbar + deltar*sin(2*pi*(ones(n,1)*t - tauvec'*ones(size(t)))/T);

figure(2)
subplot(2,1,1)
image(t, 1:n, r, 'CDataMapping', 'scaled')
colorbar
colormap("bone")
xlabel('Time')
ylabel('Location')
title('Local Growth Rate, {\it r}')
ax = gca; ax.YTick = [];
ax.FontSize = 30;

N = nan(size(r));
N(:,1) = (r(:,1)+abs(min(r(:,1))+0.01));
P = ones(n)*1/(n-1); P = P - diag(diag(P)+1);
for tindx = 2:length(t)
    dN = r(:,tindx-1).*N(:,tindx-1) + m*P*N(:,tindx-1);
    N(:,tindx) = N(:,tindx-1) + dN*deltat;
end

Nbar = ones(1,n)*N/n;
nu = N./(ones(n,1)*Nbar);
subplot(2,1,2)
image(t, 1:n, nu, 'CDataMapping', 'scaled')
colorbar
colormap('bone')
xlabel('Time')
ylabel('Location')
title('Relative Density, \nu')
ax = gca; ax.YTick = [];
ax.FontSize = 30;

figure(3)
per_env = ones(1,n)*(r.*nu)/n;
subplot(1,2,1)
plot(t, per_env);
xlabel('Time')
ylabel('Average Experienced Environment')
title('Perceived Environment for Species')

cov_rnu = ones(1,n)*(r.*(nu - 1))/n;
subplot(1,2,2)
plot(t, cov_rnu)
xlabel('Time')
ylabel('cov({\itr_i},{\it\nu_i})')
title('Local Density Tracking Favorable Conditions')
yline(0, '--', 'Color', 0.5*ones(1,3));
yline(mean(cov_rnu), ':', 'Color', zeros(1,3))

growth_mismatch = (nu - 1).*(r - rbar);

figure(4)
image(t, 1:n, growth_mismatch, 'CDataMapping', 'scaled')
xlabel('Time')
ylabel('Location');
colormap("bone");
ax = gca; ax.YTick = [];
title('Population-Environment Match')
colorbar
ax.FontSize = 30;
