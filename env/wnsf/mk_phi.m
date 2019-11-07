function phi = mk_phi(phi, y, u)
    N = length(y);

    for t=n+1:N
        if t+n <= N
            phi(t-n,:) = [-y(t:t+n-1) u(t-1:t+n-2)]
        end
    end
end
