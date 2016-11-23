function plotEllipse(ax1, ax2, angleN)

angleX = 90 - angleN ; 

%   calculate the trace of the ellipse in rotated coordinates
theta = 0:0.01:2*pi ; 
for i=1:max(size(theta)) ;  
    ex(i) = ax1/2 * cos(theta(i)) * cosd(angleX) - ax2/2 * sin(theta(i)) * sind(angleX) ; 
    ey(i) = ax1/2 * cos(theta(i)) * sind(angleX) + ax2/2 * sin(theta(i)) * cosd(angleX) ; 
end ; 

hold on ; 
fill(ex, ey, 'b') ; 
plot([-ax1/2*cosd(angleX)*1.2, +ax1/2*cosd(angleX)*1.2], [-ax1/2*sind(angleX)*1.2, +ax1/2*sind(angleX)*1.2], '-k') ; 
plot([-ax2/2*cosd(angleX+90)*1.2, +ax2/2*cosd(angleX+90)*1.2], [-ax2/2*sind(angleX+90)*1.2, +ax2/2*sind(angleX+90)*1.2], '-k') ; 
hold off ; 
axis equal off ; 
 