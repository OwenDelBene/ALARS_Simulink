function xdot = state_transition(x)
    e0 = x(1);
    e1 = x(2);
    e2 = x(3);
    e3 = x(4);
    xdot = 0.5*[-e1 -e2 -e3 e1 e2 e3;
         e0 -e3  e2 -e0 e3 -e2;
         e3  e0 -e1 -e3 -e0 e1;
        -e2  e1  e0 e2 -e1 -e0;
         0   0   0   0  0   0;
         0   0   0   0  0   0;
         0   0   0   0  0   0];
end