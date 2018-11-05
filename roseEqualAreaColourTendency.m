function roseEqualAreaColourTendency(roseAngles, delta, azimuth, roseLengths, s1, s2, nTheta, fTs) 
%   equal area rose diagram of trace segment angles, colour coded by either
%   slip or dilation tendency 
%
%   arguments:
%       roseAngles - vector of orientations in degrees 
%       delta - (scalar) bin size for rose plot in degrees
%       azimuth - (scalar) rotation angle for final rose plot e.g. northCorrection,
%       in degrees
%       roseLengths - vector segment lengths for weighting 
%       fRosemean - flag to indicate if mean & stddev required 
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

%   initialise 
rinc = 0.0005 ; 

r1Percent = 50 ; 
r5Percent = r1Percent * sqrt(5) ; 
r10Percent = r1Percent * sqrt(10) ; 
r20Percent = r1Percent * sqrt(20) ; 
r30Percent = r1Percent * sqrt(30) ; 
r50Percent = r1Percent * sqrt(50) ; 

x1Percent = -r1Percent:rinc:r1Percent ;
y1Percent = sqrt(r1Percent^2 - x1Percent.^2) ; 
x5Percent = -r5Percent:rinc:r5Percent ;
y5Percent = sqrt(r5Percent^2 - x5Percent.^2) ; 
x10Percent = -r10Percent:rinc:r10Percent ;
y10Percent = sqrt(r10Percent^2 - x10Percent.^2) ; 
x20Percent = -r20Percent:rinc:r20Percent ;
y20Percent = sqrt(r20Percent^2 - x20Percent.^2) ; 
x30Percent = -r30Percent:rinc:r30Percent ;
y30Percent = sqrt(r30Percent^2 - x30Percent.^2) ; 
x50Percent = -r50Percent:rinc:r50Percent ;
y50Percent = sqrt(r50Percent^2 - x50Percent.^2) ; 

%   
binAngles = 0:delta:360 ; 
binAngles2 = zeros(1, max(size(binAngles))*2) ; 
numAngles2 = zeros(1, max(size(binAngles))*2) ; 
sumLengths2 = zeros(1, max(size(binAngles))*2) ; 
colAngles2 = zeros(1, max(size(binAngles))*2) ; 
j = 1 ; 
[ numAngles, ~, indBins ] = histcounts(roseAngles, binAngles) ; 
%numAngles = histc(roseAngles, binAngles) ; 

%   fix 'bug' in histcounts() that rounds into 'wrong' bins at 0, 180 and
%   360
i1 = 1 ; 
inhalf = (360/delta) / 2 ; 
inhalfnext = inhalf + 1 ; 
in = 360/delta ; 

n1 = (numAngles(i1) + numAngles(inhalfnext)) / 2 ; 
n2 = (numAngles(inhalf) + numAngles(in)) / 2 ; 
numAngles(i1) = n1 ; 
numAngles(inhalf) = n2 ;
numAngles(inhalfnext) = n1 ; 
numAngles(in)  = n2 ; 

nAlpha = 1:180 ; 
TsMax = max( ((s1-s2).*sind(nAlpha).*cosd(nAlpha)) ./ (s1.*cosd(nAlpha).^2+s2.*sind(nAlpha).^2) ) ;  

%   go through the bins... 
for i = 1:max(size(binAngles))-1
    
    %   define the two edges of each rose 'petal' 
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

    %   calculate Ts or Td at mid line of each 'petal' 
    nPhi = ( binAngles2(j) + binAngles2(j+1) ) / 2; 
    iAlpha = nPhi + 90 - nTheta ; 
    %   calculate normal and shear stress on a segment in this orientation
    sn = s1 * cosd(iAlpha)^2 + s2 * sind(iAlpha)^2 ; 
    tau = (s1-s2) * sind(iAlpha) * cosd(iAlpha) ; 
    if fTs 
        Ts = abs(tau / sn) ; 
        TsNorm = Ts / TsMax ; 
        iCol = round(TsNorm * ( round((360/delta)/2)+1 )) ; 
        if iCol < 1 
            iCol = 1 ; 
        end ; 
        colAngles2(j:j+1) = iCol ; 
    else
        Td = (s1-sn) / (s1-s2) ; 
        iCol = round(Td * ( round((360/delta)/2)+1 )) ; 
        if iCol < 1 
            iCol = 1 ; 
        end ; 
        colAngles2(j:j+1) = iCol ; 
    end ; 

    %   on to the next rose 'petal' 
    j = j + 2 ;  
    
