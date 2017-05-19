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

MeanMat = CalcMeans(Init,Dat,k);
[~,c] = size(Dat); 


for i = 1:IterMax 


LogLike = zeros(k,c); 

for j = 1:k
    LogLike(j,:) = LLfromMeans(Dat,MeanMat(:,j)); 
    
end

PredLabs = AssignLabelsFromLL(LogLike); 

MeanMat = CalcMeans(PredLabs,Dat,k);

end


Pred = PredLabs; 

end


