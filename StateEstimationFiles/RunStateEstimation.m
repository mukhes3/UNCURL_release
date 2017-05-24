%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Run this function to perform state estimation on a dataset 
%
% Inputs: 
% Dat - data matrix 
% k - no. of clusters 
% Distribution - 'NB' , 'Poiss' or 'ZIP' (default is NB) 
% MeansInit - Initial means (can be empty) 
% eps - functional error tolerance (default 1e-4) OPTIONAL
% IterMax - maximum no. of iterations (default 10) OPTIONAL
%
% Outputs: 
% M - Matrix of estimated means 
% Xconv - Matrix of convex mixture parameters 
% CostPerIter - Cost function value at each iteration
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [M,Xconv,CostPerIter] = RunStateEstimation(Dat,k,Distribution,MeansInit,varargin)

if length(varargin) == 0 
    eps = 1e-4; 
    IterMax = 10; 
elseif length(varargin) == 1
    eps = varargin{1}; 
else
    eps = varargin{1};
    IterMax = varargin{2};
end

[r,c] = size(Dat); 

switch Distribution
    
    case 'Poiss'

        %check if initial means is empty or not
        if length(MeansInit) == 0 
    
            display('Performing initial clustering'); 
    
            MeansInit = KmeansPP([],Dat + 1e-10,k);
            LogLike = zeros(k,c); 

            for i = 1:k 
                LogLike(i,:) = LLfromMeans(Dat,MeansInit(:,i)); 
            end

            Init = AssignLabelsFromLL(LogLike); 
    
            [Pred,LogLike] = PoissHardEM(Init,Dat,5,k);
            MeansInit = CalcMeans(Pred,Dat + 1e-10 ,k); 
        end
    

        %running state estimation 
        display('Performing state estimation');
        [M,Xconv,CostPerIter]   = PoissConvMixModel(Dat + 1e-10,MeansInit,k,eps,IterMax); 

    case 'ZIP'

        %check if initial means is empty or not
        if length(MeansInit) == 0 
    
            display('Performing initial clustering'); 
    
            MeansInit = KmeansPP([],Dat + 1e-10,k);
            LogLike = zeros(k,c); 

            for i = 1:k 
                LogLike(i,:) = LLfromMeans(Dat,MeansInit(:,i)); 
            end

            Init = AssignLabelsFromLL(LogLike); 
    
            [Pred,LogLike] = ZIPHardEM(Init,Dat,5,k);
            MeansInit = CalcMeans(Pred,Dat + 1e-10 ,k); 
        end
    

        %running state estimation 
        display('Performing state estimation');
        [M,Xconv,CostPerIter]   = Zero_PoissConvMixModel(Dat + 1e-10,MeansInit,k,eps,IterMax);         
        
    otherwise

        %check if initial means is empty or not
        if length(MeansInit) == 0 
    
            display('Performing initial clustering'); 
    
            MeansInit = KmeansPP([],Dat + 1e-10,k);
            LogLike = zeros(k,c); 

            for i = 1:k 
                LogLike(i,:) = LLfromMeans(Dat,MeansInit(:,i)); 
            end

            Init = AssignLabelsFromLL(LogLike); 
    
            [Pred,LogLike] = NBHardEM(Init,Dat,5,k);
            MeansInit = CalcMeans(Pred,Dat + 1e-10 ,k); 
        end
    

        %running state estimation 
        display('Performing state estimation');
        [M,Xconv,CostPerIter,~]   = NBConvMixModel(Dat + 1e-10,MeansInit,k,eps,IterMax); 

        
end
end

