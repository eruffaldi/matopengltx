
%
% Look At as generic object matrix (with Z pointing)
%
function M = lookat(O,T,up)

O=O(:);
T=T(:);
up=up(:);
f = normalize(O-T);
u = normalize(up);
s = cross(f,u);
R = [s,u,-f,O];
R
M = [R; 0 0 0 1];



function y = normalize(x)

y = x./norm(x);