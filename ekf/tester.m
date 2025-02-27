function states = tester()


x0 = [1 0 0 0 0 0 0];
a= (.5*pi/180)^2;
b = (.3*pi/180)^2;
P = diag([3*a 3*a b b b b b]) * 1e1;
%P = eye(7);
w0 = [-1*pi/180 5*pi/180 0];
%q0 = [1 0 0 0];
q0 = eul2quat([-pi/6 pi/8 pi/12]);
true = [q0 w0];

ekf_data.MOI = eye(3);
ekf_data.MOI_inv = inv(ekf_data.MOI);
%ekf_data.Q = diag([[1 1 1 1] * 0.00005, [1 1 1] * 0.000001] .^ 2);
ekf_data.Q = diag([1 1 1 10 10 10 10] * 1e-6);
ekf_data.R = diag([[1 1 1] * 0.045, [1 1 1] * 0.015]);
%ekf_data.R = diag([a a b b b b]);



tf = 60 * .5; %seconds
t0 = 0;
dt = .1; %seconds
num_points = (tf-t0)/dt;
t = linspace(t0, tf, num_points);

true_states = zeros(num_points, 7);
true_eul = zeros(num_points, 3);
noise_eul = zeros(num_points, 3);
ekf_states = zeros(num_points, 7);
ekf_eul = zeros(num_points, 3);
ekf_cov = zeros(num_points, 3);

quat_err = zeros(num_points, 4);

x = x0;


for i =1 :num_points
    %prop true state
    true = ode45(@(t, y) state_transition(t, y, ekf_data), [0 dt], true);
    true = true.y(:,end);
    true_states(i, :) = true;
    true_eul(i, :) = quat2eul(true(1:4)');
    
    noise_eul(i, :) = true_eul(i, :) + (0 + randi([-100 100])*2e-3);
    noise_quat = eul2quat(noise_eul(i, :));
    %sensors TODO add noise
    declination = 0;
    m = mag_model(declination, noise_quat);
    a = accel_model(true);
    y = [a m]';
    w = true(5:7) * (1 + rand()*1e-3);

    x(5:7) = w;
    [x, P] = ekf_step(x, P, ekf_data, y, dt);
    ekf_states(i, :) = x;
    ekf_cov(i, :) = [P(1,1) P(2,2) P(3,3)];
    ekf_eul(i, :) = quat2eul(x(1:4)');

    quat_err(i, :) = quatmultiply(quatconj(true(1:4)'), x(1:4)')';
end

if 1

f1 = figure;
figure(f1);
subplot(3,1,1);
plot(t,noise_eul(:,1) * 180/pi)
grid;
hold on;
plot(t,ekf_eul(:, 1)* 180/pi)
title('phi')
legend('true state roll','Kalman filter roll')
ylabel('angle [deg]')
xlabel('time [s]')
savefig(f1, "kalman_roll");


f2 = figure;
figure(f2);
subplot(3,1,1);
plot(t,noise_eul(:,2) * 180/pi);
grid;
hold on;
plot(t,ekf_eul(:, 2)* 180/pi);
title('theta')
legend('true state pitch','Kalman filter pitch')
ylabel('angle [deg]')
xlabel('time [s]')
savefig(f2, "kalman_pitch");


f3 = figure;
figure(f3);
subplot(3,1,1);
plot(t,noise_eul(:,3) * 180/pi);
grid;
hold on;
plot(t,ekf_eul(:, 3)* 180/pi);
title('psi')
legend('true state yaw','Kalman filter yaw')
ylabel('angle [deg]')
xlabel('time [s]')
savefig(f3, "kalman_yaw");


f4 = figure;
figure(f4);
subplot(4,1,1);
plot(t,ekf_cov(:,1) );
grid;
hold on;
plot(t,ekf_cov(:, 2));
grid;
hold on;
plot(t,ekf_cov(:,3) );
title('Ekf covariance')
legend('Pxx ','Pxx ', 'Pzz')
ylabel('')
xlabel('time [s]')
savefig(f4, "kalman_cov");


f5 = figure;
figure(f5);
subplot(5,1,1);
plot(t,quat_err(:,1) );
grid;
hold on;
plot(t,quat_err(:, 2));
grid;
hold on;
plot(t,quat_err(:,3) );
grid;
hold on;
plot(t,quat_err(:,4) );
title('Ekf quaternion error')
legend('w ','x ', 'y', 'z')
ylabel('')
xlabel('time [s]')
savefig(f5, "kalman_quat");
end

f6 = figure;
figure(f6);
subplot(6,1,1);
plot(t,vecnorm(quat_err(:, 2:4)'));
grid;
hold on;
title('Ekf quaternion error norm')
legend('norm ')
ylabel('')
xlabel('time [s]')
savefig(f6, "kalman_norm");



states.q_err = quat_err;

end