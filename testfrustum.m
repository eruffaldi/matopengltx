addpath mgl
close all
q = frustum.gluPerspective(60,16/9,0.2,5);
q.visualize()
%[c,r] = q.getboundingsphere(); % now working
[c,r] = q.getboundingspherefast();
c(1) = c(1) + 20;
isint = q.intersectSphere(c,r)
[x,y,z] = sphere;
axis equal
hold on
h = surfl(r*x+c(1),r*y+c(2),r*z+c(3));
set(h, 'FaceAlpha', 0.5)
a = pi/3;
q2 = q.transformByRotPos([cos(a) -sin(a) 0; sin(a) cos(a) 0; 0 0 1],[0.5,0 -2.0]);
q2.visualize()
hold off

% this has to be clarified
q1oL = q.worldPointToLocal(q.getOrigin())
q2oL = q2.worldPointToLocal(q2.getOrigin())

q.pixelToLocal([0,0],640,480)
q.pixelToLocal([320,240],640,480)
q.pixelToWorld([0,0],640,480) 
q.pixelToWorld([320,240],640,480) % -near due to our convention of axis along -Z

%%
% alternative triangulation
%   express the epipolar line (actually a span from point on plate to end of frustum) of each point in 
%   3D World space and map it
%   into the normalized space of one of them.
%
%   Triangulation means to compute the minimum distance between each line
%   span

%%
tic
[ii1,oi1] = q.intersectFrustum(q2)
toc
tic
[ii2,oi2] = q.intersectFrustum2(q2)
toc
