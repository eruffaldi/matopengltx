function [K,near,far] = mvPrj2Intrinsics(P,width,height)

     C = P(3,3);
     D = P(3,4);
     far = D/(C + 1);
     near = D/(C - 1);
    fx = -P(1,1)*width/2;
    fy = -P(2,2)*height/2;
    cx = (width - P(1,3)*width)/2;
    cy = (height - P(2,3)*height)/2;
    K = [fx 0 cx; 0 fy cy;0 0 1];
  
