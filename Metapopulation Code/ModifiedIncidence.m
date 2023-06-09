function O = ModifiedIncidence(rho_col, rho_ext, patches, tsteps, seed, ...
    ext_prob, c, init_frac_occ)
% This is Hanski's incidence model but with two changes. One, the 
% colonization probability now depends on the number of occupied patches
% rather the square of the number of occupied patches. Two, all the patches
% are assumed to be of equal size and equally connected to one another. As
% such, this is a reasonable finite patch model version of the Lenski
% metapopulation model.

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
    col_prob = N(t-1)/(N(t-1) + c);

    Extinct_Patches = O(:,t-1) == 0;
    Occupied_Patches = O(:,t-1) == 1;
    O(Extinct_Patches,t) = Ucol(t-1,Extinct_Patches) < col_prob;
    O(Occupied_Patches,t) = Uext(t-1,Occupied_Patches) > ext_prob;
end

end