function [x, P ] = predict(xp,Pp,ekf_data, dt)

[t, x] = ode45(@(t, y) state_transition(t, y, ekf_data), [0 dt], xp);
x = x(end, :);
%should below be xp?
%[t, P] = ode45(@(t,y) covarianceTransition(t,y,x,ekf_data), [0 dt], Pp);
%P = P.y(:,end);
P = Pp+ covarianceTransition(0, Pp, x, ekf_data) * dt;

x = normalizeq(x);

end