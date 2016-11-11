%https://www.opengl.org/wiki/Depth_Buffer_Precision

% near/far => biths w
bits = 24;
s = 2^bits-1;
depthrange = [0,1];
near = 0.01;
far = 3;

syms ze we zc zndc zw s real;

aa = (depthrange(2)-depthrange(1))/2; % default 0.5 
bb = (depthrange(1)+depthrange(2))/2; % default 0.5

%eqa = [zc == -(far+near)/(far-near)*ze -2*far*near/(far-near)*we,wc == -ze,zndc == zc/wc,zw == zndc*aa+bb];
%ss = solve(eqa,[ze,we])
%ze_over_we = ss.ze/ss.we;
ze_over_we = (far*near)/(far-near)/((zw/s)-0.5*(far+near)/(far-near)+0.5);

d_ze_over_we_zw = diff(ze_over_we,zw);

% at far
simplify(-subs(d_ze_over_we_zw,zw,s))
%subs(ze_over_we,zw,0)