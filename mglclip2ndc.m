function po = mglclip2ndc(p)

po = p;
for I=1:size(p,2)
    po(:,I) = po(:,I)/p(4,I);
end
