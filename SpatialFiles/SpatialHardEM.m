
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%           Spatial poisson Hard EM function 
%
%                               Sumit Mukherjee 
%
%  Input - Initial clusters 
%  Output - predicted clusters, final loglikelihood
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Pred,LogLike,Mfin,Lmeans] = SpatialHardEM(LMmat,Dat,LMno, IterMax, bins)

k = bins; 

[r,c] = size(Dat); 

LogLike = zeros(k,c); 

%get initial clusters 
for j = 1:k
    LogLike(j,:) = LLfromMeans(Dat(1:LMno,:),LMmat(:,j)); 
end

PredLabs = AssignLabelsFromLL(LogLike); 

x_loc = ceil(PredLabs/8); 
y_loc = mod(PredLabs,8); 


M = zeros(r-LMno,k); 

GridX = 8; 
GridY = 8;
wSize = 1; 

for i = 1:GridY
    for j = 1: GridX 
        M(:,(i-1)*8+j) = GetNbdMeans(Dat(LMno+1:end,:),x_loc,y_loc,j,i,wSize,GridX,GridY); 
    end
end



for i = 1:IterMax 

LogLike = zeros(k,c); 
    
Mmod = [LMmat; M]; 

for j = 1:k
    LogLike(j,:) = LLfromMeans(Dat,Mmod(:,j)); 
end    

PredLabs = AssignLabelsFromLL(LogLike); 

x_loc = ceil(PredLabs/8); 
y_loc = mod(PredLabs,8); 


for i = i:GridY
    for j = 1: GridX 
        Pmat = LogLike((i-1)*8+j,:); 
%         Pmat = Pmat/sum(Pmat); 
%          M(:,(i-1)*8+j) = GetNbdMeansWtd(Dat(LMno+1:end,:),x_loc,y_loc,j,i,wSize,GridX,GridY,Pmat);
         
%          if sum(PredLabs==(i-1)*8+j)>=20
%              M(:,(i-1)*8+j) = GetNbdMeans(Dat(LMno+1:end,:),x_loc,y_loc,j,i,0,GridX,GridY);
%          else
%              M(:,(i-1)*8+j) = GetNbdMeans(Dat(LMno+1:end,:),x_loc,y_loc,j,i,wSize,GridX,GridY);
%          end
         M(:,(i-1)*8+j) = GetNbdMeans(Dat(LMno+1:end,:),x_loc,y_loc,j,i,wSize,GridX,GridY);
    end
end



end


Pred = PredLabs; 
Mfin = M; 

temp = zeros(LMno,k); 

for i = 1:GridY
    for j = 1: GridX 
        temp(:,(i-1)*8+j) = GetNbdMeans(Dat(1:LMno,:),x_loc,y_loc,j,i,wSize,GridX,GridY); 
    end
end


% x_loc
% y_loc

Lmeans = temp; 

end
