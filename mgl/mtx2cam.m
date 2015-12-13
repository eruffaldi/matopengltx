% Given a Matrix builds View
%
% OpenGL View Matrix = inverse of the camera, followed by flipping z axis
%
% Two ways
function [V,W] = mtx2cam(M)

R = M(1:3,1:3);
t = M(1:3,4);

Rz = R';
Rz(3,1:3) = -Rz(3,1:3);

V = eye(4);
V(1:3,1:3) = Rz;
V(1:3,4) = -Rz*t;

% using inversion and then flip z
W = inv(M);
W(3,1:4) = -W(3,1:4);

