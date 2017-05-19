% for genes for which qualitative information is available, get
% quantitative means for the high and low genes. 

%input: 
% X - 1-D array of gene counts for 1 gene 

%output: 
% [m1,m2] - two means of the 2-means problem


function [m1,m2] = FindQualMeans(X)

k = 2; 
IterMax = 20; 

Init = KmeansPP([],X,k); %get initial prediction of means using Kmeans++ 

%run 2-means clustering 
LogLike = zeros(k,length(X)); 


for i = 1:k
    LogLike(i,:) = LLfromMeans(X,Init(i)); 
end

PredLabs = AssignLabelsFromLL(LogLike);  

[Pred,LogLike2] = PoissHardEM(PredLabs,X,IterMax,k); 

%get the two means
m1 = median(X(Pred==1)); 
m2 = median(X(Pred==2)); 


end
