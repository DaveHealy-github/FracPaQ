function triplot
% triplot plots a triangular diagram
% points on it are plotted by tripts
% written by Gerry Middleton, 1995
%
%   Modified by Dave Healy
%       February 2017

xscale = 2/sqrt(3) ;
x = [0 xscale/2 xscale 0] ;		 % define coordinates of apices
y = [-1 0 -1 -1] ;
plot(x, y, '-k') ;
axis equal off ;

for i = 1:9				% plot dotted lines parallel to sides,
	x1 = i*xscale/20 ;		% at 10 percent intervals
	x2 = (20-i)*xscale/20 ;
	x3 = i*xscale/10 ;
	y1 = -1 + i/10 ;
	y2 = -i/10 ;
	xx = [x1 x2] ;
	yy = [y1 y1] ;
	xx2 = [x1 x3] ;
	yy2 = [y1 -1] ;
	xx3 = [x3 (xscale/2 + x1)] ;
	yy3 = [-1 y2] ;
	plot(xx, yy, 'r:', xx2, yy2, 'r:', xx3, yy3, 'r:', 'LineWidth', 0.25) ;
end

text(-0.05, -1, 'Y') ;
text(1.2, -1, 'X') ;
text(0.575, 0.03, 'I') ; 
