function uv = mglProject(p3,P,V,range_n,range_f)

% assume we apply inversion
p3(3) = -p3(3);
p4 = [p3(1:3),1]';
c = P*p4;
ndc = c/c(4);

% map ndc to window space comprising depth range
W = mglClip2Window(V,range_n,range_f);

ws = W*ndc;
uv = [ws(1:3);1];