function xdot = state_transition(t, x, ekf_data)
% xdot = F(x)
    q = x(1:4);
    w = x(5:7);

    qdot = quat_derivative(q,w);
    H = ekf_data.MOI * w;

    cx = cross(w, H);
    Tctrl = zeros(3,1);
    pqrdot = ekf_data.MOI_inv * (Tctrl - cx);

    xdot = [qdot; pqrdot;];
end
