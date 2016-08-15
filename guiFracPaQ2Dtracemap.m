function guiFracPaQ2Dtracemap(traces, nPixelsPerMetre, xMin, yMin, xMax, yMax, flag_shownodes, flag_reverse) 
%   guiFracPaQ2Dtracemap.m 
%       calculates and plots statistics of line trace segment lengths  
%       
%   David Healy
%   July 2014 
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

f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

nTraces = length(traces) ; 
nSegments = sum([traces(:).nSegments]) ; 
nNodes = sum([traces(:).nNodes]) ; 

hold on ; 

for k = 1:nTraces
    
    plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 1, 'Color', 'blue') ;

   
end ; 

if flag_shownodes 
    
    for k = 1:nTraces
        
        for l = 1:traces(k).nSegments

            %   plot segment end points
            plot(traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point1(2), 'ok', 'MarkerSize', 4) ; 
            plot(traces(k).Segment(l).Point2(1), traces(k).Segment(l).Point2(2), 'ok', 'MarkerSize', 4) ; 

        end ; 

        %   plot trace mid points 
        plot(traces(k).midpointX, traces(k).midpointY, 'or') ;  

    end ; 
    
end ; 

hold off ; 
axis on equal ; 
box on ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
if flag_reverse 
    set(gca, 'YDir', 'reverse') ; 
end ; 
if nPixelsPerMetre > 0 
    xlabel('X, metres') ; 
    ylabel('Y, metres') ; 
else
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
end ; 
title(['Mapped traces (n=', num2str(nTraces), ...
       '), segments (n=', num2str(nSegments), ...
       ') & nodes (n=', num2str(nNodes), ')']) ; 
colormap(hot) ; 

%   save to file 
guiPrint(f, 'FracPaQ2D_tracemap') ; 
