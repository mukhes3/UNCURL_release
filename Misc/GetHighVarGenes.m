%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% This function bins genes by means and returns the top x% high variance
% genes from each bin. 
%
% Input: 
% Dat - data matrix 
% NoBins - No. of bins (default 10) 
% X - number between 0 and 1. What fraction of high variance genes to
% consider from each bin (default .1).
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function In = GetHighVarGenes(Dat, varargin)


%getting parameter values 
if length(varargin) == 0 
    NoBins = 10; 
    X = 0.1; 
    
elseif length(varargin) == 1 
    NoBins = varargin{1}; 
    X = 0.1; 
else 
    NoBins = varargin{1}; 
    X = varargin{2}; 
end

M = log(mean(Dat')'); 
% V = log(var(Dat')'); 

BinLims = linspace(log(10/length(M)),max(M),NoBins + 1); 

In = []; 

for i = 1: NoBins
    In_red = find((M>=BinLims(i)).*(M<BinLims(i+1)));
    temp = std(Dat(In_red,:)'); 
    [~,I] = sort(temp,'descend'); 
    
    topX = round(length(In_red)*X); 
    
    In = [In; In_red(I(1:topX))]; 
end

% In = unique(In); 


end    
    
    