end ;
colAngles2(end-1:end) = colAngles2(1:2) ; 

if sum(roseLengths) == 0 
    numAnglesPercent = ( numAngles2 ./ length(roseAngles) ) * 100 ;
else 
%   length weighted - sum lengths in each bin, and divide by total length
%   of all segments 
    numAnglesPercent = ( sumLengths2 ./ sum(roseLengths) ) * 100 ;
end ; 

%   this is the equal area bit... 
rAnglesPercent = r1Percent .* sqrt(numAnglesPercent) ; 

[ xRoseArea, yRoseArea ] = pol2cart((pi/2 - binAngles2*pi/180), rAnglesPercent) ; 
limX = max(xRoseArea) ; 
limY = max(yRoseArea) ;
lim = max(limX, limY) ; 

roseContours = [ max(x1Percent), max(x5Percent), max(x10Percent), ...
                 max(x20Percent), max(x30Percent), max(x50Percent) ] ; 

lim = roseContours(find(roseContours > lim, 1)) ;

segmentColours = cmocean('thermal', round((360/delta)/2)+1) ; 
iC = 0 ; 
hold on ; 
for i = 1:2:max(size(xRoseArea))/2-1
    iC = colAngles2(i) ; 
    sColour = segmentColours(iC, :) ; 
    %   clumsy workaround to ?bug in fill() which won't allow FaceColor from a string 
    h = fill([0, xRoseArea(1,i:i+1)], [0, yRoseArea(1,i:i+1)], 'r', 'EdgeColor', sColour) ; 
    set(h, 'FaceColor', sColour) ;
end ; 
iC = 0 ; 
for i = (max(size(xRoseArea))/2):2:max(size(xRoseArea))-1
    iC = colAngles2(i) ; 
    sColour = segmentColours(iC, :) ; 
    %   clumsy workaround to ?bug in fill() which won't allow FaceColor from a string 
    h = fill([0, xRoseArea(1,i:i+1)], [0, yRoseArea(1,i:i+1)], 'r', 'EdgeColor', sColour) ; 
    set(h, 'FaceColor', sColour) ;
end ; 
if max(x1Percent) <= lim
    plot(x1Percent, y1Percent, '-k', x1Percent, -y1Percent, '-k', 'LineWidth', 0.25) ;
end ; 
if max(x5Percent) <= lim
    plot(x5Percent, y5Percent, '-k', x5Percent, -y5Percent, '-k', 'LineWidth', 0.25) ;
end ; 
if max(x10Percent) <= lim
    plot(x10Percent, y10Percent, '-k', x10Percent, -y10Percent, '-k', 'LineWidth', 0.25) ;
end ; 
if max(x20Percent) <= lim
    plot(x20Percent, y20Percent, '-k', x20Percent, -y20Percent, '-k', 'LineWidth', 0.25) ;
end ; 
if max(x30Percent) <= lim
    plot(x30Percent, y30Percent, '-k', x30Percent, -y30Percent, '-k', 'LineWidth', 0.25) ;
end ; 
if max(x50Percent) <= lim
    plot(x50Percent, y50Percent, '-k', x50Percent, -y50Percent, '-k', 'LineWidth', 0.25) ;
end ; 
plot([-r50Percent*1.1, r50Percent*1.1], [0, 0], '-k', 'LineWidth', 0.25) ; 
plot([0, 0], [-r50Percent*1.1, r50Percent*1.1], '-k', 'LineWidth', 0.25) ; 
hold off ; 

axis equal off ;
view(azimuth, 90) ; 
text(-(r1Percent), 0, '1%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r5Percent), 0, '5%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r10Percent), 0, '10%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r20Percent), 0, '20%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r30Percent), 0, '30%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
text(-(r50Percent), 0, '50%', 'Clipping', 'on', ...
    'BackgroundColor', 'w', 'FontSize', 8, 'HorizontalAlignment', 'right') ; 
xlim([ -lim lim ]) ; 
ylim([ -lim lim ]) ; 
box off ; 

colormap(segmentColours) ; 
caxis([0 1]) ; 
c = colorbar('southoutside') ;
if fTs 
    c.Label.String = 'Normalised slip tendency, T_s' ;  
else 
    c.Label.String = 'Dilation tendency, T_d' ;
end ; 

end 