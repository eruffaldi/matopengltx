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

        % slice the frustum by the plane (oblique frustum)
        function self = slice(self,plane)
        end
        
        % returns the corners: first near clockwise, then far
        function self = corners(self)
            
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
        function self = visualize(self)
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
            r = frustum(mcvIntrinsics2Prj(K,near,far,w,h);
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

