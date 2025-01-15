function [x, P] = update(xp, Pp,y, R)
%y = [a3 m3]
declination = 0;
H = observation(xp, declination);

K = Pp*H'/(H*Pp*H' + R);
P = (eye(7) - K*H) * Pp;

m = mag_model(declination, xp);
a = accel_model(xp);
z = [a m]';
x = xp + K*(y-z);
normalizeq(x);

end