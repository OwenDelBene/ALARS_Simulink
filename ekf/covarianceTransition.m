function Pdot = covarianceTransition(t, Pp, x, ekf_data)

q = x(1:4);
w = x(5:7);

a11 = .5 * Omega_w(w);
a12 = .5 * Omega_q(q);

a21 = zeros(3,4);
a22 = dwdotdw(w, ekf_data);

F = [a11 a12;
     a21 a22;];

P1 = reshape(Pp, [7 7]);
Pdot = F*P1 + P1*F' + ekf_data.Q;
%Pdot = reshape(Pdot, [49 1]);
end