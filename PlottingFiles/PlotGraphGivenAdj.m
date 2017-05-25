%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function plots the tree on reduced dimension, given adjancency
% matrix and 2-D data. Optionally it also accepts labels and plots each
% cell type with a different color for each cell type 
%
% Inputs: 
% Adj - n X n matrix 
% Dat - 2 X n matrix 
% Lab - n X 1 matrix  (has numbers 1 to k) 
% k - no. of cell types in the dataset
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function h = PlotGraphGivenAdj(Adj,Dat,Lab,k)

if isempty(Lab)
    Lab = ones(length(Adj),1); 
    k = 1; 
end

G = graph(Adj); 
El = table2array(G.Edges(:,'EndNodes'));

h = ScatterPlotGivenLabels(Dat,Lab,k);

hold on; 
Dat = Dat'; 
for i = 1:length(El(:,1))
    line([Dat(El(i,1),1),Dat(El(i,2),1)],[Dat(El(i,1),2),Dat(El(i,2),2)],'color','k'); 
end

end

