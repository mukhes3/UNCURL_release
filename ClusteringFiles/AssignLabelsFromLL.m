%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%       This function assigns cells to classes based on log likelehood
%
%   Input :- Loglikelihood matrix . rows = no of classes, cols = no of
%   cells
%   
%   Output :- Predict labels for each cell
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function PredLabs = AssignLabelsFromLL(LogLike)


[~,PredLabs] = max(LogLike); 


