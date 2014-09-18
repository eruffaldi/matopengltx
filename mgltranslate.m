function M = mgltranslate(p)

M = eye(4);
if isa(p,'sym')
    M  = sym(M);
end

M(1:3,4) = p(:);