function [nc, nt, dc, dt] = collect_coeffs(z, A)
  if A ~= 0
      [n, d] = numden(A);
      [nc, nt] = coeffs(collect(n, z), z);
      [dc, dt] = coeffs(collect(d, z), z);
      % nc = nc / dc(1);
      % dc = dc / dc(1);
      % if polynomialDegree(nt(1)) > polynomialDegree(dt(1))
      %     nt = nt / nt(1);
      %     dt = dt / nt(1);
      % else
      %     nt = nt / dt(1);
      %     dt = dt / dt(1);
      % end
  else
      nc = [];
      nt = [];
      dc = [];
      dt = [];
  end
end