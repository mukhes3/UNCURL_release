%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   Calculates a 1-nearest neighbor based error
% 
% Inputs: 
% Dmat - Distance matrix (n X n) 
% Lab - True labels ( 1 X n) 1 to k  
% k - no. of cell types 
%
%
% Outputs: 
% ErrVal - Error value (a scalar) 
% s - Probability of neighbor belonging to different class by cell type
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [ErrVal,s] = OneNN_err(Dmat,Lab,k)

s = zeros(k,1); 

for i = 1:k 
    In = find(Lab==i); 
    
    for j = 1:length(In)
        
        temp = Dmat(In(j),:); 
        temp(In(j))=Inf; 
        
        [~,NN] = min(temp); %find index of nearest neighbor 
        
        s(i) = s(i) + sum(Lab(NN)~=i); %check to see if nearest neighbor 
        % belongs to the correct class 
    end
    
    s(i) = s(i)/length(In); 
end

ErrVal = mean(s); %taking average over cell types 

end
        
        
