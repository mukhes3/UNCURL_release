% This function superimposes the rectangular heatmap onto a spherical
% surface

function [X,h] = GenSphericalHMap(MeanSpMat, nam) 


m = min(MeanSpMat(:));

MeanSpMat = MeanSpMat - m; 

M = max(MeanSpMat(:)); 


% X = [MeanSpMat, fliplr(MeanSpMat); 1.5*M*ones(1,16); zeros(8,16)];
X = [MeanSpMat, fliplr(MeanSpMat)];

[x,y,z] = sphere(64);

x = x(33:end,:); 
y = y(33:end,:);
z = z(33:end,:);

h = surface(x,y,z, 'FaceColor','texturemap','EdgeColor','none','Cdata',flipud(M-X)); 

colormap summer; 

view([0,0]);
set(gca,'YTick',[]);
set(gca,'XTick',[]);
set(gca,'xticklabel',[]);
set(gca,'yticklabel',[]);
set(gca,'ZTick',[])

set(gca, 'xcolor', 'w', 'ycolor', 'w') ;
set(gca, 'xcolor', 'w', 'ycolor', 'w', 'zcolor', 'w') ;

xlabel(nam, 'Color','k','FontSize',16); 

