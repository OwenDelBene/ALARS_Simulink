function [x, P] = ekf_step(xp, Pp, ekf_data, y, dt)
    
    [x, P] = predict(xp, Pp, ekf_data, dt);

    [x, P] = update(x, P, y, ekf_data);
end