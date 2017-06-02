%this function calculates the convex weight for the of Zero Inflated PoissNMF
% algorithm

% inputs: 
% dat - transpose of data matrix 
% M - Matrix of means
% X_init - Inital matrix of convex weights 

% outputs: 
% Xconv - Estimated weight matrix 
% Lab - labels based on Xconv

function [Xconv,Lab] = pConMix_runZero(dat,M,x_init,Z)

[n,b] = size(dat); 


X = x_init;

ind = [1:b]; 
[~,m] = size(M); 
Lab = zeros(1,b); 

options = optimoptions('fmincon','Algorithm','sqp','MaxFunEvals',3000,'MaxIter',3000,'Display','off'); 

for i = 1:b 
%     Xr = X(:,i); 
%     temp_ind = [ind(ind<i),ind(ind>i)]; 
%     x_init = theta_temp(i,temp_ind)'; 
%     X_temp = X(:,temp_ind);
%     funObj = @(th)LPGM_cost(th,Xr,X_temp,N);
%     theta(i,temp_ind) = L1General2_TMP2(funObj,x_init,rho,options); % assumes L1 general is added to path 
    %theta(i,temp_ind) = fminunc(@(x) pglasso_fun(x,Xr,X_temp,N,rho),x_init,options);
    Y = dat(:,i); 
    x0 = x_init(:,i); 
%       i
%      tmp = fmincon(@(x) PoissConv_cost(x,Y,M,n),x0,[],[],ones(1,m),1,zeros(m,1),[],[],options);  
     tmp = fmincon(@(x) PoissZero_cost(x,Y,M,n,Z(:,i)),x0,[],[],[],[],zeros(m,1),[],[],options);  
    X(:,i) = tmp;
%     x0
%     tmp
    [~,Lab(i)] = max(tmp); 
end

Xconv = X; 

end