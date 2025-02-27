function qdot = quat_derivative(q, w)

qdot = .5 * Omega_w(w) * q;

end