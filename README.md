# UNCURL_release
UNCURL is an unified framework for unsupervised / semi-supervised learning using Single Cell RNA-Seq data. This is the **Matlab** release  (for the Python release visit https://github.com/yjzhang/uncurl_python). More details about UNCURL can be found in the cited paper as well as the project homepage (https://sites.google.com/uw.edu/uncurl-release). 

## Contributors: 
Sumit Mukherjee (PhD Candidate, UW Electrical Engineering),  
Yue Zhang (PhD student, UW Computer Science & Engineering),  
Sreeram Kannan (Assistant Professor, UW Electrical Engineering),    
Georg Seelig (Associate Professor, UW Electrical Engineering / UW Computer Science & Engineering)  

## Functionalities of UNCURL: 
1. Clustering 
2. Transcriptomic state estimation from highly sampled single cell sequenced data
3. Dimensionality reduction 
4. Lineage estimation 
5. Semi-supervision

## References: 
Please cite the following paper in case you use UNCURL for your work:  
S. Mukherjee, Y. Zhang, S. Kannan, G. Seelig, Prior knowledge and sampling model informed learning with single cell RNA-Seq data

## Dependencies: 
To the best of our knowledge, UNCURL only needs a working version of MATLAB with the optimization toolbox installed. If you discover any other dependencies, please report them to mukhes3@uw.edu or yjzhang@cs.washington.edu. 

## Quick tutorial:

### Installation
Please run the file 'Install_uncurl.m', before you start using the functions. This file will add the UNCURL folder and it's sub-folders to your MATLAB search path. This step is required for UNCURL to function properly. A simple way to do this is to type the following into your MATLAB workspace (after you are in UNCURL's folder): 

```
Install_uncurl
```

### Getting high variance genes 
It has been our experience that removing house keeping genes from the dataset helps improve the performance of UNCURL for various tasks. Thus we recommend the user to do so (unless using an already reduced gene list) using the function GetHighVarGenes(). Given a dataset (Dat), no. of bins (NoBins) and fraction of high variance genes to keep from each bin (x), the indices of the high variance genes are found as follows:

```
In = GetHighVarGenes(Dat,NoBins,x); 
```

### Semi-supervision
Suppose you have a matrix of qualitative data (M) whose dimensions are 'genes X cell types' and a SCS data matrix (Dat) whose dimensions are 'genes X cells', the following syntax will convert your qualitative data to quantitative data that is compatible with your SCS dataset. 

```
[QualMeans,I_nan,M] = Qual2Quant(Dat,M); 
```
The function will return the following:       
QualMeans - The qualitative to quantitative converted means  
I_nan - Indices where this didn't work   
M - A column normalized version of the input M   

