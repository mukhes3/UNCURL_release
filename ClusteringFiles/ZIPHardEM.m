function [Pred,LogLike] = ZIPHardEM(Init,Dat,IterMax,k)
eps = 1e-10; 

[L,M] = CalcParamsZIP(Init,Dat + eps,k);
[r,c] = size(Dat); 

% L(1:10,:)
% M(1:10,:)

for i = 1:IterMax 


LogLike = zeros(k,c); 

for j = 1:k
    LogLike(j,:) = LLfromParamsZIP(Dat,L(:,j),M(:,j)); 
    
end

PredLabs = AssignLabelsFromLL(LogLike); 

[L,M] = CalcParamsZIP(PredLabs,Dat + eps,k);

end


Pred = PredLabs; 

end

