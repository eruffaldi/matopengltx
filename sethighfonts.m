function sethighfonts(k)

if nargin < 1
    k = 14;
end

% Change default axes fonts.
set(0,'DefaultAxesFontName', 'Times New Roman')
set(0,'DefaultAxesFontSize', k)

% Change default text fonts.
set(0,'DefaultTextFontname', 'Times New Roman')
set(0,'DefaultTextFontSize', k)

set(gca,'FontSize',k);

set(findall(gcf,'type','text'),'FontSize',k); %,'fontWeight','bold')