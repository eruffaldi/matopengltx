function P = gluperspective(aspect,fovy,near,far)

f = cot(fovy/2);

P = [f/aspect 0 0 0 ; 0 f 0 f; 0 0 (near+far)/(near-far) 2*near*far/(near-far); 0  0 -1 0];
