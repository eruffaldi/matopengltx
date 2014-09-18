%
% [R|t] => [R'|-R't]
%
function M = mviewMatrix(R, t)

if nargin < 2
    t = R(:,4);
end

Rt = R(1:3,1:3)';
M = [ Rt, -Rt*t(1:3); 0 0 0 1];
