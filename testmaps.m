function testmaps(traces, nPixelsPerMetre, xMin, yMin, xMax, yMax, flag_shownodes, flag_revY, flag_revX, sColour) 
%   testmaps.m 
%       calculates and plots statistics of line trace segment lengths  
%       
%   David Healy
%   June 2017 
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

nTraces = length(traces) ; 
nSegments = sum([traces(:).nSegments]) ; 
nNodes = sum([traces(:).nNodes]) ; 

%   trace length by colour map 
f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

traceLengths = round([ traces.totalLength ]) ; 
traceColours = parula(max(traceLengths)) ; 

hold on ; 
for k = 1:nTraces
    plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'color', traceColours(round(traces(k).totalLength),:) ) ;
end ; 
hold off ;
caxis([0 max(traceLengths)]) ; 
c = colorbar('southoutside') ; 
axis on equal ; 
box on ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
if flag_revX 
    set(gca, 'XDir', 'reverse') ; 
end ; 
if flag_revY 
    set(gca, 'YDir', 'reverse') ; 
end ; 
if nPixelsPerMetre > 0 
    xlabel('X, metres') ; 
    ylabel('Y, metres') ; 
    c.Label.String = 'Trace length, metres' ;  
else
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
    c.Label.String = 'Trace length, pixels' ;  
end ; 
title({['Trace length map, n=', num2str(nTraces)];''}) ; 

%   save to file 
guiPrint(f, 'FracPaQ2D_tracelengthmap') ; 

%   segment length by colour map 
f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

segmentLengths = round([ traces.segmentLength ]) ; 
segmentColours = parula(max(segmentLengths)) ; 

hold on ; 
for k = 1:nTraces
    for l = 1:traces(k).nSegments
        plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
              [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                    'LineWidth', 0.75, 'color', segmentColours(round(traces(k).segmentLength(l)),:) ) ;
    end ; 
end ; 
hold off ;
caxis([0 max(segmentLengths)]) ; 
c = colorbar('southoutside') ; 
axis on equal ; 
box on ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
if flag_revX 
    set(gca, 'XDir', 'reverse') ; 
end ; 
if flag_revY 
    set(gca, 'YDir', 'reverse') ; 
end ; 
if nPixelsPerMetre > 0 
    xlabel('X, metres') ; 
    ylabel('Y, metres') ; 
    c.Label.String = 'Segment length, metres' ;  
else
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
    c.Label.String = 'Segment length, pixels' ;  
end ; 
title({['Segment length map, n=', num2str(nSegments)];''}) ; 

%   save to file 
guiPrint(f, 'FracPaQ2D_segmentlengthmap') ; 

%   segment strike by colour map 
f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

segmentAngles = round([ traces.segmentAngle ]) ; 
segmentColours = hsv(180) ; 

hold on ; 
for k = 1:nTraces
    for l = 1:traces(k).nSegments
        if round(traces(k).segmentAngle(l)) < 1
            iAngle = 180 ; 
        else 
            iAngle = round(traces(k).segmentAngle(l)) ; 
        end ; 
        plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
              [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                    'LineWidth', 1, 'color', segmentColours(iAngle,:) ) ;
    end ; 
end ; 
hold off ;
colormap(hsv) ; 
caxis([0 180]) ; 
c = colorbar('southoutside') ; 
c.Label.String = 'Segment strike, degrees' ;  
axis on equal ; 
box on ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
if flag_revX 
    set(gca, 'XDir', 'reverse') ; 
end ; 
if flag_revY 
    set(gca, 'YDir', 'reverse') ; 
end ; 
if nPixelsPerMetre > 0 
    xlabel('X, metres') ; 
    ylabel('Y, metres') ; 
else
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
end ; 
title({['Segment strike map, n=', num2str(nSegments)];''}) ; 

%   save to file 
guiPrint(f, 'FracPaQ2D_segmentstrikemap') ; 