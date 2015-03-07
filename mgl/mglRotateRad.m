function r = mglRotateRad(rad,x,y,z)

c = cos(rad);
s = sin(rad);
c1 = 1-c;

r = [x*x*c1+c, x*y*c1-z*s, x*z*c1+y*s, 0; x*y*c1+z*s, y*y*c1+c, y*z*c1-x*s, 0; x*z*c1-y*s , y*z*c1+x*s, z*z*c1+c,0; 0 0 0 1];
