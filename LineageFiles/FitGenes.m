function [FitMat,ScMat] = FitGenes(Dat,Pseudotime)

Dat2 = zeros(size(Dat));
ScMat = zeros(size(Dat));
for i = 1:length(Dat(:,1))
    %normalize all genes to have max value of 1 and min value of 0
    temp = Dat(i,:) - min(Dat(i,:)); 
    temp = temp/max(temp); 
    
    [param1,gof1,~] = fit(Pseudotime,temp','fourier2');
    Dat2(i,:) = param1(Pseudotime);
    ScMat(i,:) = temp; 
end
    
FitMat = Dat2; 