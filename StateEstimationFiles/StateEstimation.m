%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Run this function to perform state estimation on a dataset 
%
% Inputs: 
% Dat - data matrix 
% k - no. of clusters 
% Distribution - 'NB' , 'Poiss' or 'ZIP' (default is NB) 
% MeansInit - Initial means (can be empty) 
% Reps - No. of repeats to run state estimation for. Do not enter 0 unless
% for semi-supervised case. 
% eps - functional error tolerance (default 1e-4) OPTIONAL
% IterMax - maximum no. of iterations (default 10) OPTIONAL
%
% Outputs: 
% M - Matrix of estimated means 
% Xconv - Matrix of convex mixture parameters 
% CostPerIter - Cost function value at each iteration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M,Xconv,CostPerIter] = StateEstimation(Dat,k,Distribution,MeansInit,Reps,varargin)

if length(varargin) == 0 
    eps = 1e-4; 
    IterMax = 10; 
elseif length(varargin) == 1
    eps = varargin{1}; 
else
    eps = varargin{1};
    IterMax = varargin{2};
end

CostMin = Inf; 

if (Reps == 0) && isempty(MeansInit)
    error('You cant have zero reps in unsupervised case'); 
end

%Running state estimation for unsupervised case
for i = 1:Reps 
    
    display(strcat('Repeat no.',int2str(i))); 
    
    [M2,Xconv2,CostPerIter2] = RunStateEstimation(Dat,k,Distribution,[],eps,IterMax); 
    
    if CostPerIter2(end)<=CostMin
        CostMin = CostPerIter2(end);
        CostPerIter = CostPerIter2; 
        M = M2; 
        Xconv = Xconv2; 
    end
end
    
%Running state estimation for semi-supervised case
if ~isempty(MeansInit)
    [M2,Xconv2,CostPerIter2] = RunStateEstimation(Dat,k,Distribution,MeansInit,eps,IterMax);
    
    if CostPerIter2(end)<=CostMin
        CostMin = CostPerIter2(end);
        CostPerIter = CostPerIter2; 
        M = M2; 
        Xconv = Xconv2; 
    end
    
end



end

