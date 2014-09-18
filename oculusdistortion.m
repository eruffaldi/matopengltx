
HmdWarpParam = [1.0, 0.22, 0.24, 0.0]; %// For the 7-inch device
ChromAbParam = [0.996, -0.004, 1.014, 0.0];
HMD_HResolution = 1280.0;
HMD_VResolution = 800.0;
HMD_HScreenSize = 0.14976;
HMD_VScreenSize = HMD_HScreenSize / (HMD_HResolution / HMD_VResolution);
HMD_InterpupillaryDistance = 0.064;
HMD_LensSeparationDistance = 0.0635;
HMD_EyeToScreenDistance = 0.041;
lensOffset = HMD_LensSeparationDistance * 0.5;
lensShift = HMD_HScreenSize * 0.25 - lensOffset;
 Distortion_XCenterOffset = 4.0 * lensShift / HMD_HScreenSize;
DistortionFitX = -1.0;
DistortionFitY = 0.0;
 stereoAspect = 0.5 * HMD_HResolution / HMD_VResolution;
dx = DistortionFitX - Distortion_XCenterOffset;
dy = DistortionFitY / stereoAspect;
fitRadiusSquared = dx * dx + dy * dy;
Distortion_Scale =  HmdWarpParam(1) + HmdWarpParam(2) * fitRadiusSquared +  HmdWarpParam(3) * fitRadiusSquared * fitRadiusSquared +  HmdWarpParam(4) * fitRadiusSquared * fitRadiusSquared * fitRadiusSquared;

isRight = 0;

if isRight
    XCenterOffset = -Distortion_XCenterOffset;
    x = 0.5;
else
    XCenterOffset = Distortion_XCenterOffset;
    x =0;
end

y = 0.0;
w = 0.5;
h = 1.0;

LensCenter = [x + (w + XCenterOffset * 0.5) * 0.5, y + h * 0.5];
ScreenCenter = [x + w * 0.5, y + h * 0.5];
scaleFactor = 1.0 / Distortion_Scale;
Scale = [w * 0.5 * scaleFactor, h * 0.5 * scaleFactor * stereoAspect];
ScaleIn = [2.0 / w, 2.0 / h / stereoAspect];

[oTexCoordX,oTexCoordY] = meshgrid(0:0.01:0.5,0:0.01:1); % left
oTexCoordRedX = zeros(size(oTexCoordX));
oTexCoordRedY = oTexCoordRedX;
for I=1:size(oTexCoordX,1)
    for J=1:size(oTexCoordY,2)
        oTexCoord = [oTexCoordX(I,J),oTexCoordY(I,J)];
    theta = (oTexCoord - LensCenter) .* ScaleIn; %// Scales to [-1, 1]
    rSq = theta(1) * theta(1) + theta(2) * theta(2);
    theta1 = theta * (HmdWarpParam(1) +HmdWarpParam(2) * rSq +HmdWarpParam(3) * rSq * rSq + HmdWarpParam(4) * rSq * rSq * rSq);

    %// Compute chromatic aberration
    thetaRed = theta1 * (ChromAbParam(1) + ChromAbParam(2) * rSq);
    thetaBlue = theta1 * (ChromAbParam(3) + ChromAbParam(4) * rSq);
    tcRed = LensCenter + Scale .* thetaRed;
    tcGreen = LensCenter + Scale .* theta1;
    tcBlue = LensCenter + Scale .* thetaBlue;
    
    oTexCoordRedX(I,J) = tcRed(1);
    oTexCoordRedY(I,J) = tcRed(2);
    end
end

%surf(oTexCoordRedX,oTexCoordRedY)
% red takes x of tcRed

surf(oTexCoordX,oTexCoordY,oTexCoordRedX);

%vec4 sample(vec2 point, vec2 ScreenCenter) {
%  if (clamp(point, ScreenCenter - vec2(0.25, 0.5), ScreenCenter + vec2(0.25, 0.5)) != point) return vec4(0.0);
%  vec2 checkerboard = fract(point * vec2(4.0, 2.0)) - 0.5;
%  return vec4(checkerboard.x * checkerboard.y < 0.0 ? 0.25 : 1.0);
%}
