% Example of Extraction
syms r l f n b t real;
s = [];
s.r = r;
s.l = l;
s.t = t;
s.b = b;
s.n = n;
s.f = f;
P = mglFrustum(s);
q = mglInvFrustum(P);

ff = fieldnames(s);
for I=1:length(ff)
    simplify(q.(ff{I})-s.(ff{I}))
end