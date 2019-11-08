%% read data
y_data = importdata("y");
u_data = importdata("u");
Ts = 0.01;
theta_d_k_m_true = importdata("theta_d_k_m");

%% arange data


%% symbols
syms ek t z s q d k m xd(t) vd(t) fd(t) xm(t) vm(t) fm(t) xk(t) fk(t) y(t) u(t) xs(t) xa(t) e(t)

%% DAE residual

terminal_res = [diff(xd(t)) - vd(t)
                diff(xm(t)) - vm(t)
                m * diff(vm(t)) - fm(t)
                fk(t) - k * xk(t)
                fd(t) - d * vd(t)];

topol_res = [xa(t) - xs(t)
             xm(t) - xs(t)
             xd(t) - xs(t)
             xk(t) - xs(t)
             fm(t) + fk(t) + fd(t) + u(t) + e(t)];

dynamics_residual = [terminal_res; topol_res]

output_res = y(t) - xs(t) - e(t)

xx = [xd(t); xm(t); vm(t); vd(t); fd(t); fm(t); xk(t); fk(t); xs(t); xa(t)];
uu = u(t);
yy = y(t);
ee = e(t);

%% ODE residual

% dynamics_residual = [diff(vm(t)) + (k / m) * xm(t) + (d / m) * vm(t) + (1 / m) * (u(t) + e(t))
%                      diff(xm(t)) - vm(t)
%                     ]

% output_res = y(t) - xm(t) - e(t)


% xx = [xm(t); vm(t)];
% uu = [u(t)];
% yy = [y(t)];
% ee = [e(t)];


%% matrix coefficients

[E, A, B, C, Ku, Ky] = mk_matrix_coeffs(dynamics_residual, output_res, diff(xx, t), xx, uu, ee)

[G, H] = mk_transfer_funs(s, E, A, B, C, Ku, Ky)

Gz = subs(G, s, 2 * (z - 1)/ (z + 1))
Hz = subs(H, s, 2 * (z - 1)/ (z + 1))


[Fc, Ft, Lc, Lt] = collect_coeffs(z, Gz)

[Dc, Dt, Cc, Ct] = collect_coeffs(z, Hz)

%% wnsf
scalef = 1;
y_data_scaled = scalef*y_data;
u_data_scaled = scalef*u_data;

%% step 1
na = 3;
nb = 1;

y_data_zeroed = [zeros(10*max(na,nb),1); y_data];
u_data_zeroed = [zeros(10*max(na,nb),1); u_data];

N = length(y_data_scaled);
phi = mk_phi(y_data_scaled,u_data_scaled);
R_N = mk_R(phi,N,na,nb)
r_N = mk_r(phi,y_data_scaled,na,nb)
eta_N = R_N\r_N


data = iddata(y_data_zeroed,u_data_zeroed,Ts);
sys = arx(data,[na,nb,0])
X = cell2mat(arrayfun(@(t) phi(3,3,t)',t','UniformOutput',false));
[~, coldep] = rref(X);

