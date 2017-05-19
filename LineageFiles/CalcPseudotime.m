function Pseudotime = CalcPseudotime(AdjMat, StartIn)

G = graph(AdjMat); 
d = distances(G); 

Pseudotime = d(:,StartIn)/max(d(:,StartIn)); 
end