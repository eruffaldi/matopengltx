% Given a Camera View matrix (e.g. from look at) it builds a Pose Matrix
function [M,W] = cam2mtx(V)

Rz = V(1:3,1:3);
t = V(1:3,4);

te = -Rz'*t; % reverse -Rz*t

% remove the z flip and then transpose
Rz(3,1:3) = -Rz(3,1:3);
R = Rz';

M = eye(4);
M(1:3,1:3) = Rz;
M(1:3,4) = te;

% or flip Z and invert
W = V;
W(3,1:4) = -W(3,1:4);
W = inv(W);
