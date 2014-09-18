function h = plotrateline(dt,duration,offset,index,active,colors)

v = 0.5;
a = 0.2;

if nargin < 6
    colors = repmat(0.5,length(active),1);
end


x = offset:dt:(offset+duration);
xn = nan(size(x));

% x x NaN
xt = reshape([x';x';xn'],length(x),3)';
    
% index index+l nan
yt = reshape([repmat(index,length(x),1); repmat(v+index,length(x),1);xn'],length(x),3)';

h = line(xt(:),yt(:),'Color','k');
line([0 offset+duration],[index,index],'Color','k');

if isempty(active) == 0
    for I=1:length(x)
        k = 0;
        for J=1:length(active)
            c = colors(J);
            rectangle('Position', [x(I)+k*dt index active(J)*dt a],'FaceColor',[c,c,c]);
            k = k + active(J);
        end
    end
end
