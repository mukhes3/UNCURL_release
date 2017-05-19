%this function calculates the convex weight for the of PoissNMF
% algorithm

% inputs: 
% dat - transpose of data matrix 
% M - Matrix of means
% X_init - Inital matrix of convex weights 

% outputs: 
% Xconv - Estimated weight matrix 
% Lab - labels based on Xconv

function [Xconv,Lab] = nbConMix_run(dat,R,M,x_init)

[n,b] = size(dat); 


X = x_init;

ind = [1:b]; 
[~,m] = size(M); 
Lab = zeros(1,b); 

options = optimoptions('fmincon','Algorithm','sqp','MaxFunEvals',3000,'MaxIter',3000,'Display','off'); 

for i = 1:b     
    Y = dat(:,i); 
    x0 = x_init(:,i); 
%       i
      tmp = fmincon(@(x) NBConv_cost(x,Y,M,R,n),x0,[],[],[],[],zeros(m,1),[],[],options);  
%     tmp = fmincon(@(x) PoissConv_cost(x,Y,M,n),x0,[],[],[],[],zeros(m,1),[],[],options);  
    X(:,i) = tmp;
%     x0
%     tmp
    [~,Lab(i)] = max(tmp); 
end

Xconv = X; 

end