%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
%               Poisson K means ++ algorithm 
%                                          Sumit Mukherjee 
%
% Inputs - 
% Init - initial starting means 
% Dat - data matrix 
% k - no. of clusters 
%
% Outputs - 
% Means - predicted means using KmeansPP
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%edits added on 10/26/2016 to add a true distance metric

function [Means] = KmeansPP(Init,Dat,k)

[~,ki] = size(Init); 

[r,c] = size(Dat); 


%if Init is empty, initialize with point sampled uniformly at random
if ki==0 
    In = datasample([1:c],1); 
    Init = [Init,Dat(:,In)];
    Dat(:,In) = []; 
    ki = 1; 
elseif ki<=k
    Dat2 = Dat; 
    for i = 1:ki
        m = Inf; 
        In = 0; 
        for j = 1:c
            x = Dat2(:,j);
            y = Init(:,i); 
            temp3 = GetPoissDistMetric([x,y]); 
            temp3 = temp3(2,1);
            
            if temp3<m
                m = temp3; 
                In = j; 
            end
        end
        Init(:,i) = Dat2(:,In);
        Dat2(:,In) = zeros(r,1); 
    end
end
            


for i = ki:k-1 
    %get distance of each point from closest center
    [r,c] = size(Dat);

    temp = zeros(1,c); 
    
    for j = 1:c 
        temp2 = zeros(i,1); 
        for p = 1:i
%             [temp2(p),~] = PoissConv_cost(1,Dat(:,j),Init(:,i),r);
              x = Dat(:,j); 
              y = Init(:,p); 
              temp3 = GetPoissDistMetric([x,y]); 
%               temp2(p) = abs(PoissConv_cost(1,x,x,r) + PoissConv_cost(1,y,y,r) ...
%                   - PoissConv_cost(1,x,y,r) - PoissConv_cost(1,y,x,r));
              temp2(p) = temp3(2,1); 

        end


        temp(j) = min(temp2); 
    end
    
%     temp = temp.^2; 
    
%     if min(temp)<0 
%         temp = temp -min(temp); 
%     end
    
    temp = temp - min(temp); 

    %generate discrete prob dist 
    temp = temp/sum(temp);  
    

    %sample 1 row using gendist and then add it to list of means
    
    In = gendist(temp,1,1); 

    Init = [Init,Dat(:,In)];
    Dat(:,In) = [];
 
end

Means = Init; 

end

