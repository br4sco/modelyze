function R = mk_R(phi,N,n_a,n_b)
n = max(n_a,n_b);
R = phi(n_a,n_b,n+1)*phi(n_a,n_b,n+1)';
for t=n+2:N
    if t+n <= N
        R = R + phi(n_a,n_b,t)*phi(n_a,n_b,t)';
    end
end
R = R/N;
end