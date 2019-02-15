model falling_ball
  Real Fx_f_1;
  Real Fy_f_1;
  Real x_f_1;
  Real y_f_1;
  Real T_1;
  Real Fy_1;
  Real Fx_1;
  Real om_1;
  Real vy_1;
  Real vx_1;
  Real th_1;
  Real y_1 (start=10., fixed=true);
  Real x_1;
equation
 der(x_1) = vx_1;
 der(y_1) = vy_1;
 Fx_1 = 1. * der(vx_1);
 Fy_1 = 1. * der(vy_1);
 der(th_1) = om_1;
 T_1 = 1. * der(om_1);
 Fx_f_1 = 0.;
 Fy_f_1 = 9.81;
 T_1 = 0.;
 (x_1 + (-1.) * x_f_1) = 0.;
 (y_1 + (-1.) * y_f_1) = 0.;
 (Fx_f_1 + 1. * Fx_1) = 0.;
 (Fy_f_1 + 1. * Fy_1) = 0.;
end falling_ball;

