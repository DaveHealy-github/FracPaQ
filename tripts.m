function tripts(X, sLabel, fPlot)
% tripts(X) plots points on a triangular diagram 
% previously plotted by triplot.  X is the data 
% matrix with N rows and 3 columns consisting of 
% x, y, and z: the input percentages: the x vertex
% is lower left, y is lower right, and z is top
% written by Gerry Middleton, 1995
%
%   Modified by Dave Healy
%       February 2017
%   new argument fPlot = 0 for plotting points (in array X), 
%   fPlot = 1 for plotting lines joining points 

x = X(:,1) ;
y = X(:,2) ;
z = X(:,3) ;

xscale = 2/sqrt(3) ;

yy = -(100-z)/100 ;
x3 = x * xscale / 100 ;
x2 = z / 173.2 ;     %tan 60 is 1.732

xx = xscale - x2 - x3 ;
    
if fPlot == 0 
    
    plot(xx, yy, 'or', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'k', 'MarkerSize', 12) ; 

elseif fPlot == 1 
    
    plot(xx, yy, '-r', 'LineWidth', 1) ; 

else 
    
    text(xx, yy, sLabel) ; 
    
end ; 
