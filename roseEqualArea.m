function roseEqualArea(roseAngles, delta, azimuth) 
%   area weighted rose diagram of trace angles

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

roseAngles = round(roseAngles) ; 

for i = 1:max(size(roseAngles))
    if roseAngles(i) < 0 
        roseAngles(i) = roseAngles(i) + 360 ; 
    end ; 
end ; 

%   initialise 
rinc = 0.0005 ; 
r1Percent = 50 ; 
r5Percent = r1Percent * sqrt(5) ; 
r10Percent = r1Percent * sqrt(10) ; 
r25Percent = r1Percent * sqrt(25) ; 
r50Percent = r1Percent * sqrt(50) ; 
x1Percent = -r1Percent:rinc:r1Percent ;
y1Percent = sqrt(r1Percent^2 - x1Percent.^2) ; 
x5Percent = -r5Percent:rinc:r5Percent ;
y5Percent = sqrt(r5Percent^2 - x5Percent.^2) ; 
x10Percent = -r10Percent:rinc:r10Percent ;
y10Percent = sqrt(r10Percent^2 - x10Percent.^2) ; 
x25Percent = -r25Percent:rinc:r25Percent ;
y25Percent = sqrt(r25Percent^2 - x25Percent.^2) ; 
x50Percent = -r50Percent:rinc:r50Percent ;
y50Percent = sqrt(r50Percent^2 - x50Percent.^2) ; 

%   
binAngles = 0:delta:360 ; 
binAngles2 = zeros(1, max(size(binAngles))*2) ; 
numAngles2 = zeros(1, max(size(binAngles))*2) ; 
j = 1 ; 
numAngles = histc(roseAngles, binAngles) ; 
for i = 1:max(size(binAngles))
    
    binAngles2(j) = binAngles(i) ;
    if (i+1) > max(size(binAngles)) 
        binAngles2(j+1) = binAngles(1) ; 
    else 
        binAngles2(j+1) = binAngles(i+1) ; 
    end ; 
    numAngles2(j:j+1) = numAngles(i) ; 
    j = j + 2 ;  
    
end ; 
numAnglesPercent = ( numAngles2 ./ length(roseAngles) ) * 100 ;
rAnglesPercent = r1Percent .* sqrt(numAnglesPercent) ; 
% disp(' ') ; 
% disp(max(rAnglesPercent)) ; 
% disp(max(numAnglesPercent)) ; 
[ xRoseArea, yRoseArea ] = pol2cart((pi/2 - binAngles2*pi/180), rAnglesPercent) ; 
limX = max(xRoseArea) ; 
limY = max(yRoseArea) ;
lim = max(limX, limY) ; 

roseContours = [ max(x1Percent), max(x5Percent), max(x10Percent), max(x25Percent), max(x50Percent) ] ; 

lim = roseContours(find(roseContours > lim, 1)) ; 

% disp(lim) ; 
% disp(max(xRoseArea)) ; 
% disp(max(yRoseArea)) ; 
% disp(max(x10Percent)) ; 
% disp(max(y10Percent)) ; 

hold on ; 
plot(x1Percent, y1Percent, '-k', x1Percent, -y1Percent, '-k', 'LineWidth', 0.5) ;
plot(x5Percent, y5Percent, '-k', x5Percent, -y5Percent, '-k', 'LineWidth', 0.5) ;
plot(x10Percent, y10Percent, '-k', x10Percent, -y10Percent, '-k', 'LineWidth', 0.5) ;
plot(x25Percent, y25Percent, '-k', x25Percent, -y25Percent, '-k', 'LineWidth', 0.5) ;
plot(x50Percent, y50Percent, '-k', x50Percent, -y50Percent, '-k', 'LineWidth', 0.5) ;
plot([-r50Percent*1.1, r50Percent*1.1], [0, 0], '-k', 'LineWidth', 0.5) ; 
plot([0, 0], [-r50Percent*1.1, r50Percent*1.1], '-k', 'LineWidth', 0.5) ; 
fill(xRoseArea, yRoseArea, 'b', 'EdgeColor', 'b') ; 
hold off ; 

title(['Angles (area weighted), n=', num2str(length(roseAngles)/2)]) ; 
axis equal off ;
view(azimuth, 90) ; 
text(-(r1Percent), 0, '1%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r5Percent), 0, '5%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r10Percent), 0, '10%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r25Percent), 0, '25%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r50Percent), 0, '50%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
xlim([ -lim lim ]) ; 
ylim([ -lim lim ]) ; 
box off ; 
