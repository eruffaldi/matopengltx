

T =0.1;
xunit = 1000;
vicondt = 1/125;
gfxdt = 1/60;
simdt = 1/100;

viconlatency = 2/(xunit*vicondt); % 2 ms latency

hv = plotrateline(xunit*vicondt,xunit*T,vicondt/3*xunit,4,[viconlatency]);
hold on
hv = plotrateline(xunit*simdt,xunit*T,simdt/2*xunit,3,0.1);

%(dt,duration,offset,index,name,active)
hg = plotrateline(xunit*gfxdt,xunit*T,0.2,2,[0.05,0.2,0.2],[0.6,0.4,0.4]);

%(dt,duration,offset,index,name,active)
hg = plotrateline(xunit*gfxdt,xunit*T,0.2,1,[0.4,0.05,0.2,0.2],[0.9,0.6,0.4,0.4]);
hold off
ylim([0,5]);
xlim([0 xunit*T])
set(gca,'YTick',[1:4]);
set(gca,'YTickLabel',{'Graphics (pre-wait) 60Hz','Graphics 60Hz','Simulation 100Hz','Vicon 125Hz'});
xlabel('Time (ms)');

% Create arrow
annotation(gcf,'arrow',[0.33105164903547 0.387056627255756],...
    [0.596905759162304 0.456544502617801]);

% Create arrow
annotation(gcf,'arrow',[0.410703173615432 0.442439327940261],...
    [0.605282722513089 0.290052356020942]);


sethighfonts(18)


%%
 addpath '/Users/eruffaldi/Documents/work/enelcc/enelaudiowin/code/packages/export_fig'
export_fig('latency','-transparent','-pdf')