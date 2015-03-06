syms x y z real
mpi = sym('pi');
p =[x y z];
zz = [0,0,-1];
yy = [0,1,0];

R1 = mglRotateRad(mpi/2,0,1,0);
zz = R1(1:3,3)';
yy = R1(1:3,2)';


asRH = mlookAtRH(p,p-zz,yy)
sGLU = mglulookat(p,p+zz,yy) % typical use