
sizes=[640 480];
K = [532.5 0 319.5; 0 532.5 239.5; 0 0 1];
P = mcvIntrinsics2Prj(K,0.001,3,sizes(1),sizes(2))
s = mglInvFrustum(P)

%%
sizes=[1360,768];
K = [2283.16 0 700; 0 2302 765;  0 0 1];
P = mcvIntrinsics2Prj(K,0.1,2.0,sizes(1),sizes(2))
s = mglInvFrustum(P)

% view transform is simply: projector_object 
W = [-0.758189  0.651552 0.0250953  0.136354
 0.321366  0.406897 -0.855078 -0.245096
-0.567339 -0.640246 -0.517891   1.00597
        0         0         0         1];
W2E*W
%%
syms fx fy cx cy real;
syms w h near far real;
sizes = [w,h];
K = [fx,0,cx;0,fy,cy; 0 0 1];
P = mcvIntrinsics2Prj(K,near,far,sizes(1),sizes(2));
W2E=[1 0 0 0; 0 1 0 0; 0 0 -1 0 ; 0 0 0 1];
W = eye(4);

syms X Y Z real;
pM = [X Y Z 1]'; % world point
Df=1;
Dn=0;

%P(1,1) = 2*fx/w*near;

pc = P*W2E*W*pM; % world point to projected in clip space
%pc = [X Y Z -Z]';
pndc = pc/pc(4); % division 
pW = mglClip2Window([0 0 sizes(1) sizes(2)],Dn,Df)*pndc;

T1 = P(3,3);
T2 = P(3,4);
E1 = P(4,3);

% then convert back the Z
znum = T2*(Df-Dn);
zbias = (Df+Dn)*E1 + (Df-Dn)*T1; 
zscale = -2*E1;

zreal = znum/(zscale*pW(3)+zbias); % == Z
simplify(zreal)
poff = 0; % 0.5
pWflip= [pW(1),h-pW(2)+1];
outp = simplify((pWflip(1:2)-[K(1,3),K(2,3)])*zreal./[K(1,1),K(2,2)]);


%simplify(outp == outpo)
simplify(outp(1))
simplify(outp(2))
% at most the y should be flipped