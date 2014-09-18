%
% See also refsys.ppt
%
% Motore Reference Systems
%
% @R: Paper Reference System (each Sheet): [rawx,rawy,relsheet], paper unit.  Relsheet: 1=topleft,2=lowerleft,3=topright,4=bottomleft
% @V: Virtual, mm
% @T: Table, mm
% @A: Application [Simulink], m
% @C: Communication [Simulink-Host], mm/10, position of pen
% @G: Graphics [Host], mm
% @M: Local Motore, m
% @H: Handle Position,m
% @P: Pen Position,m
%
% We should take one as the world reference. E.g. @T
%
% Transformations between systems
% 
% @R -> @V    [-y-offsetx[sheet],-x-offsety[sheet]]*0.3/8
% @V -> @T    [x+papercenterx,y+papercentery]
% @V -> @A    [x+appcenterinvsheet,y+appcenterinvsheet]*0.001
% @A -> @C    xy*10000
% @A -> @G    [x,-y]*1000
% @A -> @M    R(motorepsi_A+pi/2)([x,y]-motorexy_A)
% @M -> @A    R(-motorepsi_A-pi/2)[x,y]+motorexy_A
% @M -> @H	  [x,y]+handleposition_M
% @M -> @P	  [x,y]+penposition_M
%
% motoreposition_A = [x,y,psi]
% penposition_M = [-0.135 -0.035]
% handleposition_M = [-0.065,0]
% appcenter2vsheet_A = [142.25,25.4875];
function r = refsys()

% long measures from the PDF
sheet = [];
sheet.height = 745;
sheet.width = 1117;
sheet.originfromright = 676;
sheet.originfromleft = sheet.width -sheet.originfromright ;
sheet.paperheight = 849;
sheet.originfrombottomofpaper = 43+393;
sheet.originfromtop = sheet.paperheight-sheet.originfrombottomofpaper;
sheet.originfrombottom = sheet.height-sheet.originfromtop;
sheet.circlecenterfrombottom = -150;
sheet.circlecenterfromleft = sheet.width/2;
sheet.papercenter = [sheet.originfromleft,sheet.originfrombottom];
sheet.center = [sheet.width/2,sheet.height/2];


r = [];
r.appcenter2vsheet_A_mm = [142.25,25.4875];
r.handleposition_M_m = [-0.065,0]; 
r.penposition_M_m = [-0.135,-0.035];
r.pen2mm = 0.3/8;
r.sheet = sheet;
r.sheet.width = 1117;
r.sheet.height = 745;
r.sheet.vsheetorigin_T_mm = [sheet.originfromleft,sheet.originfrombottom];
r.motoreradius_mm = 166;
r.cutcenter_T_mm = [r.sheet.width/2,-150];
r.cutradius_mm = 300;
r.cutstart_rad = asin(-r.cutcenter_T_mm(2)/r.cutradius_mm );
r.cutend_rad = pi-r.cutstart_rad; 


% Sheet Margins and Sizes
pen2mm = 0.3/8;

% as from C++code
sheetappoffsets = [];
sheetappoffsets.tl = [-10613,0];
sheetappoffsets.tr = [-10613,-19060];
sheetappoffsets.bl = [0,0];
sheetappoffsets.br = [0,-19060];
sheetoffsets = [sheetappoffsets.tl; sheetappoffsets.bl;sheetappoffsets.tr;sheetappoffsets.br];

units = [];
units.R = 'pen';
units.V = 'mm';
units.T = 'mm';
units.A = 'm';
units.C = 'dmm';
units.G = 'mm';
units.M = 'm';
units.P = 'm';
units.H = 'm';

r.units = units;

% Affine: x y psi
txm = []; % RtoV cannot be expressed
txm.VtoT = [1, 0, 0, r.sheet.vsheetorigin_T_mm(1); 0 1, 0, r.sheet.vsheetorigin_T_mm(2); 0 0 1 0; 0 0 0 1];
txm.VtoA = 0.001*[1,0,0,-r.appcenter2vsheet_A_mm(1); 0 1,0,-r.appcenter2vsheet_A_mm(2); 0 0 1000 0; 0 0 0 1];
txm.AtoC = [10000 0 0 0; 0 10000 0 0; 0 0 1 0; 0 0 0 1];
txm.AtoG = [1000 0 0 0; 0 -1000 0 0 ; 0 0 -1 0; 0 0 0 1];  % In graphis positive is clockwise, in app case is counterclockwise
txm.AtoM = @(m) [cos(m(3)+pi/2) -sin(m(3)+pi/2) 0 0; sin(m(3)+pi/2) cos(m(3)+pi/2) 0 0; 0 0 1 0; 0 0 0 1]*[1 0 -m(1) 0 ; 0 1 -m(2) 0 ; 0 0 1 0; 0 0 0 1]; % this depends on the current motore state
txm.MtoH = [1 0 0 -r.handleposition_M_m(1) ; 0 1 0 -r.handleposition_M_m(2); 0 0 1 0; 0 0 0 1];
txm.MtoP = [1 0 0 -r.penposition_M_m(1); 0 1 0 -r.penposition_M_m(2); 0 0 1 0 ; 0 0 0 1];

