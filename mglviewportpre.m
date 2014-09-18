function W = mglviewportpre(x,y,w,h)

ox = x+w/2;
oy = y+h/2;
px = w;
py = h;

W = [px 0 0 ox; 0 py 0 oy; 0 0 (f-n)/2 (f+n); 0 0 0 1];
