function tripts(X, sLabel, fPlot, sColour)
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
%% Copyright
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

x = X(:,1) ;
y = X(:,2) ;
z = X(:,3) ;

xscale = 2/sqrt(3) ;

yy = -(100-z)/100 ;
x3 = x * xscale / 100 ;
x2 = z / 173.2 ;     %tan 60 is 1.732

xx = xscale - x2 - x3 ;
    
if fPlot == 0 
    
    plot(xx, yy, 'o', 'MarkerFaceColor', sColour, 'MarkerEdgeColor', 'k', 'MarkerSize', 12) ; 

elseif fPlot == 1 
    
    plot(xx, yy, '-', 'Color', sColour, 'LineWidth', 1) ; 

else 
    
    text(xx, yy, sLabel) ; 
    
end ; 

end 