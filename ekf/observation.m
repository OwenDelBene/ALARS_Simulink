function H = observation(x, dm)
e0 = x(1);
e1 = x(2);
e2 = x(3);
e3 = x(4);
msin=sind(dm); 
mcos=cosd(dm);
H = 2  * [e2 -e3 e0 -e1 0 0 0;
         -e1 -e0 -e3 -e2 0 0 0;
          0  2*e1 2*e2 0 0 0 0;
          e3*msin, e2*msin, e1*msin-2*e2*mcos, e0*msin-2*e3*mcos, 0,0,0;
          -e3*mcos, e2*mcos-2*e1*msin,  e1*mcos, -e0*mcos-2*e3*msin, 0,0,0;
           e2*mcos-e1*msin, e3*mcos-e0*msin, e0*mcos+e3*msin, e1*mcos+e2*msin, 0,0,0];

end