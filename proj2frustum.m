% Given a projection matrix build the 8 points of the frustum
%
function [Q,NP,FP,SP,OC] = proj2frustum(PV)

% the clip space
X = [-1 -1 -1 -1 1 1 1 1];
Y = [-1 -1  1  1  -1 -1 1 1 ];
Z = [-1 1  -1 1 -1 1 -1 1];
NP = [1,3,7,5,1];
FP = [2,4,8,6,2];
SP = [1,2,4,3,7,8,5,6];

Q = zeros(8,4);

for I=1:8
    w = [X(I) Y(I) Z(I) 1]'; % point
    Q(I,:) = PV\w;
end
Q = Q(:,1:3)./repmat(Q(:,4),1,3);
    
X = [0 0; 0 0; -1 1];
OC = zeros(2,4);
for I=1:2
    w = [X(:,I); 1];
    OC(I,:) = PV\w;
end
OC = OC(:,1:3)./repmat(OC(:,4),1,3);

