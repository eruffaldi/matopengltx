function W = mglbuildw(px,py,ox,oy,f,n)

W = [px/2 0 0 ox; 0 py/2 0 oy; 0 0 (f-n)/2 (f+n)/2; 0 0 0 1];