r.txm = txm;

tx =[];
% @R -> @V    [-y-offsetx[sheet],-x-offsety[sheet]]*0.3/8
tx.RtoV = @(p) [-p(2)-sheetoffsets(p(3),1),-p(1)-sheetoffsets(p(3),2)]*0.3/8;
% @V -> @T    [x+papercenterx,y+papercentery]
tx.VtoT = @(p) p+r.sheet.vsheetorigin_T_mm;
tx.TtoV = @(p) p-r.sheet.vsheetorigin_T_mm;
% @V -> @A    [x+appcenterinvsheet,y+appcenterinvsheet]*0.001
tx.VtoA = @(p) (p-r.appcenter2vsheet_A_mm)*0.001;
tx.AtoV = @(p) (p*1000+r.appcenter2vsheet_A_mm);
% @A -> @C    xy*10000
tx.AtoC = @(p) (p*10000);
tx.CtoA = @(p) (p*0.0001);
% @A -> @G    [x,-y]*1000
tx.AtoG = @(p) 1000*[p(1),-p(2)];
tx.GtoA = @(p) 1000*[p(1),-p(2)];
% @A -> @M    R(motorepsi_A+pi/2)([x,y]-motorexy_A)
tx.AtoM = @(p,m) Rot(m(3)+pi/2)*([p-m(1:2)]);
% @M -> @A    R(-motorepsi_A-pi/2)[x,y]+motorexy_A
tx.MtoA = @(p,m) (Rot(-m(3)-pi/2)*p(1:2)'+m(1:2)')';
% @M -> @H	  [x,y]+handleposition_M
tx.MtoH = @(p) p-r.handleposition_M_m;
tx.HtoM = @(p) p+r.handleposition_M_m;
% @M -> @P	  [x,y]+penposition_M
tx.MtoP = @(p) p-r.penposition_M_m;
tx.PtoM = @(p) p+r.penposition_M_m;
r.tx = tx;

% pen position is expressed in @C
% internally pen position is
syms penx peny real
syms mx my mpsi real
pen_A = tx.CtoA([penx,peny]);
pen_est_A = tx.MtoA(r.penposition_M_m,[mx,my,mpsi]);

% as from Measurements
tl = [];
tl.sheet = 31;
tl.relsheet = 1;
tl.origin = [10500,0]*pen2mm;
tl.corner = [319,11500]*pen2mm; % opposite corner

tr = [];
tr.sheet = 30;
tr.relsheet = 3;
tr.origin = [10500,19000]*pen2mm;
tr.corner = [319,0]*pen2mm;

bl = [];
bl.sheet = 41;
bl.relsheet = 2;
bl.origin = [0,0]*pen2mm;
bl.corner = [10050,11900]*pen2mm;

br = [];
br.sheet = 40;
br.relsheet = 4;
br.origin = [0,19000]*pen2mm;
br.corner = [10050,800]*pen2mm;

margins = [];
margins.left_T_mm = [r.motoreradius_mm,0;r.motoreradius_mm,r.sheet.height];
margins.right_T_mm = [r.sheet.width-r.motoreradius_mm,0;r.sheet.width-r.motoreradius_mm,r.sheet.height];
margins.bottom_T_mm = [0,r.motoreradius_mm;r.sheet.width,r.motoreradius_mm];
margins.top_T_mm = [0,r.sheet.height-r.motoreradius_mm;r.sheet.width,r.sheet.height-r.motoreradius_mm];
margins.center_T_mm = r.cutcenter_T_mm;
margins.radius_T_mm = r.cutradius_mm + r.motoreradius_mm;
margins.center_start_rad = asin(-margins.center_T_mm(2)/margins.radius_T_mm );
margins.center_end_rad = pi -margins.center_start_rad; 

%pL = [margins.center_T_mm(1)+margins.radius_T_mm*cos(margins.center_end_rad); margins.center_T_mm(2)+margins.radius_T_mm*sin(margins.center_end_rad)];
%pR = [margins.center_T_mm(1)+margins.radius_T_mm*cos(margins.center_start_rad); margins.center_T_mm(2)+margins.radius_T_mm*sin(margins.center_start_rad)];

r.margins = margins;

r.sheets.bl = bl;
r.sheets.tr = tr;
r.sheets.br = br;
r.sheets.tl = tl;

function r = Rot(psi)

r = [cos(psi) -sin(psi); sin(psi) cos(psi)];


