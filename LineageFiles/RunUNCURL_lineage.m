%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%     Run this function to perform lineage estimation with UNCURL. This
%     function also displays the leaf nodes of the graph with their
%     indices. The user then gets to choose which of them is the starting
%     node 
%
%Inputs: 
% M - matrix of means 
% Xconv - Matrix of convex weights
% k - no. of clusters 
%
%Outputs: 
% RedDim - Reduced dimension data 
% LinDat - Smoothed trajectories (same dimensions as RedDim) 
% AdjW - Weighted adjacency matrix for all cells 
% Adj - Adjacency matrix for the cells 
% EndNodes - List of leaf nodes of the graph
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


function [RedDim, LinDat, AdjW, Adj, EndNodes] = RunUNCURL_lineage(M,Xconv)

k = length(M(1,:)); 
[~,Lab] = max(Xconv); 

%get 2D representation 
RedDim =  PoissRedDim(M,Xconv,2);  

LinDat = zeros(size(RedDim)); 
Dat3 = zeros(size(RedDim)); 


% [~,Lab] = max(Xconv); 
Adj = zeros(length(Xconv(1,:))); 
AdjW = zeros(length(Xconv(1,:))); 


%for each cell type, collapse cluster to a line and join the points 

for i = 1:k 
    In = find(Lab==i); 
    
    [LinDat(:,In),~,I] = CollapseCluster2Curve(RedDim(:,In));

    for j = 1:length(In)-1
        d = norm(RedDim(:,In(I(j))) - RedDim(:,In(I(j+1)))); 
        Adj(In(I(j)),In(I(j+1))) = 1;
        Adj(In(I(j+1)),In(I(j))) = 1;
        
        AdjW(In(I(j)),In(I(j+1))) = d;
        AdjW(In(I(j+1)),In(I(j))) = d;
    end

end


%for each cell type find closest non-cell type collapsed point and join them 

for i = 1:k 
    In = find(Lab==i); 
    In2 = find(Lab~=i);
    
    Dmat = pdist2(LinDat(:,In)',LinDat(:,In2)'); 
    
    [d,m] = min(Dmat(:)); 
    
    I1 = mod(m-1,length(In)) + 1;
    I2 = floor((m-1)/length(In))+1;

    Adj(In(I1),In2(I2)) = 1;
    Adj(In2(I2),In(I1)) = 1; 
    
    AdjW(In(I1),In2(I2)) = d;
    AdjW(In2(I2),In(I1)) = d; 
    
    
end


% Displaying the connected graph 
h = figure(); 
scatter(LinDat(1,:),LinDat(2,:),'k'); 
hold on; 

%get leaf nodes 
SumDeg = sum((Adj~=0)); 
Ends = find(SumDeg==1); 

%coloring and displaying the leaf nodes 
map = colormap; 
l = length(map(:,1)); 
clr_in = round(linspace(1,l,length(Ends)));
Nam = {'Non-End'}; 
for i = 1:length(Ends)
    scatter(LinDat(1,Ends(i)),LinDat(2,Ends(i)),[],map(clr_in(i),:),'filled');
    Nam = [Nam, strcat('Cell',num2str(Ends(i)))]; 
end

legend(Nam); 
    
EndNodes = Ends; 
end