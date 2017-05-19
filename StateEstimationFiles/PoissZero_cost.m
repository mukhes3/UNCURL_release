function [cost, grad] = PoissZero_cost(th,Xr,X,n,Z)
%#codegen
coder.inline('never'); 



cost = (1/n)*sum(Z.*(X*th - Xr.*log(X*th))); 

% temp = (1 -  Xr./(X*th));
temp = (Xr./(X*th));

X2 = X.*repmat(Z,1,length(th)); 

grad  = (1/n)*(sum(X2)' - X2'*temp) ;  
end