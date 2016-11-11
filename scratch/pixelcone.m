
Qc = @(P0,r) [1 0 -P0(1)/P0(3); 0 1 -P0(2)/P0(3); -P0(1)/P0(3), -P0(2)/P0(3), (P0(1).^2+P0(2).^2-r^2)/P0(3).^2];


P0 = [0.5,0.5,1.0];
r = 0.2;
Q = Qc(P0,r);
[X,Y,Z] = meshgrid(-10:0.1:10,-10:0.1:10,0:0.1:10);

W = arrayfun(@(I) [X(I),Y(I),Z(I)]*Q*[X(I),Y(I),Z(I)]',1:numel(X));
W = reshape(W,size(X));
fv = isosurface(X,Y,Z,W,0.0);
p = patch(fv);
%%
isonormals(X,Y,Z,W,p)
set(p,'FaceColor','red','EdgeColor','none')
daspect([1,1,1])
view(3)
axis tight
camlight
lighting gouraud