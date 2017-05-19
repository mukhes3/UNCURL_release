function In = GetTopXde2(Pval,X)

% M = matrix of means 
% X = no. of top genes from each category 


tempIn = []; 


[a,b] = size(Pval); 

for i = 1:b
    [~,I] = sort(Pval(:,i)); 
    tempIn = [tempIn, I(1:X)'];     

end

In = unique(tempIn);

end