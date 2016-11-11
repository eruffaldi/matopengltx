
%https://www.opengl.org/wiki/Compute_eye_space_from_window_space
%Also https://www.opengl.org/registry/specs/ARB/fragment_coord_conventions.txt
%Also https://www.opengl.org/wiki/Depth_Buffer_Precision
%Nice Figures http://www.thecodecrate.com/opengl-es/opengl-viewport-matrix/

%M=perspecti
%[ xx  xx  xx  xx ]
%[ xx  xx  xx  xx ]
%[ 0   0   T1  T2 ]
%[ 0   0   E1   0 ]

% eye space
syms ez ew real
% projection matrix
syms T1 T2 E1 real
% depth range 0..1
syms Df Dn real
% window spaze with OpenGL convention (lower left is 0)
syms wz wx wy real
% viewport size. can assume Vx=Vy=0
syms Vx Vy Vw Vh real
Vx=0;
Vy=0;
%OpenGL assumes a lower-left origin for window coordinates and assumes
%    pixel centers are located at half-pixel coordinates.  This means
%    the XY location (0.5,0.5) corresponds to the lower-left-most pixel
%    in a window.
%OpenCV assumes a top-left origin for image plate and assumes pixel cen...
%    Y is down
cvplate_glwindow = [1,0,0;0,-1,1;0,0,1];


% sub part of projection matrix
Msub = [T1 T2; E1 0];
iMsub =inv(Msub);

% 
nz = (2*wz-Df-Dn)/(Df-Dn);
cw = T2/(nz-T1/E1);
cz = nz*cw;
ezw = iMsub*[cz;cw];
collect(ezw(1),wz)

%%
% Direct form
syms Z real
czw = Msub*[Z,1]';
nzw = czw/czw(2);
fwz = (nzw(1)*(Df-Dn)/2+(Df+Dn))/2

%% XY part
nx = (2*wx-2*Vx)/Vw-1;
ny = (2*wy-2*Vy)/Vh-1;
cx = nx*cw;
cy = ny*cw;
C = [cx,cy,cz,cw];

syms pn pf pr pl pt pb real
syms fx fy cx cy real
E = -1;
%T1 = (pf+pn)/(pf-pn);
%T2 = 2*pf*pn/(pf-pn);
%M = mglFrustm(pl,pr,pb,pt,pn,pf);
Ma = sym(zeros(4));
Ma(1,1) = sym('m11');
Ma(2,2) = sym('m22');
Ma(1,3) = sym('m13');
Ma(2,3) = sym('m23');
Ma(4,3) = -1;
Ma(3,3) = T1; % -(f+n)/(f-n)
Ma(3,4) = T2; %-2*f*n/(f-n)


Me = sym(zeros(4));
Me(1,1) = 2*pn*fx;
Me(2,2) = 2*pn*fy;
Me(1,3) = cx;
Me(2,3) = cy;
Me(4,3) = -1;
Me(3,3) = T1; % -(f+n)/(f-n)
Me(3,4) = T2; %-2*f*n/(f-n)
iMe = inv(Me);

pe = iMe*C'
pa = inv(Ma)*C'

%pa(1)= (E1*T2*(Df - Dn)*(2*wx - Vw + Vw*m13))/(Vw*m11*(2*E1*wz - 2*Df*E1 - Df*T1 + Dn*T1))
%
%should be equal to
%
%  (wx-cx)*Z/fx
%
%but we know that:
%  
% 
%  Z=(T2*(Df - Dn))/(2*E1*wz - 2*Df*E1 - Df*T1 + Dn*T1)

%  pa(1) = E1*Z*(wx - Vw/2 + Vw*m13/2))/(2*Vw*m11)
%  pa(1) = Z*(wz - (Vw/2-Vw*m13/2))/(2*Vw*m11/E1)
%
%  cx = Vw/2 - Vw*m13/2  ===>  m13 = (Vw/2-cx)*2/Vw SAME
%  fx = (2*Vw*m11/E1)   ===>   m11 = E1*fx/(2*Vw)   ==> was: 2 * fx / Vw
%
% Spec for T1: 1 - 2 * far / (far - near)
% Spec for T2: -2 * far * near / (far - near)

%%
% this is the same as above, just by geometrical considerations
%
% nz = as bove
% ez = T2/(E1*nz-T1)
syms T1 T2 E1 real
syms az real;
syms Df Dn real;
wz = (az)/4294967295.0;
syms wz real;
nz = (2*wz-Df-Dn)/(Df-Dn);
ez = T2/(E1*nz-T1);
collect(simplify(ez),az)

%ez = T2*(Df-Dn)/(-T1*(Df-Dn) - E1*(Df+Dn) + 2 E1*wz)

%code
znum = T2*(Df-Dn);
zscale = 2*E1; % /4294967295.0;
zbias = - 2*Df*E1 - (Df-Dn)*T1; 

ezz = znum/(zscale*wz+zbias);
simplify(ezz-ez) % == 0

%%
syms xf xn real;
Q = mglFrustum(1,0,1,0,xn,xf)

%%
Q = mglFrustum(1,0,1,0,0.001,1.0)
T1=Q(3,3);
T2=Q(3,4);
E1=Q(4,3);
wz=0;
Df=1;
Dn=0;
% T1=-(xf + xn)/(xf - xn)
% T2=-(2*xf*xn)/(xf - xn)
% E1=-1
znum = T2*(Df-Dn); % -(2*xf*xn)/(xf - xn)
zscale = 2*E1; % /4294967295.0; % -2
zbias = - (Df+Dn)*E1 - (Df-Dn)*T1; 

ezz = znum/(zscale*wz+zbias) ;  
ezz

%nz=(2*wz-Df-Dn)/(Df-Dn);
%pz=T2/(E1*nz-T1)


%%
% and OpenCV part
syms fx fy cx cy real;
syms X Y Z real;
syms x y real;
K = [fx 0 cx; 0 fy cy; 0 0 1];
uv = K*[X,Y,Z]';
xy = uv/uv(3);
s = solve([x,y]' == xy(1:2),[X,Y])
s.X
s.Y

%%
mglLook