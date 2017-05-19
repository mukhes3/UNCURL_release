%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% this function plots on reduced dimension cell types in different colors
%
% Inputs : 
% RedDim - reduced dimension representation (assume 2 X n dimension) 
% Lab - Labels for the data (assuming numbers between 1 & k) 
% k - no. of types in data 
%
% Outputs : 
% h - figure handle 
%
% Note - Use this function only if you don't have the MATLAB Statistics and
% Machine Learning toolbox. If you have that, use the function
% gplotmatrix() instead. 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function  h = ScatterPlotGivenLabels(RedDim,Lab,k)

map = colormap; 
l = length(map(:,1)); 
clr_in = round(linspace(1,l,k)); 

h = figure()
hold on; 
for i = 1:k 
    In = find(Lab==i); 
    scatter(RedDim(1,In),RedDim(2,In),[],map(clr_in(i),:),'filled'); 
end

xlabel('Dim 1'); ylabel('Dim 2'); legend([],'location','Best'); 


end
