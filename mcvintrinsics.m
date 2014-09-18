function A = mcvintrinsics(fx,fy,cx,cy)

A = [fx 0 0 cx; 0 fy 0 cy; 0 0 1 0; 0 0 0 1];
