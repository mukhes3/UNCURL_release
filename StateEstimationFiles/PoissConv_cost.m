function [cost, grad] = PoissConv_cost(th,Xr,X,n)
%#codegen
coder.inline('never'); 



cost = (1/n)*sum(X*th - Xr.*log(X*th)); 

temp = (Xr./(X*th)); 
 

grad  = (1/n)*(sum(X)' - X'*temp) ;  
end