### Clustering 
Suppose you have a similar data matrix (Dat), some initial centers (InitMeans) you have in mind (enter [] if you don't know any), the number of clusters you expect to see (k), the clustering distribution (Negative Binomial is 'NB', Negative Binomial without the use of mex files is 'NB_slow', Poisson is 'Poiss' and Zero-Inflated Poisson is 'ZIP') and the maximum no. of iterations (IterMax) till which you want clustering to run (this is an optional argument, default value is 5). You can get the predicted clusters by entering the following code:   

```
[Pred,LogLike] = RunClustering(InitMeans, Dat, k, Distribution, IterMax); 
```
The outputs will be the following:  
Pred - Predicted class label for each cell  
LogLike - The Log Likelihood matrix whose dimension is 'cell types X cells'

Note:- If you are using the means estimated during the state estimation step (see below) as your initial guess for means, we **strongly recommend** doing the following before providing the means:

```
[InitMeans] = KmeansPP(InitMeans,Dat,k);
```
This step will simply replace the estimated means with the closest points in the dataset. We have seen that this significantly improves the clustering accuracy. If you want to run the clustering quickly, you can simply do it without providing any initial means. In such a case, UNCURL will use Kmeans++ to general starting points for the clustering algorithm. 

### State estimation
Suppose you have a similar data matrix (Dat), some initial centers (InitMeans) you have in mind (enter [] if you don't know any), the number of clusters you expect to see (k), Distribution (Dist, 'Poiss','NB' and 'ZIP' are the three options but 'ZIP' is still in beta mode), function tolerance (eps, optional argument with a default value of 1e-4) and the maximum no. of iterations (IterMax) till which you want clustering to run (this is an optional argument, default value is 10). You can get the predicted estimate of the true state by entering the following code:

```
[M,W,CostPerIter] = RunStateEstimation(Dat,MeansInit, Dist, k,eps,IterMax); 
```
Where the outputs are the following:  
M - Estimated 'extreme' transcriptomic states (dimension is 'genes X cell types') 
W - The convex mixting values for each cell (dimension is 'cell types X cells')     
CostPerIter - Cost function value after each iteration  

### Dimensionality reduction
Suppose you now have the M and the W matrices from the previous step. You can convert the data to k dimensions (optional variable, default 2) using the following syntax: 

```
RedDim = PoissRedDim(M,W,k); 
```
Where RedDim is the reduced dimension matrix of dimensions 'k X cells'. 

### Lineage estimation 
Suppose you now have the M and the W matrices from the state estimation step. You can infer a smooth lineage for your data using the following syntax: 

```
[RedDim, LinDat, AdjW, Adj, EndNodes] = RunUNCURL_lineage(M,Xconv); 
```
Where the outputs are as follows:       
RedDim - The reduced dimension matrix of dimensions '2 X cells'          
LinDat - Smoothed trajectory having dimension '2 X cells'   
AdjW - Weighted adjacency matrix of dimension 'cells X cells'   
Adj - Unweighted adjacency matrix of dimension 'cells X cells'  
EndNodes - EndNodes of the graph    

This part also generates a plot showing the end nodes on a scatter plot. This lets the user choose which is the starting node. 

### Pseudotime calculation and smoothing genes 
Suppose you now have the weighted adjacency matrix (AdjW) and know the starting node (StartIn), you can use this to calculate the pseudotime of each cell and estimate a smoothed (and normalized) value for each gene's expression as follows: 

```
[Pseudotime, FitMat, ScMat] = SmoothDataUsingLineage(AdjW, StartIn, Dat); 
```
Where the outputs are as follows:       
Pseudotime - Pseudotime values for all cells       
FitMat - Smoothed & scaled values for all genes       
ScMat - Scaled values for all genes (not smoothed)      

**Note:** The data matrix provided here can either be the observed data matrix or the estimated data matrix (= M X W). Our observation has been that using the estimated data matrix leads to smoother gene expression values even before fitting the genes. However, we leave it up to the user to decide what they want to do here.  


### Plotting
UNCURL presently has two plotting functions, namely 'ScatterPlotGivenLabels()' and 'PlotGraphGivenAdj()'. Their syntaxes are explained below: 

Suppose you have a 2-dimensional representation (RedDim), cell type labels (Lab, this can be any numerical labels between 1 and k) and k (no. of unique labels). You can plot the data on reduced dimensions with each label getting a separate color using the function 'ScatterPlotGivenLabels()' as follows: 

```
ScatterPlotGivenLabels(RedDim,Lab,k); 
```
**Note:-** Matlab has an in-built function 'gplotmatrix', which is more dynamic and should be used unless your version does not have that function (https://www.mathworks.com/help/stats/gplotmatrix.html). 

2-dimensional representation (RedDim), cell type labels (Lab, this can be any numerical labels between 1 and k), k (no. of unique labels) and an Adjacency matrix (Adj). You can plot a graph with nodes colored by the labels as follows: 

```
PlotGraphGivenAdj(Adj,Dat,Lab,k)
```

## Datasets 
UNCURL comes with a few toy datasets, namely :

Zeisel_data - Contains a sub-sampled version of the dataset from Zeisel et. al. with the differentially expressed genes (it also contains bulk data for the cell types) 
Islam_data - Contains the dataset from Islam et. al. (with bulk data from the cell types) 
Synthetic_Linear - Contains synthetic data from a linear trajectory (with true M, w matrices and cell type labels) 
Synthetic_Branches - Contains synthetic data from a branched trajectory (with true M, w matrices and branch labels) 

## Frequently Asked Questions
FAQs for UNCURL can be found here: https://sites.google.com/uw.edu/uncurl-release/faq . 

## Reporting issues
Please report issues to either Sumit Mukherjee (mukhes3@uw.edu) or Yue Zhang (yjzhang@cs.washington.edu). 

## Python version: 
UNCURL also has a Python version which can be found here:
https://github.com/yjzhang/uncurl_python
