addpath /Users/eruffaldi/Documents/work/enelcc/enelaudiowin/code/packages/export_fig

hwidth = 0.14976 ;
ipd = 0.0675;
convergence = 0.041 ;

eyesep = ipd/hwidth;
sep = eyesep;
z = 0.02:0.01:0.5;
nz = z./convergence;
parallax = sep*(1-convergence./z);
figure(1);
plot(z,parallax);

line([z(1) z(end)],[eyesep eyesep],'LineStyle',':');
line([z(1) z(end)],[-eyesep -eyesep],'LineStyle',':');
line([convergence convergence],[min(parallax),max(parallax)],'Color','k');
sethighfonts
xlabel('Depth (m)');
ylabel('Parallax (normalized)');
title('Parallax plot using Oculus parameters. Dashed line are eye sep')


figure(2);

plot(nz,parallax);
line([nz(1) nz(end)],[eyesep eyesep],'LineStyle',':');
line([nz(1) nz(end)],[-eyesep -eyesep],'LineStyle',':');
line([1 1],[min(parallax),max(parallax)],'Color','k');
xlabel('Depth (normalized)');
ylabel('Parallax (normalized)');
sethighfonts

%%
export_fig('parallax','-transparent','-pdf')