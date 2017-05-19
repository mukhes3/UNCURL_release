% this function calulates the means for each cell type given the labels

% inputs: 
% Lab - matrix of labels, label for each cell 
% Dat - Data matrix 
% k - number of cell type 

% Outputs: 
% MeanMat - Matrix of means for each cell type


function MeanMat = CalcMeans(Lab,Dat,k)
%#codegen
coder.inline('never'); 

[p,~] = size(Dat); 

MeanTemp = zeros(p,k);

%calculating means for each cell type
for i = 1:k 
%     In = find(Lab==i); 
    MeanTemp(:,i) = mean(Dat(:,Lab==i),2); 
end

MeanMat = MeanTemp; 