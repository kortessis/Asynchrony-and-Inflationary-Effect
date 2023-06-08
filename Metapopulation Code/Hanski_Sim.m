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
% fraction of patches occupied, conditional on 

rho_col = 0;
rho_ext = linspace(0.05,0.95,10);
patches = 25;
tsteps = 100;
ext_prob = 0.25;
c = 0.5*patches;
init_frac_occ = 0.5;

% Repeat to get extinction probabilities
reps = 50;
ext_time = nan(length(rho_ext),reps);

for i = 1:length(rho_ext)
    for r = 1:reps
        N = init_frac_occ*patches;
        count = 0;
        while N(end) ~= 0
            O = HanskiIncidence(rho_col, rho_ext(i), patches, tsteps, nan, ...
                ext_prob, c, N(end)/patches);
            N = [N,ones(1,patches)*O(:,2:end)];
            count = count+1;
        end

        if count == 1
            ext_time(i,r) = find(N == 0,1,'first')-1;
        else
            ext_time(i,r) = (count-1)*tsteps + find(N==0,1,'first')-1;
        end

        Npers = N(N>0);
        cond_occ = mean(Npers)/patches;

        ['rho vector ', num2str(i/length(rho_ext)*100), '% done. replicates ',...
            num2str(r/reps*100), '% done']
    end
end

pt_colors = viridis(length(rho_ext)+2);
pt_colors = pt_colors(2:end-1,:);

semilogy(2,1); xlim([0,1]); ylim([1,max(max(ext_time))]);
grid on; hold on;
for i = 1:length(rho_ext)
    scatter(rho_ext(i)*ones(1,reps) + normrnd(0,0.005,[1,reps]), ...
        ext_time(i,:), 'filled', 'SizeData', 75,...
        'MarkerEdgeColor','black','MarkerFaceColor',pt_colors(i,:));
end
plot(rho_ext, mean(ext_time,2),'black')
scatter(rho_ext, mean(ext_time,2), 'Filled', 'Marker', 'square',...
    'SizeData', 250, 'CData',pt_colors, 'MarkerEdgeColor','black');
hold off;

ax = gca; ax.FontSize = 25; ax.FontName = 'Times New Roman';
xlabel('Correlation among patch extinction events, \rho_{\itE}');
ylabel('Time to Extinction');
title('Asynchrony drastically extinds time to extinction');
ax.YTickLabels = [1, 100, 10000, 1000000];

