
% NDC is (-1 -1 -1) = (l,b,n) and (1 1 1) = (r,t,f) left handed!

verticesYup = [-1 1 0; 1 1 0; 1 -1 0; -1 -1 0];

syms W H real
a = mglortho(0,W,0,H,0,1.0);

b1 = mgltranslate([0,H,0]);
b2 = [1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 1]';

syms sW sH sx sy real;

m = mglNDC2view(0,0,W,H); % viewport = x y W H => matrix for converting NDC to viewport1

c = a*b1*b2;

verticesfull = [0 0 0; W 0 0; W H 0; 0 H 0];
verticesnorm = [0 0 0; 1 0 0; 1 1 0; 0 1 0];

x = mglapply(c,verticesfull)

s = simplify(m*c*mglScale(sW,sH,1.0)*mgltranslate([sx,sy,0]))


y = mglapply(s,verticesnorm)

% "see" it using mglNDC2view

% finally use the verticesYup transformation

%%
s2 =mgltranslate([-0.5,-0.5,0])* [1 0 0 0; 0 -1 0 0; 0 0 -1 0; 0 0 0 1]'*mglScale(0.5,0.5,1.0);

z = mglapply(s2,verticesYup)