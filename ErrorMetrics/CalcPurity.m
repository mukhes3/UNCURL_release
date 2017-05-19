%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%      This function calculates the purity of clusters 
%
% Inputs :-  actual and predicted labels (1 to k)   
% Outputs :- Purity of each predicted cluster , predicted labels 
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Purity,LabMap] = CalcPurity(Act,Pred)

k = length(unique(Act)); 

tempPurity = zeros(k,1); 
LabMap = zeros(k,1); 


for i = 1:k
    temp = zeros(k,1); 
    for j = 1:k
        temp(j) = sum((Act==j).*(Pred==i)); 
%         temp(j) = length(intersect(find(Act==j),find(Pred==i))); %find number of predicted cells in each cell type 
    end
    
    [tempPurity(i),LabMap(i)] = max(temp); 
end

Purity = sum(tempPurity)/length(Act); 
end

