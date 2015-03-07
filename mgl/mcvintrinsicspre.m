function Aprime = mcvintrinsicspre(fx,fy,cx,cy)

% A projz(x) = projw(Aprime x) 
%
% given w = 1
Aprime = [-fx 0 0 -cx; 0 -fy 0 -cy; 0 0 1 0; 0 0 -1 0];
