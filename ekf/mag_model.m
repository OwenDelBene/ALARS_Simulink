function m = mag_model(dm, x)
e0 = x(1);
e1 = x(2);
e2 = x(3);
e3 = x(4);

%magnetic declination angle
msin=sind(dm); 
mcos=cosd(dm);

m =[msin*(2*e0*e3+2*e1*e2)-mcos*(2*e2*e2+2*e3*e3-1)...
    -mcos*(2*e0*e3-2*e1*e2)-msin*(2*e1*e1+2*e3*e3-1)...
    mcos*(2*e0*e2+2*e1*e3)-msin*(2*e0*e1-2*e2*e3)];
end