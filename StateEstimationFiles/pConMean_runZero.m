%this function calculates the means in the mean estimation step of Zero Inflated PoissNMF
% algorithm

% inputs: 
% dat - transpose of data matrix 
% Xconv - Convex weight matrix
% M_init - Inital matrix of means for each cell type

% outputs: 
% GeneMean - Transpose of estimated mean matrix 
% fCost - value of final cost function


function [GeneMean,fCost] = pConMean_runZero(dat,Xconv,M_init,Z)


[n,b] = size(dat); 


X = M_init;

ind = [1:b]; 
[~,m] = size(Xconv); 
Lab = zeros(1,b); 

options = optimoptions('fmincon','Algorithm','sqp','MaxFunEvals',3000,'MaxIter',3000,'Display','off'); 
fCost = 0; 
for i = 1:b 
    Y = dat(:,i);
    x0 = M_init(:,i); 
%     i
    tmp = fmincon(@(x) PoissZero_cost(x,Y,Xconv,n,Z(:,i)),x0,[],[],[],[],zeros(m,1),[],[],options);  
    X(:,i) = tmp;
    tmpCost = PoissZero_cost(tmp,Y,Xconv,n,Z(:,i)); 
    fCost = fCost + tmpCost; 
%     x0
%     tmp
end

GeneMean = X; 

end