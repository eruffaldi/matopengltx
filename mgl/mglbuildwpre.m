function W = mglbuildwpre(px,py,ox,oy,f,n)
% W = 
% [ px/2,    0,         0,        ox]
% [    0, py/2,         0,        py]
% [    0,    0, n/2 - f/2, f/2 + n/2]
% [    0,    0,         0,         1]
W = [px/2 0 0 ox; 0 py/2 0 py; 0 0 (n/2-f/2) (f+n)/2; 0 0 0 1];