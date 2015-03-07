function r = mglRotate(deg,x,y,z)

c = cos(deg*pi/180);
s = sin(deg*pi/180);
c1 = 1-c;

r = [x*x*c1+c, x*y*c1-z*s, x*z*c1+y*s, 0; x*y*c1+z*s, y*y*c1+c, y*z*c1-x*s, 0; x*z*c1-y*s , y*z*c1+x*s, z*z*c1+c,0; 0 0 0 1];
