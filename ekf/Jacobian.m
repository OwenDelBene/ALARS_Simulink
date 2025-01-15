function A = Jacobian(x, w)
e0 = x(1);
e1 = x(2);
e2 = x(3);
e3 = x(4);
pb = x(5);
qb = x(6);
rb = x(7);
p = w(1);
q = w(2);
r = w(3);

A = 0.5*[0 -(p-pb) -(q-qb) -(r-rb) e1 e2 e3;
        (p-pb) 0 (r-rb) -(q-qb)  -e0 e3 -e2;
        (q-qb) -(r-rb) 0 (p-pb)  -e3 -e0 e1;
        (r-rb) (q-qb) -(p-pb) 0   e2 -e1 -e0;
        0        0       0    0   0  0   0;
        0        0       0    0   0  0   0;
        0        0       0    0   0  0   0];
end