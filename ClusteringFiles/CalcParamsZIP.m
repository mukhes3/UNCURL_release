function [L,M] = CalcParamsZIP(Lab,Dat,k)

[r,c] = size(Dat); 

L = zeros(r,k); 
M = zeros(r,k); 

for i = 1:k 
    In = find(Lab==i); 
    
    %using method of moments based estimators 
    m = mean(Dat(:,In)')'; %+ 1e-20*rand(r,1);
    v = var(Dat(:,In)')'; %+ 1e-20*rand(r,1);
    
    
    L(:,i) = max(zeros(r,1),(v + m.^2 - m)./m ); 
    M(:,i) = min(ones(r,1),max(zeros(r,1),(v - m)./ (v + m.^2 - m))); 
%          [L(:,i),M(:,i)] = ZIP_EM(Dat(:,In)); 

end

end