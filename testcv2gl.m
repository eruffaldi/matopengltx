

%%
syms n f px py ox oy real; 
syms x y z w real;
syms fx fy cx cy real;
syms a b real;

v = [x y z w]';
vdivw = v ./ w;
vdivz = v ./ z;

A = mcvintrinsics(fx,fy,cx,cy);
W = mglbuildw(px,py,ox,oy,n,f);
iW = inv(W);


% %% W projw(v) = projw(sW v)
% % not needed but for exercise
% Wapplied = W*vdivw
% sW = mglbuildwpre(px,py,ox,oy,n,f)
% Wappliedauto = sW*v
% Wappliedautodiv = simplify(Wappliedauto./Wappliedauto(4))
% 
% simplify(Wappliedautodiv - Wapplied) % should give 0


%% A proz(v) = projz(sA v) = projw(ssA v)
% in 2D
Aapplied = subs(simplify(A*vdivz),w,1)

sA = mcvintrinsicspre(fx,fy,cx,cy);
sA(3,3) = a;
sA(3,4) = b;
sAappliedauto2 = sA*v;
sAappliedautodivw = subs(simplify(sAappliedauto2./sAappliedauto2(4)),w,1)

Aapplied(1:2)-sAappliedautodivw(1:2) % should give zero



% A projz(v) = projw(sA v) = W projw(iW sA v)
% in 2D
test = simplify(W*mprojw(iW*sA*v))
target = simplify(mprojw(sA*v))

Ptest = iW*sA;
P = iW*sA*meyecv2gl();
syms vw vh real;
Ps = subs(P,{'ox','oy','px','py','n','f'},{0,0,vw,vh,0,1})


disp('Compare just x and y')
final = simplify(W*mprojw(Ptest*v))
original = simplify(A*mprojz(v))
P
