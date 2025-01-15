function rnb = Rnb(q)
q0 = q(1);
q1 = q(2);
q2 = q(3);
q3 = q(4);
q02 = q0*q0;
q12 = q1*q1;
q22 = q2*q2;
q32 = q3*q3;

rnb = [q02+q12-q22-q32 2*(q1*q2-q0*q3) 2*(q1*q3+q0*q2);
       2*(q1*q2+q0*q3) q02-q12+q22-q32 2*(q2*q3-q0*q1);
       2*(q1*q3-q0*q2) 2*(q2*q3+qo*q1) q02-q12-q22+q32];

end



function [phi, theta, psi] = q2eul(q)
e0 = q(1);
e1 = q(2);
e2 = q(3);
e3 = q(4);
phi   = atan2((2*(e0*e1+e3*e2)),1-2*(e1^2+e2^2))*180/pi;
theta = asin(2*(e0*e2-e3*e1))*180/pi;
psi   = atan2((2*(e0*e3+e1*e2)),1-2*(e2^2+e3^2))*180/pi;


end













