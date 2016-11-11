% generalized projection plane with (pa,pb,pc) as lower left, lower right,
% and upper left(LL,LR,UL)
%
% all in the same reference system
function P = mgenproj(pa,pb,pc,pe,nearplane,farplane)

vu = normalize(pb-pa);
vr = normalize(pc-pa);
vn = normalize(cross(vr,vu));

va = pa-pe;
vb = pb-pe;
vc = pc-pe;

d = - dot(va,vn);
l = dot(vr,va) * nearplane/d;
r = dot(vr,vb) * nearplane/d;
b = dot(vu,va) * nearplane/d;
t = dot(vu,vc) * nearplane/d;

P = mglFrustum(l,r,b,t,nearplane,farplane);

M = eye(4);
if isa(vn,'sym')
    M  = sym(M);
end
M(1:3,1) = vr;
M(1:3,2) = vu;
M(1:3,3) = vn;

P = M'*mgltranslate(-pe);

function n = normalize(n)

n = n./norm(n);