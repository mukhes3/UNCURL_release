%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%  This reduces the dimension of the data to k dimensions 
%
%Inputs: 
% M - matrix of extreme cell types 
% W - convex mixing parameters 
% k - Final no. of dimensions (default 2) 
%
%
% Outputs: 
% OutMat - Reduced dimension Data

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function OutMat = PoissRedDim(M,W,varargin)

if length(varargin)>0
    k = varargin{1}; 
else
    k = 2; 
end

M = M + 1e-10*rand(size(M)); %avoids improper scaling in some cases 

PDist = GetPoissDistMetric(M);  

M_red = mdscale(PDist,k,'Criterion','strain')'; %reducing means to k dimensions

OutMat = M_red * W; 