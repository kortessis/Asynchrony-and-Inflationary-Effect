function global_r = TwoPatch_Global_r(rhi, rlo, m, overlap, cycle_length) 

% This function calculates the growth rate, little r, at the scale of the
% total number of infectious individuals in both patches over one period.

I = zeros(1,2);
burnin_cycles = 10; % This is the number of cycles to run the sim to get 
                    % rid of the initial conditions
tau = (1-overlap)/2; % Tau is the difference in time between the two
% patches in their enaction of social distancing

times1 = [0, 0.5-tau;... % Time points when both have r = rhi
    0.5-tau, 0.5;... % Time points when r1 = rlo and r2 = rhi
    0.5, 1-tau;... % Time points when r1 = r2 = rlo
    1-tau, 1]; % Time points when r1 = rhi and r2 = rlo

r1 = [rhi, rlo, rlo, rhi];
r2 = [rhi, rhi, rlo, rlo];

if overlap == 1
    times2 = [1,3];
else
    if overlap == 0
        times2 = [2,4];
    else
        times2 = 1:4;
    end
end

Inew = [];
Tnew = [];
I_init = 0.5*ones(1,2);

for p = 1:burnin_cycles + 1
    
    if p ~= 1
        I_init = Inew(end,:);
    end
    
    if p == burnin_cycles+1
        Tfinal = [];
        Ifinal = [];
        
        for i = times2
        
            if i == times2(1)
                init_cond = I_init;
            else
                init_cond = I(end,:);
            end
    
            [T,I] = ode45(@(t,I) ...
                ISink_Sink(t,I,r1(i),r2(i),m), cycle_length*((p-1)+linspace(times1(i,1), times1(i,2), 100)), init_cond);
            Tnew = [Tnew; T];
            Inew = [Inew; I];
            
            Tfinal = [Tfinal; T];
            Ifinal = [Ifinal; I];
        end
    else
        for i = times2
        
            if i == times2(1)
                init_cond = I_init;
            else
                init_cond = I(end,:);
            end
    
            [T,I] = ode45(@(t,I) ...
                ISink_Sink(t,I,r1(i),r2(i),m), cycle_length*((p-1)+linspace(times1(i,1), times1(i,2), 100)), init_cond);
            Tnew = [Tnew; T];
            Inew = [Inew; I];
        end
    end

end

 
global_r = log(sum(Ifinal(end,:))/sum(Ifinal(1,:)));

end