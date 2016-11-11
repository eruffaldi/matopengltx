function P = mcvIntrinsics2Prj(K,near,far,w,h)

fx = K(1,1);
fy = K(2,2);
cx = K(1,3);
cy = K(2,3);

   T1 = -(near+far)/(far-near);
   T2 = -2 * far * near / (far - near); 
   m11 = -2*fx /w;
   m22 = -2*fy /h;
   m13 = 1 - 2 * cx / w;  
   m23 = - 2 * (h-cy) / h;
P =[-m11,0,m13,0;
0,-m22,-m23,0;
0,0,T1,T2;
0,0,-1,0];
  
