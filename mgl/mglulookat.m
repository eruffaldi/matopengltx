
%
% Look At as generic object matrix (with Z pointing)
%
function M = lookat(e,target,up)

e=e(:);
target=target(:);
up=up(:);
f = mnormalize(target-e);
u = mnormalize(up);
s = cross(f,u);
u = cross(s,f);
R = blkdiag([s,u,-f],1);
M = R * mgltranslate(-e);



function y = normalize(x)

y = x./norm(x);