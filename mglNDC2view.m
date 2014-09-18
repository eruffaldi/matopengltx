function r = mglNDC2view(x,y,W,H)

%13.6.1 Controlling the Viewport

n = 0;
f = 1;

r = [W/2 0 0 x+W/2; 0 H/2 0 y+H/2; 0 0 (f-n)/2 (n+f)/2; 0 0 0 1];
