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
%%
tic
[ii1,oi1] = q.intersectFrustum(q2)
toc
tic
[ii2,oi2] = q.intersectFrustum2(q2)
toc
