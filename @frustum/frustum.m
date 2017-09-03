classdef frustum
    %frustum representation class
    %
    % Alternative representation with points and planes
    %   planes: 4..6 using support points
    %   points: center + corners (5 or 8)
    
    properties
        proj0 
        proj  
        pose
    end
    
    methods
        function self = frustum(P)
            self.proj = P;
            self.proj0 = P;
            self.pose = eye(4);
        end
        
        
        function p = worldPointToLocal(self,p)
            p4 = self.proj*[p(:);1];
            p = p4(1:3)/p4(4);
        end
        
        function p = localPointToWorld(self,p)
            p4 = self.proj\[p(:);1];
            p = p4(1:3)/p4(4);
        end
        
        function po = pixelToLocal(self,p,w,h)
            pp = 2*p./[w,h]-[1,1];
            po = [pp(:);-1];
        end

        function pW = pixelToWorld(self,p,w,h)
            pL = self.pixelToLocal(p,w,h);
            pW = self.localPointToWorld(pL);
        end

        % transform the frustum using the matrix affine M
        function self = transformByMatrix(self,M)
            self.pose = M* self.pose;
            self.proj = self.proj0 * self.pose;
        end
        
        % transform the frustum using the matrix rotation and position
        function self = transformByRotPos(self,R,p)
            A= eye(4);
            A(1:3,1:3) = R;
            A(1:3,4) = p;
            self = self.transformByMatrix(A);
        end
        
        function r = hasNear(self)
            r = self.proj(1,1) > 0;
        end
        
        function r = hasFar(self)
            r = isnan(self.proj(3,4)) == 0;
        end
              
        function newplane = worldPlaneToLocal(self,p)
            newplane = (inv(self.proj)'*p);
        end

        function newplane = localPlaneToWorld(self,p)
            newplane = (self.proj'*p);
        end
        
        
        function [c,r] = getboundingsphere(self)
            cors = self.getcorners();
            [r,c] = ExactMinBoundSphere3D(cors');
        end

        function [c,r] = getboundingspherefast(self)
            cors = self.getcorners();
            c = mean(cors,2);
            r = sqrt(max(sum((cors-repmat(c,1,8)).^2,1)));
            
        end
        
        % in normalized coordinates this is [0,0,-1]
        function p = getOrigin(self)
            p = self.pose(1:3,4);
        end

        function r = getPlanesLocal(self)
            % near far left,right,bottom,top
            r = [0,0,1,1;0,0,-1,1;1,0,0,1; -1,0,0,1; 0,1,0,1; 0,-1,0,1];
        end
        
        function planes = getPlanes(self,asstruct)            
            M = self.proj;            
            planes = [];
            if(self.hasNear())
                planes.near = M(4,:)+M(3,:);
                if(self.hasFar())
                    planes.far = M(4,:)-M(3,:);
                end
            else
                % origin in 0 and frustum is limited
                %planes.far = 
            end
            planes.left = M(4,:)+M(1,:);
            planes.right = M(4,:)-M(1,:);
            planes.bottom = M(4,:)+M(2,:);
            planes.top = M(4,:)-M(2,:);
            if asstruct == 0
                ff = fieldnames(planes);
                pp = zeros(length(ff),4);
                for I=1:length(ff)
                    pp(I,:) = planes.(ff{I});
                end
                planes = pp;
            end
        end

        % slice the frustum by the plane (oblique frustum)
        function self = slicenearplane(self,normal,point)
            M = self.proj;
            C = [normal(:)',-sum(normal.*point)];
            Cp = inv(M)'*C;
            Qp = [sgn(Cp(1)),sgn(Cp(2)),1,1];
            Q = inv(M)*Qp;
            M3p = (2*M(4,:)*Q/(C*Q))*C-M(4,:);
            self.proj(3,:) = M3p;            
        end
        
        % returns the corners: first near clockwise, then far
        function xyz = getcorners(self)
            x=[0 1 1 0 0 1 1 0]*2-1;
            y=[0 0 1 1 0 1 0 1]*2-1; 
            z=[0 0 0 0 1 1 1 1]*2-1;
            w = ones(size(x));
            ppts = [x(:),y(:),z(:),w(:)]';
            wpts = inv(self.proj)*ppts;
            xyz = wpts(1:3,:)./repmat(wpts(4,:),3,1);
        end
        
        
        function r = verifyPlanes(self)
            pW = self.getPlanes(0); % N x 4
            pL = self.getPlanesLocal();
            
            pWL = self.worldPlaneToLocal(pW')';
            pLW = self.localPlaneToWorld(pL')';
            pL
            pWL
            pW
            pLW
        end 
        
        % assuming the camera has pixel xy and resolution wh returns
        % the real world space frustumc corresponding to that pixel
        %function pt = getpixelfrustum(self,xy,width,height)
        %end
        function [r,output] = intersectFrustum2(self,other)
            p2W = other.getPlanes(0);
            p2L = self.worldPlaneToLocal(p2W')';
            A = -p2L(:,1:3);
            b = p2L(:,4);
            [r,~,~,output] = linprog(ones(3,1),A,b,[],[],-ones(3,1),ones(3,1));
            r = isempty(r) == 0;
        end
        
        
        function [r,output] = intersectFrustum(self,other)
            p1 = self.getPlanes(0);
            p2 = other.getPlanes(0);
            p = [p1;p2];
            A = -p(:,1:3);
            b = p(:,4);
            % A x >= -b 
            % - Ax <= b
            [r,~,~,output] = linprog(ones(3,1), A,b);
            r = isempty(r) == 0;
        end
    
        % intersect against a sphere
        function b = intersectSphere(self,center,radius)
            pp = self.getPlanes(1);
            f = fieldnames(pp);
            negRadius = -radius;
            for J=1:length(f)
                p = pp.(f{J});
                d2p = sum(p.*center);
                if d2p < negRadius
                    b = false;
                    return;
                end
            end
            b = true;
        end
        
        % display
        function hh = visualize(self)
            x=[0 1 1 0 0 0;1 1 0 0 1 1;1 1 0 0 1 1;0 1 1 0 0 0]*2-1;
            y=[0 0 1 1 0 0;0 1 1 0 0 0;0 1 1 0 1 1;0 0 1 1 1 1]*2-1;
            z=[0 0 0 0 0 1;0 0 0 0 0 1;1 1 1 1 0 1;1 1 1 1 0 1]*2-1;
            w = ones(size(x));
            ppts = [x(:),y(:),z(:),w(:)]';
            wpts = inv(self.proj)*ppts;
            xyz = wpts(1:3,:)./repmat(wpts(4,:),3,1);
            
            hh = [];
            ax = reshape(xyz(1,:),4,[]);
            ay = reshape(xyz(2,:),4,[]);
            az = reshape(xyz(3,:),4,[]);
            for i=1:6
                h=patch(ax(:,i),ay(:,i),az(:,i),'k');
                hh(end+1) = h;
                set(h,'edgecolor','w')
            end            
        end
        
        function s = asfrustumparams(self)
            s = mglInvFrustum(self.proj);
        end
        
        function [K,near,far] = asintrinsics(self,width,height)
            [K,near,far] = mvPrj2Intrinsics(self.proj,width,height);
        end
    end

    methods(Static)
        % from OpenCV compatible intrinsics and near/far specification
        function r = fromintrinsics(K,near,far,w,h)
            r = frustum(mcvIntrinsics2Prj(K,near,far,w,h));
        end
        
        % from OpenGL glFrustum
        function r = glFrustum(l,r,b,t,n,f)
            if nargin == 1
                M = mglFrustum(l);
            else
                M = mglFrustum(l,r,b,t,n,f);
            end
            r = frustum(M);            
        end
        
        % from OpenGL gluPerspective
        function r = gluPerspective (fovyDeg,ratio_xovery,n,f)
            r = frustum(mgluPerspective(fovyDeg,ratio_xovery,n,f));
        end
        
        function M = glOrtho(l,r,b,t,n,f)
            r = frustum(mglortho(l,r,b,t,n,f));
        end
        
        % TODO: eye projection matrix for stereo vision: 
        % see [PL,PR,Zcull] = buildstereoLR(screenWidth,ratio,eyeScreenDistance,ipd,nearfar,mode)
    end

end

