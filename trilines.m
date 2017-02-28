function trilines(X)
% trlines(X) plots lines on a triangular diagram 
% previously plotted by triplot.  
% X is the data matrix with 2 rows and 2 columns consisting of 
% the x, y coordinates of the line end points
%
% Based on tripts by Gerry Middleton, 1995
% Written by Dave Healy, February 2017

plot(X(:,1), X(:,2), '-r', 'LineWidth', 1.5) ; 
