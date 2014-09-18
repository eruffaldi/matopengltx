syms vW vH real
syms x y z w real
syms aspect fovy near far real
W = mglviewport(0,0,vW,vH,0,1);
P = mgluperspective(aspect,fovy,near,far);

p_w = W*mprojw(P*[x y z w]')