function W= mglClip2Window(V,range_n,range_f)

% maps: X Y
%   -1 => V(1)   1 => V(2)
% maps: Z
%   -1 => range_n 1 => range_f
%
ox = V(1)+V(3)/2;
oy = V(2)+V(4)/2;
aa = (range_f-range_n)/2; % default 0.5 
bb = (range_n+range_f)/2; % default 0.5
W = [V(3)/2,0,0, ox; 0, V(4)/2, 0, oy; 0,0,aa,bb; 0,0,0,1];