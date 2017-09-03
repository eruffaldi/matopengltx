function M = mglFrustum(l,r,b,t,n,f)

if nargin == 1
    if isstruct(l)
        s = l;
        l = s.l;
        r = s.r;
        t = s.t;
        n = s.n;
        f = s.f;
        b = s.b;
    else
        a = l;
        l = a(1);
        r = a(2);
        b = a(3);
        t = a(4);
        n = a(5);
        f = a(6);
    end
end

A = (r+l)/(r-l);
B = (t+b)/(t-b);
C = -(f+n)/(f-n); % if n==0 this gives -1, if f=Inf this gives NaN
D = -2*f*n/(f-n); % if n==0 this gives f, if f=Inf this gives NaN
M = [2*n/(r-l) 0 A 0; 0 2*n/(t-b) B 0; 0 0 C D; 0 0 -1 0];
