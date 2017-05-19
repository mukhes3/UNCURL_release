function [M,W,CostRec] = PoissConvMixModel_gd(Dat,M,k,eta,IterMax,eps) 

tStart = tic;
[N,n] = size(Dat);
W = zeros(k,n);

M = KmeansPP(MeansInit,Dat,k); 

%generate matrix of random poiss conv combinations 
for i = 1:n
    temp = rand(k,1);
    temp = temp/sum(temp);
    W(:,i) = temp;
end

[~,k] = size(M);
[r,c] = size(Dat); 

CostRec = []; 
count = 1; 

while(count <= IterMax) 

disp(strcat('Count = ',int2str(count)));     
disp('Updating W');     
%Update W 
for i = 1:c
    [~,g] = PoissConv_cost(W(:,i),Dat(:,i),M,r);
    W(:,i) = W(:,i) - eta*g; 
    In = (W(:,i)<=1e-10); 
    W(In,i) = 1e-10; 
end
% W 
% M 
disp('Updating M');     
%Update M 
s = 0;
CostRec(count) = 0; 
for i = 1:r
    [s,g] = PoissConv_cost(M(i,:)',Dat(i,:)',W',c);
    M(i,:) = M(i,:) - eta*g'; 
    In = (M(i,:)<=1e-10); 
    M(i,In) = 1e-10;
%     [c,~] = PoissConv_cost(M(i,:)',Dat(i,:)',W',c);
    CostRec(count) = CostRec(count) + s; 
    
end
% M
% % M
% CostRec
if count>1 
    if (abs(CostRec(count) - CostRec(count-1))/abs(CostRec(count-1)))<=eps 
        break; 
    end
end

count = count + 1; 
end

tElapsed = toc(tStart); 
disp(strcat('Time elapsed = ',num2str(tElapsed),' seconds')); 

W = W*inv(diag(sum(W)));
