function [M,Xconv,CostPerIter,R]   = NBConvMixModel(Dat,MeansInit,k,eps,iterMax)

tStart = tic;

options = statset('Display','off','MaxIter',50,'TolBnd',1e-4,'TolFun',1e-4,'TolX',1e-4,'MaxFunEvals',100); 

display('Estimating dispersion for all genes');

R = zeros(length(Dat(:,1)),1); 
for i = 1: length(R)
    temp = nbinfit_custom(round(Dat(i,:)),options);
    R(i) = temp(1); 
end

[N,n] = size(Dat);
x_init = zeros(k,n);



%generate matrix of random poiss conv combinations 
for i = 1:n
    temp = rand(k,1);
    temp = temp/sum(temp);
    x_init(:,i) = temp;
end


M = KmeansPP(MeansInit,Dat,k); 

costRec = []; 

CostPrev = 0; 
for i = 1:iterMax 
    display(strcat('E step no. ',int2str(i))); 
    [Xconv,~] = nbConMix_run(Dat,R,M,x_init);
    display(strcat('M step no. ',int2str(i)));     
    [temp, Cost] = nbConMean_run(full(Dat'),R,full(Xconv'),full(M')); 
    display(strcat('Cost after iteration = ',num2str(Cost)));

    costRec = [costRec,Cost]; 

    M = temp';
    x_init = Xconv; 

    if (abs(Cost-CostPrev)/abs(CostPrev))<eps
        break; 
    end

    CostPrev = Cost; 
end

tElapsed = toc(tStart); 
disp(strcat('Time elapsed = ',num2str(tElapsed),' seconds')); 

Xconv = Xconv*inv(diag(sum(Xconv)));
CostPerIter = costRec; 

end