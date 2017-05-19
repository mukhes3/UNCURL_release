%this function converts binary landmark gene value to quantitative values

function Means = GetLandmarkMeans(Dat,BinMap)

[m1,m2] = FindQualMeans(Dat);

M = sort([m1;m2]);

I1 = find(BinMap==1); 
I0 = find(BinMap==0); 

temp = zeros(size(BinMap)); 




temp(I1) = M(2); 
temp(I0) = M(1);

Means = temp; 

end

