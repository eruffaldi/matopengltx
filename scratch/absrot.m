

syms q0 q1 q2 real;

z0 = [0,0,1];
R1 = mglRotateRad(q0,z0);
x1 = R1(1:3,1);
R2 = mglRotateRad(q1,x1);
z2 = R2(1:3,2);
R3 = mglRotateRad(q2,z2);


edi