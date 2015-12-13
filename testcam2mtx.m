addpath mgl
% given the directions of lookat
fwd = [1,0,0];
up = [0,1,0];
pos = [0.7,0.5,0.2];

% gluLookAt -> mtx -> cam
V = mglulookat(pos,pos+fwd,up);
[M1,M2] = cam2mtx(V);
[V11,V12] = mtx2cam(M1); %V==V11 and V==V12
[V21,V22] = mtx2cam(M2); %V==V21 and V==V22
assert(all(all(V11==V)));
assert(all(all(V12==V)));
assert(all(all(V21==V)));
assert(all(all(V22==V)));

% mtx -> cam -> mtx
MX = eye(4);
MX(1:3,1) = [0,0,1];
MX(1:3,2) = up;
MX(1:3,3) = fwd;
MX(1:3,4) = pos;

[VX1,VX2] = mtx2cam(MX);
[MX11,MX12] = cam2mtx(VX1);
[MX21,MX22] = cam2mtx(VX2);

assert(all(all(MX11==MX)));
assert(all(all(MX12==MX)));
assert(all(all(MX21==MX)));
assert(all(all(MX22==MX)));

%mlookAtRH has no negative flip in Z
VRH = mlookAtRH(pos,pos+fwd,up);

VRH
V

