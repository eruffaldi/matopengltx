function M = mgluPerspective(fovyDeg,ratio_xovery,n,f)

ymax = n * tan(fovyDeg*pi/180/2);
xmax = ymax*ratio_xovery;

M = mglFrustum(-xmax, xmax, -ymax, ymax, n, f);