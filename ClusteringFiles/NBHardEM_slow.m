function [Pred,LogLike] = NBHardEM_slow(Init,Dat,IterMax,k)
%#codegen
coder.inline('never'); 

 eps = 1e-10; 
% Init
[NB_genes, P_genes] = FindNBGenes(Dat,Init,k); 

[R,P] = CalcParamsNB(Init,round(Dat(NB_genes,:)),k); 
% [R,P] = CalcParamsNB2(Init,Dat+eps,k); 

M = CalcMeans(Init,Dat(P_genes,:)+eps,k); 


[~,c] = size(Dat); 




for i = 1:IterMax 

LogLikeNB = zeros(k,c); 
LogLikeP = zeros(k,c); 



for j = 1:k
    

%     LogLike(j,:) = LLfromParams(Dat,R(:,j),P(:,j));
    
    LogLikeNB(j,:) = LLfromParams(Dat(NB_genes,:),R(:,j),P(:,j)); 
    
    if ~isempty(P_genes)
        LogLikeP(j,:) = LLfromMeans2(Dat(P_genes,:),M(:,j));
    else
        LogLikeP(j,:) = zeros(1,c); 
    end
        
end

% LogLikeNB
% LogLikeP

PredLabs = AssignLabelsFromLL(LogLikeNB + LogLikeP); 

% PredLabs = AssignLabelsFromLL(LogLike); 
[NB_genes, P_genes] = FindNBGenes(Dat,PredLabs,k); 

[R,P] = CalcParamsNB(PredLabs,round(Dat(NB_genes,:)),k);

% R(1:10,:)
% P(1:10,:)

% [R,P] = CalcParamsNB2(PredLabs,Dat+eps,k);

if ~isempty(P_genes)
    M = CalcMeans(PredLabs,Dat(P_genes,:)+eps,k);
else
    M = []; 
end


end

LogLike = LogLikeP + LogLikeNB; 

Pred = PredLabs; 

% R(1:10,:)
% P(1:10,:)

end