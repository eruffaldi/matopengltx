function d = mglWindowDepth2Depth(wd,P,range_n,range_f)

T1=P(3,3);
T2=P(3,4);
E1=P(4,3);

nz = (2*wd-range_f-range_n)/(range_f-range_n);
d = -T2/(E1*nz-T1);