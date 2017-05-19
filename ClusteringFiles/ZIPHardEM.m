function [Pred,LogLike] = ZIPHardEM(Init,Dat,IterMax,k)

[L,M] = CalcParamsZIP(Init,Dat,k);
[r,c] = size(Dat); 

% L(1:10,:)
% M(1:10,:)

for i = 1:IterMax 


LogLike = zeros(k,c); 

for j = 1:k
    LogLike(j,:) = LLfromParamsZIP(Dat,L(:,j),M(:,j)); 
    
end

PredLabs = AssignLabelsFromLL(LogLike); 

[L,M] = CalcParamsZIP(PredLabs,Dat,k);

end


Pred = PredLabs; 

end

