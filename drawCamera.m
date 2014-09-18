function drawCamera(M,P,cc,mode)

if nargin < 3
    cc = 'b';
end

if nargin < 4
    mode = '';
end

PM = P*M;
[Q,NP,FP,SP,OC]= proj2frustum(PM);



p = -M(1:3,4); % camera origin
zdir = -M(1:3,3); % this is the Z axis in the eye space

if strcmp(mode,'2d')
    scatter(p(1),p(3),cc,'filled');
    hold on
    scatter(Q(:,1),Q(:,3),'r');

nan3 = [NaN,NaN,NaN]';
Q = Q';

PL = [p,Q(:,1),nan3,p,Q(:,2),nan3,p,Q(:,3),nan3,p,Q(:,4),nan3,p,Q(:,5),nan3,p,Q(:,6),nan3,p,Q(:,7),nan3,p,Q(:,8)];    

    line(PL(1,:),PL(3,:),'Color',cc);
    %refsys(M);
    line(Q(1,NP),Q(3,NP),'Color','g');
    line(Q(1,FP),Q(3,FP),'Color','m');
    line(Q(1,SP),Q(3,SP),'Color',cc);
    line([p(1); p(1)+zdir(1)],[p(3) ;p(3)+zdir(3)],'Color','k','LineStyle',':');

    hold off
else
    
    scatter3(p(1),p(2),p(3),cc,'filled');
    hold on
    scatter3(Q(:,1),Q(:,2),Q(:,3),'r');

nan3 = [NaN,NaN,NaN]';
Q = Q';
PL = [p,Q(:,1),nan3,p,Q(:,2),nan3,p,Q(:,3),nan3,p,Q(:,4),nan3,p,Q(:,5),nan3,p,Q(:,6),nan3,p,Q(:,7),nan3,p,Q(:,8)];    

    line(PL(1,:),PL(2,:),PL(3,:),'Color',cc);
    %refsys(M);
    line(Q(1,NP),Q(2,NP),Q(3,NP),'Color','g');
    line(Q(1,FP),Q(2,FP),Q(3,FP),'Color','m');
    line(Q(1,SP),Q(2,SP),Q(3,SP),'Color',cc);
    line([p(1); p(1)+zdir(1)],[p(2);p(1)+zdir(2)],[p(3);p(3)+zdir(3)],'Color','k','LineStyle',':');

    hold off
end
