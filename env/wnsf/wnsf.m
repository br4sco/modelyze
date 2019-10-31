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
uu = [u(t)];
yy = [y(t)];
ee = [e(t)];

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

[E, A, B, C, Ku, Ky] = mk_matrix_coefficients(dynamics_residual, output_res, diff(xx, t), xx, uu, ee)

[G, H] = mk_transfer_funs(s, E, A, B, C, Ku, Ky)

Gz = subs(G, s, 2 * (z - 1)/ (z + 1))
Hz = subs(H, s, 2 * (z - 1)/ (z + 1))

if Gz ~= 0
    [Fc, Ft, Lc, Lt] = collectcoeffs(z, Gz)
end

if Hz ~= 0
    [Dc, Dt, Cc, Ct] = collectcoeffs(z, Hz)
end

%% common denominator

% if Gz ~= 0 && Hz ~= 0
%     [Gn, Gd] = numden(Gz)
%     [Hn, Hd] = numden(Hz)

%     Fz = Gd * Hd
%     Lz = Gn * Hd
%     Cz = Gd * Hn

%     [Fzc, Fzt] = coeffs(collect(Fz, z), z)
%     [Lzc, Lzt] = coeffs(collect(Lz, z), z)
%     [Czc, Czt] = coeffs(collect(Cz, z), z)
% end

d = gcd(Gz, Hz)
Fz = collect(1 / d)
Lz = collect(Gz / d, z)
Cz = collect(Hz / d, z)

%% from determinant directly
[n, d] = numden(subs(det(s*E - A), s, 2 * (z - 1) / (z + 1)));
collect(n, z)

%% Functions

function [G, H] = mk_transfer_funs(s, E, A, B, C, Ku, Ky)
    X1X2 = (s * E - A) \ [B, Ku];
    X1 = X1X2(:, 1:size(C, 1));
    X2 = X1X2(:, size(C, 1) + 1:end);
    G = C * X1;
    H = C*X2 + Ky;
end

function [E, A, B, C, Ku, Ky] = mk_matrix_coefficients(dae, output, dx, x, u, e)
  dxs = sym('dxs', [1, length(dx)]);
  xs = sym('xs', [1, length(x)]);
  us = sym('us', [1, length(u)]);
  es = sym('es', [1, length(e)]);

  tmp_dae = subs(dae, dx(:), dxs(:));
  tmp_dae = subs(tmp_dae, x(:), xs(:));
  tmp_dae = subs(tmp_dae, u(:), us(:));
  tmp_dae = subs(tmp_dae, e(:), es(:));
  tmp_output = subs(output, x(:), xs(:));
  tmp_output = subs(tmp_output, e(:), es(:));

  E = jacobian(tmp_dae, dxs(:));
  A = -jacobian(tmp_dae, xs(:));
  B = -jacobian(tmp_dae, us(:));
  Ku = -jacobian(tmp_dae, es(:));
  C = -jacobian(tmp_output, xs(:));
  Ky = -jacobian(tmp_output, es(:));
end

function [Fc, Ft, Lc, Lt, Dc, Dt, Cc, Ct] = mk_rational_transfer_funs(z, G, H)
  [Lc, Lt, Fc, Ft] = collectcoeffs(z, G);
  [Cc, Ct, Dc, Dt] = collectcoeffs(z, H);
end

function [nc, nt, dc, dt] = collectcoeffs(z, A)
  [n, d] = numden(A);
  [nc, nt] = coeffs(collect(n, z), z);
  [dc, dt] = coeffs(collect(d, z), z);
  nc = nc / dc(1);
  dc = dc / dc(1);
  if polynomialDegree(nt(1)) > polynomialDegree(dt(1))
      nt = nt / nt(1);
      dt = dt / nt(1);
  else
      nt = nt / dt(1);
      dt = dt / dt(1);
  end
end