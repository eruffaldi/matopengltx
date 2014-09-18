function [PL,PR,Zcull] = buildstereoLR(screenWidth,ratio,eyeScreenDistance,ipd,nearfar,mode)

screenHeight = screenWidth/ratio;
FOVydeg = 180/pi*2*atan2(screenHeight,2*eyeScreenDistance);
convergence = eyeScreenDistance;
separation = ipd/screenWidth;
Zcull = (convergence/(1+1/separation));

if strcmp(mode,'tx')
        % used in oculusrift effect but not working    	
        P1 = mgluPerspective(FOVydeg,ratio,nearfar(1),nearfar(2));
        h2 = [1-2*ipd/screenWidth,0,0];
        Tleft =  mgltranslate(-h2);
        Tright =  mgltranslate(h2);
        PL =Tleft*P1;
        PR =Tright*P1;
        
        % matrix is right multipled by left.transform
elseif strcmp(mode,'clip')

        % used in oculusrift effect but not working    	
        P1 = mgluPerspective(FOVydeg,ratio,nearfar(1),nearfar(2));
        PL = P1;
        alpha = - ipd/screenWidth;
        beta = alpha*convergence;
PR = P1;

        PL(1,3) = PL(1,3) - alpha;
        PL(1,4) = PL(1,4) - beta;

        PR(1,3) = PR(1,3) + alpha;
        PR(1,4) = PR(1,4) + beta;

else

% correct on near/screen plane, not correct on far
N = nearfar(1);
F = nearfar(2);
W = screenWidth;
H = W/ratio;
C = eyeScreenDistance;
IPD = ipd;

%A = ratio * tan(FOVydeg*pi/180/2) * C;
% A = W/2 is solved OK
% my was: b = (W/2-IPD/2)*N/C
% in my case:  A=W/2 

A = W/2;
b = A - IPD/2;
c = A + IPD/2;

T    =   H/2*N/C;
%T2 = N * tan(FOVydeg*pi/180/2)

B    = - T;
LL   =  N/C*(-b);
RL  =   N/C*(c);

LR = N/C*(-c);
RR = N/C*(b);

PL = mglFrustum(LL,RL,B,T,N,F);
PR = mglFrustum(LR,RR,B,T,N,F);
end

%TODO alternative: use frustum directly