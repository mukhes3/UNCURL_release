%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%converts qualitative means to quantitative means 
%
% Inputs : 
% Dat - Data matrix 
% M - some kind of mean matrix (having the same dimension) 
%
% Outputs : 
% QualMeans - the qualitative mean matrix 
% I_nan - indices which did not result in two clusters 
% M - normalized version of the mean matrix provided 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [QualMeans,I_nan,M] = Qual2Quant(Dat,M)

eps = 1e-10; 

Dat2 = Dat + eps; 
clear Dat 
ReadMax = max(sum(M)); 

%make all coloumns have approximately similar no. of reads 
for i = 1:length(M(1,:)) 
    M(:,i) = M(:,i)*ReadMax/sum(M(:,i)); 
end


%make average counts identical for all columns 
AvCounts = mean(sum(Dat2)); 


%normalize bulk means to expected read count per cell 
M = M*AvCounts/ReadMax; 


%get qualitative means 
Means = zeros(size(M)); 


for i = 1:length(M(:,1))
    [m1,m2] = FindQualMeans(Dat2(i,:)); 
    
    temp = sort([m1,m2]); 
    
    med = (max(M(i,:)) + min(M(i,:)))/2; %middle value of the range 
    I1 = M(i,:)<med; 
    I2 = M(i,:)>=med;
    Means(i,I1) = temp(1); 
    Means(i,I2) = temp(2); 

end

%Identify indices of Nan's
I_nan = []; 
for i = 1:length(M(1,:))
    I_nan = [I_nan; find(isnan(Means(:,i)))];
end

I_nan = unique(I_nan); 

Means(I_nan,:) = zeros(length(I_nan),length(M(1,:)));
QualMeans = Means; 
end

