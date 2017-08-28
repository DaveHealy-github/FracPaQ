function plotEllipse(ax1, ax2, angleN, sColour)
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

angleX = 90 - angleN ; 

%   calculate the trace of the ellipse in rotated coordinates
theta = 0:0.01:2*pi ; 
for i=1:max(size(theta)) ;  
    ex(i) = ax1/2 * cos(theta(i)) * cosd(angleX) - ax2/2 * sin(theta(i)) * sind(angleX) ; 
    ey(i) = ax1/2 * cos(theta(i)) * sind(angleX) + ax2/2 * sin(theta(i)) * cosd(angleX) ; 
end ; 

hold on ; 
h = fill(ex, ey, 'b') ;
set(h, 'FaceColor', sColour) ; 
plot([-ax1/2*cosd(angleX)*1.2, +ax1/2*cosd(angleX)*1.2], [-ax1/2*sind(angleX)*1.2, +ax1/2*sind(angleX)*1.2], '-k') ; 
plot([-ax2/2*cosd(angleX+90)*1.2, +ax2/2*cosd(angleX+90)*1.2], [-ax2/2*sind(angleX+90)*1.2, +ax2/2*sind(angleX+90)*1.2], '-k') ; 
hold off ; 
axis equal off ; 
 
end 