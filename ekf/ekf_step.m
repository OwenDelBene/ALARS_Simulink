





function [x, P] = ekf_step(xp, Pp, Q, R, measure, dt)
    w = measure(1:4);
    [x, P] = predict(xp, Pp,w, dt, Q);

    y = measure(4:end);
    [x, P] = update(x, P, y, R);
end