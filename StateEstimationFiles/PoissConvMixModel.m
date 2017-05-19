function [M,Xconv,CostPerIter]   = PoissConvMixModel(Dat,MeansInit,k,eps,iterMax)

tStart = tic;

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
    [Xconv,~] = pConMix_run(Dat,M,x_init);
    display(strcat('M step no. ',int2str(i)));     
    [temp, Cost] = pConMean_run(full(Dat'),full(Xconv'),full(M')); 
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