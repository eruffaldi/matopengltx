function [h,p] = drawfrustum(F)
iF = inv(F);
pe = [0 0 0;0 1 0;1 1 0;1 0 0;0 0 1;0 1 1;1 1 1;1 0 1]*2-1.0;
p = zeros(length(pe),3);
for I=1:length(pe)
    z= iF*[pe(I,:)';1];
    p(I,:) = z(1:3)./z(4);
end
face = [1 2 3 4;5 6 7 8;3 4 8 7;1 2 6 5;2 3 7 6; 4 1 5 8];
h = patch('Faces',face,'Vertices',p);
