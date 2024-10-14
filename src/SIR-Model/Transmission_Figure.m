% Set the delay between patches
tau = 0.225;
% Calculate relevant time points
t1 = [0, 1/2, 1/2, 1];
t2 = [0, 1/2-tau, 1/2-tau, 1-tau, 1-tau, 1];

% Set arbitrary high and low values for beta
beta1 = [1,1,0,0];
beta2 = [1,1,0,0,1,1];

% Plot the colors and lines on the figure
fill([1/2-tau,1/2-tau,1/2,1/2,1/2-tau], 2*[-1,1,1,-1,-1], 0.8*ones(1,3))
hold on;
fill([1-tau,1-tau,1,1,1-tau], 2*[-1,1,1,-1,-1], 0.8*ones(1,3))
plot(t1, beta1,'LineWidth', 4, 'Color', 'black')
plot(t2, beta2-0.01, 'LineWidth', 4, 'Color', 0.5*ones(1,3));
yline(0.5, ':', 'LineWidth',2);
hold off;
ylim([-0.05, 1.2]);
% Add labels
xlabel('Time, $t$', 'Interpreter','latex');
ylabel('Transmission Rate, $\beta_x(t)$',...
    'Interpreter','latex');

% Add hypertext
tx1 = text(0.15,1.1, 'Time period 1', 'HorizontalAlignment','center');
tx2 = text(0.4,1.1, 'Time period 2', 'HorizontalAlignment','center');
tx3 = text(0.65,1.1, 'Time period 3','HorizontalAlignment','center');
tx4 = text(0.9,1.1, 'Time period 4','HorizontalAlignment','center');

set([tx1, tx2, tx3, tx4], {'FontName'}, {'Times New Roman'})
set([tx1, tx2, tx3, tx4], {'FontSize'}, {17})

% More plotting parameters
ax = gca; ax.FontSize = 25; ax.FontName = 'Times New Roman';
ax.XTick = [0,1/2-tau, 1/2, 1-tau, 1];
ax.XTickLabel = {'$0$', '$T - \tau$', '$T$',...
    '$2T - \tau$', '$2T$'};

% More plotting parameters
ax.YTick = [0,1/2,1];
ax.YTickLabel = {'$\beta_0 (1-\epsilon)$', ...
    '$\beta_0 (1 - \frac{\epsilon}{2})$',...
    '$\beta_0$'};

ax.TickLabelInterpreter = 'latex';
