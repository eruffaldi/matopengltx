function po = mprojz(p)

po = p;
for I=1:size(p,2)
    po(:,I) = po(:,I)/p(3,I);
end
