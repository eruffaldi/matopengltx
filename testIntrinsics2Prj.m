%%
syms fx fy cx cy n f w h real;

K = [fx 0 cx; 0 fy cy; 0 0 1];
P = mcvIntrinsics2Prj(K,n,f,w,h)
[Ko,no,fo] = mcvPrj2Intrinsics(P,w,h);
% these should be exactly as original
simplify(Ko)
simplify(no)
simplify(fo)

% let's look at how they map to mglFrustum params
s = mglInvFrustum(P);
ff = fieldnames(s);
for I=1:length(ff)
    disp(ff{I})
simplify(s.(ff{I}))
end


%%
% Then let's verify if the mcvIntrinsics2Prj worksout in general passing
% the processing of OpenGL
syms X Y Z w h n f real;
syms fx fy cx cy  real;
range_n=0;
range_f=1;

K = [fx 0 cx; 0 fy cy; 0 0 1];
V = [0,0,w,h];
P2W = mcvPlate2glWindow(h,n,f,range_n,range_f);
P = mcvIntrinsics2Prj(K,n,f,w,h);
pgl = mglProject([X,Y,Z],P,V,range_n,range_f); % z of pgl is in window space
ipgl = mglUnproject(pgl,P,V,range_n,range_f);
zpgl = mglWindowDepth2Depth(pgl(3),P,range_n,range_f);
simplify(ipgl - [X,Y,Z,1]') % ZERO
simplify(zpgl)

pcv = mcvProject([X,Y,Z],K); 
pcv2gl = P2W*pcv;
simplify(subs(pgl,[X,Y,Z],[0,0,n])) % cx cy 0 1
simplify(subs(pgl,[X,Y,Z],[0,0,f])) % cx cy 1 1
simplify(P2W*[0,0,1/n,1]') == [0,h,0,1]'
simplify(P2W*[0,0,1/f,1]') == [0,h,1,1]'

%% Simplify/Expand
syms Df Dn wd real
syms T1 T2 E1 real;
nz = (2*wd-Df-Dn)/(Df-Dn);
d = -T2/(E1*nz-T1);
collect(d,wd)