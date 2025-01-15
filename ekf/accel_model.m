function a = accel_model(x)
e0 = x(1);
e1 = x(2);
e2 = x(3);
e3 = x(4);

a = -[2*(e1*e3-e0*e2) 2*(e0*e1+e2*e3) 1-2*(e1^2+e2^2)];
end