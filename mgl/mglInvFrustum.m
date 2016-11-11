
% syms n f C D real;
% s = solve([C == -(f+n)/(f-n), D == - 2*f*n/(f-n)],[f,n])
% syms A m00 R L real
% s = solve([2/(r-l)==m00, (r+l)/(r-l)==A],[r,l])
% syms B m11 t b real
% s = solve([2/(t-b)==m11, (t+b)/(t-b)==B],[t,b])
function s = mglInvFrustum(P)
    assert(double(P(4,3)) == -1);
     C = P(3,3);
     D = P(3,4);
     A = P(1,3);
     B = P(2,3);
     f = D/(C + 1);
     n = D/(C - 1);
     m00 = P(1,1)/n;
     m11 = P(2,2)/n;
    r = (A + 1)/m00;
    l = (A - 1)/m00;
    t = (B + 1)/m11;
    b = (B - 1)/m11;
    s = [];
    s.n =n;
    s.f=f;
    s.r=r;
    s.l=l;
    s.t=t;
    s.b=b;
    