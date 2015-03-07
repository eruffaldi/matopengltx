function M = mlookAtRH(e,target,up)

e = e(:);
target = target(:);
z = mnormalize(e-target)';
x = mnormalize(cross(up,z));
y = cross(z,x);
M = [ x,  -x*e; y  -y*e; z, -z*e; 0 0 0 1];