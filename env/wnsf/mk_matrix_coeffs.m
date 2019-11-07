function [E, A, B, C, Ku, Ky] = mk_matrix_coeffs(dae, output, dx, x, u, e)
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
