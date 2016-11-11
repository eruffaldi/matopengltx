%https://www.opengl.org/wiki/Compute_eye_space_from_window_space
function ipgl = mglUnproject(pws,P,V,range_n,range_f)

T1=P(3,3);
T2=P(3,4);
E1=P(4,3);
%	ndcPos.xy = ((2.0 * windowSpace.xy) - (2.0 * viewport.xy)) / (viewport.zw) - 1;
%	ndcPos.z = (2.0 * windowSpace.z - depthrange.x - depthrange.y) /    (depthrange.y - depthrange.x);

W = mglClip2Window(V,range_n,range_f);

iW = inv(W);

ndc = iW*pws;
Cw = T2/(ndc(3)-T1/E1);
c = [ndc(1:3)*Cw;Cw];

ipgl = inv(P)*c;
ipgl(3) = -ipgl(3);