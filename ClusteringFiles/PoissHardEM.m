%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           General purpose poisson Hard EM function 
%
%                               Sumit Mukherjee 
%
%  Input - Initial clusters 
%  Output - predicted clusters, final loglikelihood
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pred,LogLike] = PoissHardEM(Init,Dat,IterMax,k)

%#codegen
coder.inline('never'); 
eps = 1e-10; 


MeanMat = CalcMeans(Init,Dat + eps,k);
[~,c] = size(Dat); 


for i = 1:IterMax 


LogLike = zeros(k,c); 

for j = 1:k
    LogLike(j,:) = LLfromMeans(Dat,MeanMat(:,j)); 
    
end

PredLabs = AssignLabelsFromLL(LogLike); 

MeanMat = CalcMeans(PredLabs,Dat + eps,k);

end


Pred = PredLabs; 

end


