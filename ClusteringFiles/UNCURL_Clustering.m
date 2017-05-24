%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  Call this function to run any of the many clustering options of UNCURL  
%              
% Inputs: 
% Dat - Data matrix 
% k - no. of clusters 
% Distribution - 'NB' (default), 'NB_slow', 'Poiss' or 'ZIP'
% InitMeans - Matrix of initial means (can be empty) 
% Reps - No. of repeats to run state estimation for. Do not enter 0 unless
% for semi-supervised case. 
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

function [Pred,LogLike] = UNCURL_Clustering(Dat, k, Distribution, InitMeans, Reps, varargin)

if length(varargin) > 0 
    IterMax = varargin{1}; 
else
    IterMax = 5; 
end


CostMax = -Inf; 
%running for unsupervised case 
for i = 1:Reps 

    display(strcat('Repeat no.',int2str(i))); 
    
    [Pred2,LogLike2] = RunClustering(Dat, k, Distribution, [], IterMax); 
    
    if sum(max(LogLike2))>CostMax
        CostMax = sum(max(LogLike2)); 
        Pred = Pred2; 
        LogLike = LogLike2; 
    end
end
    

%running for semi-supervised case 
if ~isempty(InitMeans)
    
    [Pred2,LogLike2] = RunClustering(Dat, k, Distribution, InitMeans, IterMax); 
    
    if sum(max(LogLike2))>CostMax
        CostMax = sum(max(LogLike2)); 
        Pred = Pred2; 
        LogLike = LogLike2; 
    end
end 

