syms theta x y z real;

c = cos(theta/2);
s = sin(theta/2);
q = [x*s,y*s,z*s,c];
qq = q.^2;

tr = 3*qq(4)-qq(1)-qq(2)-qq(3);

acos(simplify((tr-1)/2))