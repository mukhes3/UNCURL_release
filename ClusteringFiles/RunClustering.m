%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Call this function to run any of the many clustering options of UNCURL  
%              
% Inputs: 
% Dat - Data matrix 
% k - no. of clusters 
% Distribution - 'NB' (default), 'NB_slow', 'Poiss' or 'ZIP'
% InitMeans - Matrix of initial means (can be empty)  
% IterMax (optional) - Maximum no. of iterations to run EM algorithm for 
% (default 5)
% 
% Outputs: 
% PredLabs - Predicted labels (1 to k) 
% LogLike - LogLikelihood matrix of dimension ( cell types X no. of cells) 
%
% 'NB_slow' is Negative Binomial without a mex file. We do not recommend 
% this option for large files. 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pred,LogLike] = RunClustering(Dat, k, Distribution, InitMeans, varargin)

eps = 1e-10 ; %small number that needs to be added to data matrix to avoid 
%numberical issues. 

if length(varargin) > 0 
    IterMax = varargin{1}; 
else
    IterMax = 5; 
end

%get initial clusters 

Means = KmeansPP(InitMeans,Dat + eps,k);
[r,c] = size(Dat); 

LogLike = zeros(k,c); 

for i = 1:k 
    LogLike(i,:) = LLfromMeans(Dat,Means(:,i)); 
end

Init = AssignLabelsFromLL(LogLike); 

%get final clusters 

switch Distribution
    case 'NB'
        [Pred,LogLike] = NBHardEM(Init,Dat,IterMax,k);
    case 'NB_slow'
        [Pred,LogLike] = NBHardEM_slow(Init,Dat,IterMax,k);
    case 'Poiss'
        [Pred,LogLike] = PoissHardEM(Init,Dat,IterMax,k);
    case 'ZIP'
        [Pred,LogLike] = ZIPHardEM(Init,Dat,IterMax,k);
    otherwise
        [Pred,LogLike] = NBHardEM(Init,Dat,IterMax,k);
end

end