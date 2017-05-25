function LogLike = LLfromParamsZIP(x,l,m)

[r,c] = size(x); 
M = repmat(m,1,c); 
L = repmat(l,1,c); 

I2 = find(x<1); 
I = find(x>=1);

temp = zeros(r,c); 

temp(I) = +log(1 - M(I)) + x(I).*log(L(I)) - L(I) - (x(I).*log(x(I)) - x(I) + .5*log(2*pi*x(I))); 
temp(I2) = +log(M(I2) + (1-M(I2)).*exp(-L(I2))) ; 

if r>1
    LogLike = sum(temp); 
else
    LogLike = temp; 
end