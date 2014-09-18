function M = mglviewport(x,y,w,h,n,f)

ox = x+w/2;
oy = y+h/2;
px = w;
py = h;

M = [px/2 0 0 ox; 0 py/2 0 oy; 0 0 (f-n)/2 (n+f)/2; 0 0 0 1];
