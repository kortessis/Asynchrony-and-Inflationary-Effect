function O = LevinsMetaPop(rho_col, rho_ext, patches, tsteps, deltat, ...
    seed, e, c, init_frac_occ)
% This is a discrete-time version of Lenski's metapopulation model, with
% the flexibility that we can consider correlated extinction and
% colonization probabilities among patches. 

if ~isnan(seed)
    rng(seed);
end

Sigma_col = rho_col*ones(patches) + eye(patches)*(1-rho_col);
Sigma_ext = rho_ext*ones(patches) + eye(patches)*(1-rho_ext);
Mu = zeros(patches,1);
Xext = mvnrnd(Mu, Sigma_ext, tsteps);
Xcol = mvnrnd(Mu, Sigma_col, tsteps);

% Transform to uniform variables
Uext = normcdf(Xext);
Ucol = normcdf(Xcol);

O = zeros(patches,tsteps);
O(1:round(init_frac_occ*patches),1) = 1;
N = nan(1, tsteps);

for t = 2:tsteps
    N(t-1) = sum(O(:,t-1));
    col_prob = 1-exp(-c*deltat*N(t-1)/patches);
    ext_prob = 1-exp(-e*deltat);

    Extinct_Patches = O(:,t-1) == 0;
    Occupied_Patches = O(:,t-1) == 1;
    O(Extinct_Patches,t) = Ucol(t-1,Extinct_Patches) < col_prob;
    O(Occupied_Patches,t) = Uext(t-1,Occupied_Patches) > ext_prob;
end

end