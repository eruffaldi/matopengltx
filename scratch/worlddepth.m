syms X Y Z W f n zw dz real
P = [1 0 0 0; 0 1 0 0; 0 0 -(f+n)/(f-n)  -2*f*n/(f-n); 0 0 -1 0];
qw = [X Y Z W]';
qh = P*qw;
qndc = qh./qh(4);

solve((qndc(3)+1)*0.5 == zw,'Z')

%Z of ROS renderer
%2 * zFar * zNear / (zFar + zNear - (zFar - zNear) * (2 * (*it) - 1))
%2 fn / (f + n - (f-n)*(2 zw-1))
%alt1: 2 fn/(f+n-(f-n)zndc)
%alt2: 2 fn / (f + n + (f-n) - 2 (f-n) zw)
%      2 fn / (2f - 2 (f-n) zw)
%      fn / (f - (f-n)zw)

%output: -(W*f*n)/(f - f*zw + n*zw) = - Wfn/ (f - (f-n)zw)
%        a parte W ? come sopra a meno del segno superiore per questioni di
%        convenzione. Nel senso che la eye guarda con Z negative per cui la
%         

solve((qndc(3)+1)*0.5 == -dz,'Z')
