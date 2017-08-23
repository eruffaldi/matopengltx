classdef frustum
    %frustum representation class
    
    properties
        proj
    end
    
    methods
        function self = frustum(P)
            self.proj = P;
        end
        
        % transform the frustum using the matrix affine M
        function self = transformByMatrix(self,M)
            self.proj = self.proj * M;
        end
        
        % transform the frustum using the matrix rotation and position
        function self = transformByRotPos(self,R,p)
            A= eye(4);
            A(1:3,1:3) = R;
            A(1:3,4) = p;
            self = self.transformByMatrix(A);
        end

        function [c,r] = getboundingsphere(self)
            cors = self.getcorners();
            [r,c] = ExactMinBoundSphere3D(cors');
        end
        
        function planes = getplanes(self)            
            M = self.proj;
            planes = [];
            planes.near = M(4,:)+M(3,:);
            planes.far = M(4,:)-M(3,:);
            planes.left = M(4,:)+M(1,:);
            planes.right = M(4,:)-M(3,:);
            planes.bottom = M(4,:)+M(2,:);
            planes.top = M(4,:)-M(2,:);
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
        
        % assuming the camera has pixel xy and resolution wh returns
        % the real world space frustumc corresponding to that pixel
        function pt = getpixelfrustum(self,xy,width,height)
        end

        % intersect TODO
        function self = intersect(self,other)
        end
        
        % union (HOW?)
        function self = union(self,other)
        end

        % clip a line by the frustum
        function self = clipline(self,line)
        end
        
        % converts to mesh
        function self = tomesh(self)
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

