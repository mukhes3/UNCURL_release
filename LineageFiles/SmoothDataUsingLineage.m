%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%    Run this function to obtain the pseudotime value for each cell and the
%    smoothed gene expression values 
%
%Inputs:- 
% AdjW - Weighted Adjacency matrix 
% StartIn - Starting cell index for pseudotime calculation 
% Dat - Original data matrix 
% 
%Outputs:- 
%Pseudotime - Pseudotime values for all cells 
%FitMat - Smoothed & scaled values for all genes 
%ScMat - Scaled values for all genes (not smoothed) 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pseudotime, FitMat, ScMat] = SmoothDataUsingLineage(AdjW, StartIn, Dat)

%Get pseudotime values 
Pseudotime = CalcPseudotime(AdjW, StartIn); 

%Get smoothed and fitted gene values 
[FitMat,ScMat] = FitGenes(Dat,Pseudotime); 

end


