
Z = 0:1000; % < 2047
Zt = @(z_d) 0.1236 * tan(z_d / 2842.5 + 1.1863);
Zl = @(z_d) 1 ./ (z_d * -0.0030711016 + 3.3309495161);
z_l = Zl(Z);
e_l = [Zl(Z+0.5)-Zl(Z-0.5)];
c_l = [Zl(Z+0.5)+Zl(Z-0.5)]*0.5;
figure(1)
plot(z_l*1000)
xlabel('raw sample')
ylabel('distance (mm)');
figure(2)
plot(e_l*1000)
xlabel('raw sample')
ylabel('span (mm)');
figure(3)
SS = e_l*1000;
scatter(c_l*1000,e_l*1000)
xlabel('center (mm)');
ylabel('extent (mm)');

% 
% scatter(X,Y,S,'s')
% xlabel('raw sample')
% ylabel('center (mm)');
% currentunits = get(gca,'Units');
% set(gca, 'Units', 'Points');
% axpos = get(gca,'Position');
% set(gca, 'Units', currentunits);
% marker_rel=5;
% markerSize =  SS / diff(ylim)*axpos(4);
% set(get(gca, 'children'), 'sizedata', markerSize);

