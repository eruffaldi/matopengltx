syms fx fy cx cy n f real;

K = [fx 0 cx; 0 fy cy; 0 0 1];
P = mcvIntrinsics2Prj(K,n,f);
