function [NB_genes, P_genes] = FindNBGenes(Dat,Lab,k)
%#codegen
coder.inline('never'); 

[r,~] = size(Dat); 

M = zeros(r,k); 
V = zeros(r,k); 

for i = 1:k 
    In = find(Lab==i); 
    M(:,i) = mean(Dat(:,In),2); 
    V(:,i) = var(Dat(:,In)')';
    
end

%find poisson genes

I_p = []; 
for i = 1:k 
    I_p = unique(union(find(M(:,i)>=.90*V(:,i)),I_p)); 
end


I_nb = 1:r; 

%find negative binomial genes 

I_nb(I_p) = []; 

P_genes = I_p; 
NB_genes = I_nb; 

end

