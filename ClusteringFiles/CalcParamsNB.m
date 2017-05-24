function [R,P] = CalcParamsNB(Lab,Dat,k) 
%#codegen
coder.inline('never'); 

[r,~] = size(Dat); 

R = zeros(r,k); 
P = zeros(r,k); 


options = statset('Display','off','MaxIter',50,'TolBnd',1e-4,'TolFun',1e-4,'TolX',1e-4,'MaxFunEvals',100); 

for i = 1:k 
%     In = find(Lab==i); 
    
    for j = 1:r
        temp = nbinfit_custom(Dat(j,Lab==i),options);
%         temp = nbinfit(Dat(j,Lab==i),[],options);
        R(j,i) = temp(1); 
        P(j,i) = temp(2);
    end
    
%     M = mean(Dat(:,In)')'; 
%     V = var(Dat(:,In)')';
%     
%     P(:,i) = 1 - M./V; 
%     R(:,i) = M.*(1-P(:,i))./P(:,i); 


end


end