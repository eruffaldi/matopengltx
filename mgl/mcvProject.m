function wcv = mcvProject(p3,K)

p = K*p3(:);
wcv = [p(1:2)/p(3);1/p(3);1];