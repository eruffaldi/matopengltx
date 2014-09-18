function p = mcvdivide(p)

p = p ./ repmat(p(:,3),1,size(p,2));

