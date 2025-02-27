%{
function states = simulator(Qmag, Rmag, plot)

if Rmag~= 0 
    Rmag = 1
end
if Qmag ~=0
    Qmag = 1
end
if plot ~= 0
    plot=1
end
%}
function states = simulator()
addpath("./ekf/")



time_length =1* 60 ;
step_size = .01;

seastate = 3;
true_states = ekf_simulator(time_length, step_size, seastate);



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
Q = diag([[1 1 1 1] * 0.00005, [1 1 1] * 0.000001] .^ 2) * 1e-2;
%measurement noise matrix
R = diag([[1 1 1] * 0.045, [1 1 1] * 0.015]) * 1e-2;
        
%state space init
x = [e0 e1 e2 e3 pb qb rb]';
data_points = time_length * 1/step_size; % (minimum 120 data points)
dt = step_size;

gxs = diff([true_states(1,:) 0]) / dt;
gys = diff([true_states(2,:) 0]) / dt;
%gxs = true_states(3,:);
%gys = true_states(4,:);
    

for i=1:data_points
    

%sensor data


gx = gxs(i);
gy = gys(i);

gz = gy * 0;
quats = eul2quat([0*true_states(1,i); true_states(2,i); true_states(1,i)]')'; %defaults to zyx
a = accel_model(quats);
ax = a(1) ;
ay = a(2) ;
az = a(3) ;
m = mag_model(0, quats);
mx = m(1) ;
my = m(2) ;
mz = m(3) ;
p = gx; q = gy; r = gz;
y = [-ax -ay -az mx my mz]';
measure = [p q r y']' ;

[x, P] = ekf_step(x, P, Q, R, measure, dt);

e0 = x(1);
e1 = x(2);
e2 = x(3);
e3 = x(4);


eul = quat2eul(x(1:4, :)');
phi(i) = eul(3) * 180/pi;
theta(i) = eul(2) * 180/pi;
psi(i) = eul(1) * 180/pi;

%phi(i) = atan2((2*(e0*e1+e3*e2)),1-2*(e1^2+e2^2))*180/pi;
%theta(i) = asin(2*(e0*e2-e3*e1))*180/pi;
%psi(i) = atan2((2*(e0*e3+e1*e2)),1-2*(e2^2+e3^2))*180/pi;

Pxx(i) =P(1,1);
Pyy(i) =P(2,2);
Pzz(i) =P(3,3);

xs(i, :) = x;

end
if plot
time = linspace(0,time_length,data_points);
%plots
f1 = figure;
figure(f1);
subplot(3,1,1);
plot(time,true_states(2,:) * 180/pi);
grid;
hold on;
plot(time,theta);
title('theta')
legend('true state pitch','Kalman filter')
ylabel('angle [deg]')

subplot(3,1,2)
plot(time,true_states(1,:) * 180/pi);
grid;
hold on;
plot(time,phi);
title('phi')
legend('True state roll','Kalman filter')
ylabel('angle [deg]')






f3 = figure;
figure(f3);
subplot(3,1,1);
plot(time, xs(:,1));
grid;
hold on;
plot(time, xs(:,2));
plot(time, xs(:,3));
plot(time, xs(:,4));

legend('q1', 'q2', 'q3', 'q4')

f4 = figure;
figure(f4);
subplot(4,1,1);
plot(time, abs(theta - true_states(2,:) * 180/pi));
grid;
hold on;
plot(time, abs(phi - true_states(1,:) * 180/pi));

legend('theta error', 'phi error')



f5 = figure;
figure(f5);
subplot(5,1,1);
plot(time, Pxx);
grid;
hold on;
plot(time, Pyy);
plot(time, Pzz);
legend('pxx', 'pyy', 'pzz')






end


states.ekf= [phi; theta;];
states.true = true_states * 180/pi;

end