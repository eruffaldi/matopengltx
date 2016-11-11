% Stereo Projection with the eye directly facing the projection screen
%
% Example
% P = mstereoproj(-1,0.80,0.03,60*pi/180,0.001,1000,0.25,0.20);
%
% focusDistance = distance eye to plane
% eye_separation = distance eye to plane center
function P = mstereoproj(eye,focusDistance,eye_separation,hfov,nearplane,farplane,W,H)

aspectRatio = W/H;
screenHalfWidth = focusDistance * tan(hfov / 2.0);
shift = screenHalfWidth * (eye_separation/2) / W;

% should be * current y  / y total
% to take into account that the window doesn't cover the entire screen

halfWidth = nearplane * tan(hfov / 2.0);
delta  = shift * nearplane / focusDistance;
side = eye;

left   = -halfWidth + side * delta;
right  =  halfWidth + side * delta;
top    = halfWidth / aspectRatio;
bottom = -top;

P = mglFrustum(left,right,top,bottom,nearplane,farplane);
