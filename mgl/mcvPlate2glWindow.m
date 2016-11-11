function W = mcvPlate2glWindow(h,n,f,Dn,Df)

T1=-(n+f)/(f-n);
T2=-2*n*f/(f-n);
E1=-1;

znum = T2*(Df-Dn);
zscale = 2*E1;
zbias = - (Df+Dn)*E1 - (Df-Dn)*T1; 

% Zcv = -(znum/(zscale*wz+zbias);
% (zscale*wz+zbias) = - znum/Zcv
% wz = -znum/zscale/Zcv-zbias/zscale
%
aa = -znum/zscale;
bb = -zbias/zscale;
W = [1,0,0,0; 0,-1,0,h; 0,0,aa,bb; 0,0,0,1];