function [OutMat,OutMatSorted, I] = CollapseCluster2Curve(Dat)

[r,c] = size(Dat); 

%get robust fit parameters
[param1,gof1,~] = fit(Dat(1,:)',Dat(2,:)','fourier3'); %'fourier5'
[param2,gof2,~] = fit(Dat(2,:)',Dat(1,:)','fourier3'); %'fourier5'


% figure()
% plot(param1); 
% 
% figure()
% plot(param2); 

if gof1.rmse <= gof2.rmse
    temp = [Dat(1,:);param1(Dat(1,:))'];
    temp2 = temp; 
    [~,I] = sort(Dat(1,:)); 
    temp2(1,:) = temp(1,I);
    temp2(2,:) = temp(2,I);
    
else
    temp = [param2(Dat(2,:))';Dat(2,:)];
    [~,I] = sort(Dat(2,:)); 
    temp2(1,:) = temp(1,I);
    temp2(2,:) = temp(2,I); 
end

OutMatSorted = temp2;
OutMat = temp; 