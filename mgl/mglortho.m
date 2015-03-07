function r = mglortho(l,r,b,t,n,f)

tx = -(r+l)/(r-l);
ty = -(t+b)/(t-b);
tz = -(f+n)/(f-n);
r = [2/(r-l) 0 0 tx; 0 2/(t-b) 0 ty; 0 0 -2/(f-n) tz; 0 0 0 1];

