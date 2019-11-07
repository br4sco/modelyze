function [G, H] = mk_transfer_funs(s, E, A, B, C, Ku, Ky)
    X1X2 = (s * E - A) \ [B, Ku];
    X1 = X1X2(:, 1:size(C, 1));
    X2 = X1X2(:, size(C, 1) + 1:end);
    G = C * X1;
    H = C*X2 + Ky;
end
