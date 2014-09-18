
%%
syms screenWidth eyeScreenDistance ipd ratio real

spi = sym('pi');

screenHeight = screenWidth/ratio;
convergence = eyeScreenDistance;
separation = ipd/screenWidth;

FOVydeg = 180/spi*2*atan(screenHeight,2*eyeScreenDistance);

Zcull = simplify(convergence/(1+1/separation));

P1 = mgluPerspective(FOVydeg,ratio,0.3,1000);

%h1 = 4*(screenWidth/4-ipd/2)/screenWidth;
h2 = [1-2*ipd/screenWidth,0,0];
Tleft =  mgltranslate(h2);
PL =Tleft*P1;

Tright =  mgltranslate(-h2);
PR =Tright*P1;

%TODO alternative: use frustum directly

%%
r = oculusparams();
r

scatter(-r.interpupillaryDistance/2,0,'r.');
hold on
scatter(r.interpupillaryDistance/2,0,'b.');

% W:C=x:N
% x = W*N/C
np = 0.3;
npw = r.hScreenSize*np/r.eyeToScreenDistance;
fp = 1.0;
fpw = r.hScreenSize*fp/r.eyeToScreenDistance;
line([-r.hScreenSize/2,r.hScreenSize/2],[-r.eyeToScreenDistance,-r.eyeToScreenDistance],'Color','k');
line([-npw/2,npw/2],[-np,-np],'Color','m');
line([-fpw/2,fpw/2],[-fp,-fp],'Color','m');
hold off
ylim([-1.1,0.1]);


%%
% TODO: plot this in the diagram to show "correctness"
r = oculusparams();
r
mode = 'geo';
mode='tx';
mode='clip';
%r.interpupillaryDistance = 0;

[PL,PR,Zcull] = buildstereoLR(r.hScreenSize,r.hScreenSize/r.vScreenSize,r.eyeToScreenDistance,r.interpupillaryDistance,[0.3, 1.0],mode);

VL = mgltranslate([r.interpupillaryDistance/2,0,0]);
VR = mgltranslate([-r.interpupillaryDistance/2,0,0]);

drawCamera(VL,PL,'r','2d');
hold on
drawCamera(VR,PR,'b','2d');
xlabel('X (m)');
ylabel('Z (m)');
%zlabel('Z');
ylim([-1.1,0.1]);
line([-r.hScreenSize/2,r.hScreenSize/2],-[r.eyeToScreenDistance,r.eyeToScreenDistance],'Color','k');
%set(gca,'CameraPosition',[ 0.8324  -86.1406   -0.5135]);
%set(gca,'CameraTarget',[0.2310    0.0025   -0.5135]);
%set(gca,'CameraViewAngle',2.9888);
%view([0 0]);
grid off
hold off
sethighfonts
export_fig(['stereocalc' mode],'-pdf','-transparent');