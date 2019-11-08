function y = arx_next(eta_a,eta_b,u,y)
na = length(eta_a);
nb = length(eta_b);
yr = y(length(y));
ur = u(lenght(u));
y = eta_a'*yr + eta_b'*ur;
end

