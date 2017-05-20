%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     This code implements the QualNorm framework for semi-supervision
%
% Inputs:-  
% Dat - Data matrix (dimension n x d)
% B - Binary input matrix (dimension n x k0) 
% k - number of cell types 
%
% Outputs:- 
% M - quantitative means 
%
% Note: Genes for which information isn't available should have all entries
% set to -1 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function M = QualNorm(Dat, B, k)

[n,d] = size(Dat); 
[n0,k0] = size(B); 

%check if dimensions are inconsistent 
if (k < k0)||(n ~=n0)
    error('Dimension mismatch'); 
end

%get valid indices 
In = find(B(:,1)>=0);

Means = zeros(n,k0); 

%get qualitative means for the subset of genes and cell types with known
%information 

for i = 1:length(In)
        [m1,m2] = FindQualMeans(Dat(In(i),:) + 1e-10); 
    
    temp = sort([m1,m2]); 
    
    I1 = B(In(i),:)==0; 
    I2 = B(In(i),:)==1;
    Means(In(i),I1) = temp(1); 
    Means(In(i),I2) = temp(2); 

end

%if information isn't available about all cell types 
if k0<k 
    Means = KmeansPP(Means(In,:),Dat(In,:) + 1e-10, k); 
end

%if information isn't available about all genes 
if length(In) < n 
    [Pred,LogLike] = PoissHardEM(Means,Dat(In,:) + 1e-10,1,k); 
    Means = CalcMeans(Pred,Dat + 1e-10,k); 
end

M = Means; 
end