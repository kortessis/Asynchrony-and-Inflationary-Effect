function O = LevinsMetaPop(rho_col, rho_ext, patches, tsteps, deltat, ...
    seed, e, c, init_frac_occ)
% This is a discrete-time version of Levins' metapopulation model, with
% the flexibility that we can consider correlated extinction and
% colonization probabilities among patches. 

% Pick a random seed if one is not chosen in the function
if ~isnan(seed)
    rng(seed);
end

% Specify the distribution of the latent variables for extinction
% and colonization. The distribution is assumed to be multivariate
% standard normal, with number of dimensions as the number of patches.
% The idea here is that each patch has a latent variable indicating
% whether conditions are favorable for exitnction or colonization. 
% By specifying the correlation of these latent variables, we make
% an assumption about similar the patterns of these are across patches
% over time. If they are similar, many patches go extinct (or are 
% colonized) close in time. 

% Set latent variable means as zero.
Mu = zeros(patches,1);

% Specify the covariance matrices for colonization and extinction 
% latent variables.
Sigma_col = rho_col*ones(patches) + eye(patches)*(1-rho_col);
Sigma_ext = rho_ext*ones(patches) + eye(patches)*(1-rho_ext);

% Randomly sample the latent variabels for the number of time steps.
Xext = mvnrnd(Mu, Sigma_ext, tsteps);
Xcol = mvnrnd(Mu, Sigma_col, tsteps);

% Transform the latent variables to uniform variables.
Uext = normcdf(Xext);
Ucol = normcdf(Xcol);

% Create vectors to hold occupancy of the patches.
O = zeros(patches,tsteps);

% Initialize occupancy given the initial fraction occupied.
O(1:round(init_frac_occ*patches),1) = 1;

% Create a vector to hold number occupied at each time step.
N = nan(1, tsteps);

% Loop over time
for t = 2:tsteps
    % Calculate occupied patches
    N(t-1) = sum(O(:,t-1));

    % Calculate small time extinction and colonization probabilities
    col_prob = 1-exp(-c*deltat*N(t-1)/patches);
    ext_prob = 1-exp(-e*deltat);

    % Find which patches are extinct and occupied and determine whether
    % they change state based on the latent variables Ucol and Uext
    Extinct_Patches = O(:,t-1) == 0;
    Occupied_Patches = O(:,t-1) == 1;
    O(Extinct_Patches,t) = Ucol(t-1,Extinct_Patches) < col_prob;
    O(Occupied_Patches,t) = Uext(t-1,Occupied_Patches) > ext_prob;
end

end