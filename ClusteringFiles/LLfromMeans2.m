function LogLike = LLfromMeans2(x,m)
%#codegen
coder.inline('never'); 

[r,c] = size(x); 
M = repmat(m,1,c); 

% temp = exp(-M).*(M.^x)./factorial(x); 
% LogLike = sum(log(temp)); 
% I = find(x.*M); 
% I2 = find(M); 
% I3 = find((x>0).*(M==0)); 
% 
% temp = zeros(r,c); 
% 
% temp(I2) = -M(I2) + x(I2).*log(M(I2));
% 
% % temp = -M + x.*log(M);
% 
% temp(I) = temp(I) - (x(I).*log(x(I)) - x(I) + .5*log(2*pi*x(I))); 
% temp(I3) = -inf; 

temp = log(poisspdf(x,M)); 

if r>1
    LogLike = sum(temp);
    
else
    LogLike = temp; 
end