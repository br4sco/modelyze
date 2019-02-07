syms t  Fy_g_1(t) Fx_g_1(t) vy_g_1(t) vx_g_1(t) y_g_1(t) x_g_1(t) T_h_1(t) om_h_1(t) th_h_1(t) Fy_h2_1(t) Fx_h2_1(t) vy_h2_1(t) vx_h2_1(t) y_h2_1(t) x_h2_1(t) Fy_h1_1(t) Fx_h1_1(t) vy_h1_1(t) vx_h1_1(t) y_h1_1(t) x_h1_1(t) T_r2_1(t) om_r2_1(t) th_r2_1(t) T_r1_1(t) om_r1_1(t) th_r1_1(t) Fy_r1_1(t) Fx_r1_1(t) vy_r1_1(t) vx_r1_1(t) y_r1_1(t) x_r1_1(t) T_m_1(t) om_m_1(t) th_m_1(t) Fy_m_1(t) Fx_m_1(t) vy_m_1(t) vx_m_1(t) y_m_1(t) x_m_1(t)

vars = [  Fy_g_1(t) Fx_g_1(t) vy_g_1(t) vx_g_1(t) y_g_1(t) x_g_1(t) T_h_1(t) om_h_1(t) th_h_1(t) Fy_h2_1(t) Fx_h2_1(t) vy_h2_1(t) vx_h2_1(t) y_h2_1(t) x_h2_1(t) Fy_h1_1(t) Fx_h1_1(t) vy_h1_1(t) vx_h1_1(t) y_h1_1(t) x_h1_1(t) T_r2_1(t) om_r2_1(t) th_r2_1(t) T_r1_1(t) om_r1_1(t) th_r1_1(t) Fy_r1_1(t) Fx_r1_1(t) vy_r1_1(t) vx_r1_1(t) y_r1_1(t) x_r1_1(t) T_m_1(t) om_m_1(t) th_m_1(t) Fy_m_1(t) Fx_m_1(t) vy_m_1(t) vx_m_1(t) y_m_1(t) x_m_1(t)]

eqns = [diff(x_m_1(t)) == vx_m_1(t)
diff(y_m_1(t)) == vy_m_1(t)
Fx_m_1(t) == (-1.) * diff(vx_m_1(t))
Fy_m_1(t) == (-1.) * diff(vy_m_1(t))
diff(th_m_1(t)) == om_m_1(t)
T_m_1(t) == (-1.) * diff(om_m_1(t))
x_r1_1(t) == (-1.) * cos(th_r2_1(t))
y_r1_1(t) == (-1.) * sin(th_r2_1(t))
diff(vx_r1_1(t)) == 1. * (om_r2_1(t) * om_r2_1(t) * x_r1_1(t) - diff(om_r2_1(t)) * (-sin(th_r2_1(t))))
diff(vy_r1_1(t)) == 1. * (om_r2_1(t) * om_r2_1(t) * y_r1_1(t) - diff(om_r2_1(t)) * cos(th_r2_1(t)))
th_r1_1(t) == 0.
diff(th_r1_1(t)) == om_r1_1(t)
diff(th_r2_1(t)) == om_r2_1(t)
T_r2_1(t) == (1. * sin(th_r2_1(t)) * Fx_r1_1(t) + 1. * (-cos(th_r2_1(t))) * Fy_r1_1(t))
x_h1_1(t) == 0.
y_h1_1(t) == 0.
diff(x_h1_1(t)) == vx_h1_1(t)
diff(y_h1_1(t)) == vy_h1_1(t)
Fx_h2_1(t) == 0.
Fy_h2_1(t) == 0.
diff(x_h2_1(t)) == vx_h2_1(t)
diff(y_h2_1(t)) == vy_h2_1(t)
diff(th_h_1(t)) == om_h_1(t)
T_h_1(t) == 0.
diff(x_g_1(t)) == vx_g_1(t)
diff(y_g_1(t)) == vy_g_1(t)
Fx_g_1(t) == 0.
Fy_g_1(t) == (-9.81)
((th_r1_1(t) + (-1.) * th_h_1(t)) + 1. * th_r2_1(t)) == 0.
(th_m_1(t) + (-1.) * th_r2_1(t)) == 0.
(T_h_1(t) + 1. * T_r1_1(t)) == 0.
((T_r2_1(t) + (-1.) * T_r1_1(t)) + 1. * T_m_1(t)) == 0.
(x_h1_1(t) + (-1.) * x_h2_1(t)) == 0.
(y_h1_1(t) + (-1.) * y_h2_1(t)) == 0.
((x_r1_1(t) + 1. * x_g_1(t)) + (-1.) * x_h2_1(t)) == 0.
((y_r1_1(t) + 1. * y_g_1(t)) + (-1.) * y_h2_1(t)) == 0.
(x_m_1(t) + (-1.) * x_g_1(t)) == 0.
(y_m_1(t) + (-1.) * y_g_1(t)) == 0.
((Fx_g_1(t) + (-1.) * Fx_r1_1(t)) + 1. * Fx_m_1(t)) == 0.
((Fy_g_1(t) + (-1.) * Fy_r1_1(t)) + 1. * Fy_m_1(t)) == 0.
((Fx_h2_1(t) + 1. * Fx_h1_1(t)) + 1. * Fx_r1_1(t)) == 0.
((Fy_h2_1(t) + 1. * Fy_h1_1(t)) + 1. * Fy_r1_1(t)) == 0.]


