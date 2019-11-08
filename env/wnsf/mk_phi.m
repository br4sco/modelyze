function phi = mk_phi(y,u)
yr = flip(y);
ur = flip(u);
phi = @(na,nb,t) phif(yr,ur,na,nb,t);
end

function t_phi = phif(yr,ur,na,nb,t)
N = length(yr);
t_phi = [-yr(N-t+2:N-t+1+na); ur(N-t+1:N-t+nb)];
end