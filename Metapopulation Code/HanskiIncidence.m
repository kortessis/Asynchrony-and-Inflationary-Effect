function O = HanskiIncidence(rho_col, rho_ext, patches, tsteps, seed, ...
    ext_prob, c, init_frac_occ)

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
O(:,1) = rand(patches,1) > (1 - init_frac_occ);
N = nan(1, tsteps);

for t = 2:tsteps
    N(t-1) = sum(O(:,t-1));
    col_prob = N(t-1)^2/(N(t-1)^2 + c^2);

    Extinct_Patches = O(:,t-1) == 0;
    Occupied_Patches = O(:,t-1) == 1;
    O(Extinct_Patches,t) = Ucol(t-1,Extinct_Patches) < col_prob;
    O(Occupied_Patches,t) = Uext(t-1,Occupied_Patches) > ext_prob;
end

end