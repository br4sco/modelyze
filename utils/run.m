model
M = incidenceMatrix(eqns, vars)
det(M)
isLowIndexDAE(eqns, vars)
[DAEs,DAEvars] = reduceDAEIndex(eqns,vars)
M_ = incidenceMatrix(DAEs, DAEvars)
det(M_)
isLowIndexDAE(DAEs,DAEvars)
[DAEs,DAEvars] = reduceRedundancies(DAEs,DAEvars)

f = daeFunction(DAEs, DAEvars)
F = @(t, Y, YP) f(t, Y, YP)

y0est = zeros(length(DAEvars) ,1);
yp0est = zeros(length(DAEvars) ,1);
opt = odeset('RelTol', 10.0^(-7), 'AbsTol' , 10.0^(-7));
[y0, yp0] = decic(F, 0, y0est, [], yp0est, [], opt);


[tSol,ySol] = ode15i(F, [0, 10.], y0, yp0, opt);
plot(tSol,ySol,'-o');

for k = 1:length(DAEvars)
  S{k} = char(DAEvars(k));
end

legend(S, 'Location', 'Best');
grid on;
