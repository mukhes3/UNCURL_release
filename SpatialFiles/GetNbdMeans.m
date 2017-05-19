function M = GetNbdMeans(Dat,X_loc,Y_loc,x,y,wSize,GridX,GridY)

Xmin = max(0,x - wSize);
Xmax = min(GridX,x + wSize);

Ymin = max(0,y - wSize);
Ymax = min(GridY,y + wSize);

In1 = find(X_loc<=Xmax);
In2 = find(X_loc>=Xmin);

In3 = find(Y_loc<=Ymax);
In4 = find(Y_loc>=Ymin);

In = intersect(In1,In2); 
In = intersect(In,In3);
In = intersect(In,In4);

% In1 = find((X_loc==x).*(Y_loc<=Ymax).*(Y_loc>=Ymin));
% In2 = find((Y_loc==y).*(X_loc<=Xmax).*(X_loc>=Xmin));

% In = intersect(In1,In2); 

M = mean(Dat(:,In)')'; 

end