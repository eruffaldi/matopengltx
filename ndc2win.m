% given the glViewport parameters computes the transformation from ndc to
% window coordinates
%
% ndc is centered with +-1 all around
% window is centered in lower left going up and right
function T = ndc2win(x,y,w,h)

T = [w/2 0 0 x/2+w/2; 0 h/2 0 y/2+h/2; 0 0 1 0; 0 0 0 1];
