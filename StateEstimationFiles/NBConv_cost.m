function [cost, grad] = NBConv_cost(th,Xr,X,R,n)
%#codegen
coder.inline('never'); 

cost = (1/n)*(sum((Xr + R).*log(X*th + R)) - sum(Xr.*log(X*th))); 

temp = (Xr + R)./(X*th + R) - Xr./(X*th); 


grad  = (1/n)*(X'*temp) ;  
end