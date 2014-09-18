function p = mglapply(m,pp)


if size(pp,2) == 3
    pp = [pp, ones(size(pp,1),1)];
end

p = (zeros(size(pp,1),3));
if isa(pp,'sym') | isa(m,'sym')
    p = sym(p);
end

for I=1:size(pp,1)
    q = m*pp(I,:)';
    p(I,:) = q(1:3)/q(4);
end
