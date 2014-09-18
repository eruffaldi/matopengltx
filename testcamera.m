


P = mgluPerspective(60,640.0/480.0,1,10);
M = mviewLookAt([0 0 0],[1.0 0.0 0],[0 0.1 0]);

figure(1);
drawCamera(M,P);

figure(2);
drawCamera(M,P,'r','2d');

% Add cutting
% Add Ortho?
% Add explicit planes