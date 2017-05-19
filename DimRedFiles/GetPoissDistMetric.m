%this function generates the Poiss distance matrix

%input:
% Dat - data matrix

%output:
%PoissMetric - distance matrix


function PoissMetric = GetPoissDistMetric(Dat)

[r,c] = size(Dat); 

TempMat = zeros(c); 

%get pairwise distance for each element
for i = 1:c
    for j = i+1:c
        x = Dat(:,i);
        y = Dat(:,j);
        TempMat(i,j) = abs(PoissConv_cost(1,x,x,r) + PoissConv_cost(1,y,y,r) ...
            - PoissConv_cost(1,x,y,r) - PoissConv_cost(1,y,x,r)); 
        TempMat(j,i) = TempMat(i,j); 
    end
    
    %print iteration number every 10 iterations
    if mod(i,25)==0
        i
    end
end


PoissMetric = TempMat; 