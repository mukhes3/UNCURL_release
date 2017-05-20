%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       Function to calculate the pseudotime 
%
% Inputs: 
% AdjMat - The weighter adjacency matrix 
% StartIn - Starting index of the cell 
%
% Output: 
% Pseudotime - Pseudotime value of each cell 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



function Pseudotime = CalcPseudotime(AdjMat, StartIn)

G = graph(AdjMat); 
d = distances(G); 

Pseudotime = d(:,StartIn)/max(d(:,StartIn)); 
end