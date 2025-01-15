%https://www.researchgate.net/publication/283175307_Quaternion-Based_Kalman_Filter_for_AHRS_Using_an_Adaptive-Step_Gradient_Descent_Algorithm
%https://github.com/uBartek/AHRS-EKF/tree/master
load('data.mat');
addpath("./ekf/")
%quaternions
e0 = 1;
e1 = 0;
e2 = 0;
e3 = 0;

pb = 0; %bias p 
qb = 0; %bias q 
rb = 0; %bias r 

%covariance matrix
P = zeros(7,7);
%process noise matrix
Q = diag([[1 1 1 1] * 0.00005, [1 1 1] * 0.000001] .^ 2);
%measurement noise matrix
R = diag([[1 1 1] * 0.045, [1 1 1] * 0.015]);
        
%state space init
x = [e0 e1 e2 e3 pb qb rb]';

for i=2:length(time)
    dt = time(i) - time(i-1);
p = gx(i)*pi/180; q = gy(i)*pi/180; r = gz(i)*pi/180;
y = [-ax(i) -ay(i) -az(i) mx(i) my(i) mz(i)]';
measure = [p q r y']';

[x, P] = ekf_step(x, P, Q, R, measure, dt);

e0 = x(1);
e1 = x(2);
e2 = x(3);
e3 = x(4);

phi(i) = atan2((2*(e0*e1+e3*e2)),1-2*(e1^2+e2^2))*180/pi;
theta(i) = asin(2*(e0*e2-e3*e1))*180/pi;
psi(i) = atan2((2*(e0*e3+e1*e2)),1-2*(e2^2+e3^2))*180/pi;

Pxx(i) =P(1,1);
Pyy(i) =P(2,2);
Pzz(i) =P(3,3);

end

%plots
f1 = figure;
figure(f1);
subplot(3,1,1);
plot(time,theta_komp);
grid;
hold on;
plot(time,theta);
title('theta')
legend('complementary filter','Kalman filter')
ylabel('angle [deg]')

subplot(3,1,2)
plot(time,phi_komp);
grid;
hold on;
plot(time,phi);
title('phi')
legend('complementary filter','Kalman filter')
ylabel('angle [deg]')

subplot(3,1,3)
plot(time,psi_komp);
grid;
hold on;
plot(time,psi);
title('psi')
legend('complementary filter','Kalman filter')
ylabel('angle [deg]')

f2 = figure;
figure(f2);
subplot(3,1,1);
plot(time,gx);
grid;
hold on;
plot(time,gy);
plot(time,gz);
title('gyro');
legend('p','q','r');
ylabel('angular velocity [deg/s]')

subplot(3,1,2)
plot(time,ax);
grid;
hold on;
plot(time,ay);
plot(time,az);
title('accelerometer')
legend('ax','ay','az')
ylabel('acceleration [g]')

subplot(3,1,3)
plot(time,ax);
grid;
hold on;
plot(time,ay);
plot(time,az);
title('magnetometer')
legend('mx','my','mz')
xlabel('time [s]')
ylabel('flux [G]')


f3 = figure;
figure(f3);
subplot(3,1,1);
plot(time, Pxx);
grid;
hold on;
plot(time, Pyy);
plot(time, Pzz);
legend('pxx', 'pyy', 'pzz')


