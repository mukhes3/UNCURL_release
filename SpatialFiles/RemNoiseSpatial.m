function Dat2 = RemNoiseSpatial(Dat,In)

[r,c] = size(Dat); 

temp2 = Dat; 
for i = 1:length(In) 
    i
    temp = Dat; 
    temp(In(i),:) = []; 
    y = Dat(In(i),:)'; 
    fit = glmnet(temp',y,'poisson');
    pfit=glmnetPredict(fit,temp',.5,'response');
    
    if (norm(pfit-y)/norm(y))<=.1
        temp2(In(i),:) = pfit';
    else
        temp2(In(i),:) = y'; 
    end
    
end

Dat2 = temp2; 
end