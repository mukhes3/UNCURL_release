%x - matrix of observed counts (rows - nodes, coloumns - observations)
%r - coloumn vector of NB parameters 
%p - coloumn vector of NB parameters 

function LogLike = LLfromParams(x,r,p)
%#codegen
coder.inline('never'); 

[r1,c1] = size(x); 
R = repmat(r,1,c1); 
P = repmat(p,1,c1); 

% temp = exp(-M).*(M.^x)./factorial(x); 
% LogLike = sum(log(temp)); 

temp = log(nbinpdf(x,R,P)); 


if r1>1
    LogLike = sum(temp); 
else
    LogLike = temp; 
end


end