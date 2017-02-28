function roseLinear(roseAngles, delta, azimuth, roseLengths) 
%   linear rose diagram of trace segment angles
%
%   arguments:
%       roseAngles - vector of orientations in degrees 
%       delta - (scalar) bin size for rose plot in degrees
%       azimuth - (scalar) rotation angle for final rose plot e.g. northCorrection,
%       in degrees
%   
%   Dave Healy 
%   February 2017 
%   d.healy@abdn.ac.uk 

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

% %   calculate circular statistics: mean and std dev 
% [ roseMean, roseStddev, roseResultant ] = circStat(roseAngles) ; 
% 
% disp(' ') ; 
% disp('Circular statistics:') ; 
% disp(['Mean:', num2str(roseMean)]) ; 
% disp(['Std dev:', num2str(roseStddev)]) ; 
% disp(['Resultant:', num2str(roseResultant)]) ; 

%   
binAngles = 0:delta:360 ; 
binAngles2 = zeros(1, max(size(binAngles))*2) ; 
numAngles2 = zeros(1, max(size(binAngles))*2) ; 
sumLengths2 = zeros(1, max(size(binAngles))*2) ; 
j = 1 ; 
[ numAngles, ~, indBins ] = histcounts(roseAngles, binAngles) ; 
%numAngles = histc(roseAngles, binAngles) ; 

%   go through the bins... 
for i = 1:max(size(binAngles))-1
    
    binAngles2(j) = binAngles(i) ;
    if (i+1) > max(size(binAngles)) 
        binAngles2(j+1) = binAngles(1) ; 
    else 
        binAngles2(j+1) = binAngles(i+1) ; 
    end ; 
    numAngles2(j:j+1) = numAngles(i) ; 
    if sum(roseLengths) 
        sumLengths2(j:j+1) = sum(roseLengths(indBins==i)) ; 
    end ; 
    j = j + 2 ;  
    
end ; 

if sum(roseLengths) == 0 
    numAnglesPercent = ( numAngles2 ./ length(roseAngles) ) * 100 ;
    [ xRoseArea, yRoseArea ] = pol2cart((pi/2 - binAngles2*pi/180), numAngles2) ; 
else 
%   length weighted - sum lengths in each bin, and divide by total length
%   of all segments 
    numAnglesPercent = ( sumLengths2 ./ sum(roseLengths) ) * 100 ;
    [ xRoseArea, yRoseArea ] = pol2cart((pi/2 - binAngles2*pi/180), sumLengths2) ; 
end ; 

limX = max(xRoseArea) ; 
limY = max(yRoseArea) ;
lim = max(limX, limY) ; 

% disp(lim) ; 
% disp(max(xRoseArea)) ; 
% disp(max(yRoseArea)) ; 
% disp(max(x10Percent)) ; 
% disp(max(y10Percent)) ; 

hold on ; 
fill(xRoseArea, yRoseArea, 'b', 'EdgeColor', 'b') ; 
hold off ; 

axis equal off ;
view(azimuth, 90) ; 
xlim([ -lim lim ]) ; 
ylim([ -lim lim ]) ; 
box off ; 
