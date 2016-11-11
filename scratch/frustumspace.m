

% Given the intrinsics: f and cx,cy (in pixels)
% Compute the frustum

% Adapt OpenGL frustum from world to NDC (X right +, Y up +, Z along original Z but with near/far in negative)
% to Vision in which (X right +, Y down +, Z along camera)
% 
% Note: camera is 
pixsize = [640,480];
ps_m = 6e-6;
sensorsize_m = ps_m*pixsize;

rr = [-sensorsize_m(1)*0.5,0.5*sensorsize_m(1)*0.5,-sensorsize_m(2)*0.5,sensorsize_m(2)*0.5,0.2,2.0];
F = mglFrustum(rr);
ps = [0.01,0.02];

p0_pix = [130,500];
p0 = p0_pix*ps_m;
F2 = mglFrustum(p0(1)-ps_m/2,p0(1)+ps_m/2,p0(2)-ps_m/2,p0(2)+ps_m/2,rr(5),rr(6));
%% points
[h,p] = drawfrustum(F);
set(h,'FaceColor','none','EdgeColor','k');
[h,p] = drawfrustum(F2);
set(h,'FaceColor','b','EdgeColor','m');

hold on
scatter3(p(:,1),p(:,2),p(:,3));
hold off
axis equal
xlabel('X');
ylabel('Y');
zlabel('Z');