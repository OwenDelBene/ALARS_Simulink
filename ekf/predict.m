function [x, P ] = predict(xp,Pp,w, dt, Q)
ip = [w(1) w(2) w(3) xp(5) xp(6) xp(7)]';
F = state_transition(xp);
x = xp + dt*F*ip;
x = normalizeq(x);
A = Jacobian(x, w);

P = Pp + dt*(A*Pp+Pp*A' + Q);
end