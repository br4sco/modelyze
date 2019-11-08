function r = mk_r(phi,y,n_a,n_b)
N = length(y);
n = max(n_a,n_b);
r = phi(n_a,n_b,n+1)*y(n+1);
for t=n+2:N
    if t+n <= N
        r = r + phi(n_a,n_b,t)*y(t);
    end
end
r = r/N;
end