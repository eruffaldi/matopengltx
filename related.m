http://www.learnopengles.com/understanding-opengls-matrices/


vertexndc = PerspectiveDivide(ProjectionMatrix * ViewMatrix * ModelMatrix * vertexmodel)


model
world
eye
clip
ndc
viewport



------------

clipcoordinates: (xc,yc,zc,wc) with clip abs(#c) <= wc
ndc: (xd,yd,zd) = (xc,yc,zc)/wc
window: (xw,yw,zw) = (xd W/2 + ox, yd H/2 + oy, (f-n)/2 zd + (n+f)/2)

window coordinates are with y up

--------------