function W = mglbuildwpre(px,py,ox,oy,f,n)
% 
% [ 2/px,    0,          0,      -(2*ox)/px]
% [    0, 2/py,          0,              -2]
% [    0,    0, -2/(f - n), (f + n)/(f - n)]
% [    0,    0,          0,               1]
% 
%  iW*[x/w y/w z/w 1]'
%  
%             (2*x)/(px*w) - (2*ox)/px
%                     (2*y)/(py*w) - 2
%  (f + n)/(f - n) - (2*z)/(w*(f - n))
%                                    1
%   

