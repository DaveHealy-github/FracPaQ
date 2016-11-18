function guiFracPaQ2Dangle(traces, northCorrection, xMax, yMax, nHistoBins, nRoseBins, ...
                flag_histoangle, flag_roseangle, flag_reverse)
%   guiFracPaQ2Dangle.m 
%       calculates and plots statistics of trace segment angles  
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

numTraces = length(traces) ; 

traceAngles = [ traces.segmentAngle ]' ; 

traceLengths = [ traces.segmentLength ] ; 
minLength = min(traceLengths) ; 
maxLength = max(traceLengths) ; 
maxPossTraceLength = ceil(sqrt(xMax^2 + yMax^2)) ; 

%   double the trace angle data over 360 degrees 
traceAngles2 = [ round(traceAngles - northCorrection); ...
                 round(traceAngles - northCorrection) + 180 ] ;
for i = 1:max(size(traceAngles2))
    if traceAngles2(i) < 0 
        traceAngles2(i) = traceAngles2(i) + 360 ; 
    end ; 
end ; 
if flag_reverse 
    traceAngles2 = 180 - traceAngles2 ; 
    for i = 1:max(size(traceAngles2))
        if traceAngles2(i) < 0 
            traceAngles2(i) = traceAngles2(i) + 360 ; 
        end ;
    end ; 
end ; 

%   write the trace angles to a text file for EZ-ROSE plotting
sorted_traceAngles = sort(traceAngles - northCorrection) ; 
fidRose = fopen('FracPaQ2DEZROSE.txt', 'wt') ; 
for i = 1:max(size(traceAngles)) 
    fprintf(fidRose, '%6.2f\n', sorted_traceAngles(i)) ; 
end ; 
for i = 1:max(size(traceAngles)) 
    fprintf(fidRose, '%6.2f\n', sorted_traceAngles(i)+180 ) ; 
end ; 
fclose(fidRose) ; 

if flag_roseangle 
    
    f = figure ; 
    set(gcf, 'PaperPositionMode', 'manual') ; 
    set(gcf, 'PaperUnits', 'inches') ; 
    set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

    roseEqualArea(traceAngles2, nRoseBins, 0) ; 
    title({['Trace segment angles (area weighted), n=', num2str(length(traceLengths))];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_roseangle') ; 

end ; 

if flag_histoangle 
    
    %   histogram of trace angles 
    f = figure ; 
    set(gcf, 'PaperPositionMode', 'manual') ; 
    set(gcf, 'PaperUnits', 'inches') ; 
    set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

    [ nAngles, binAngles ] = hist(traceAngles2, 0:360/nHistoBins:360) ; 
    bar(binAngles, (nAngles/sum(nAngles))*100, 1, 'FaceColor', 'b') ; 
    xlim([-10 370]) ; 
    ylim([0 max((nAngles/sum(nAngles))*100)*1.1]) ; 
    xlabel('Trace segment angle, degrees') ; 
    ylabel('Frequency, %') ; 
    set(gca,'XTick', 0:60:360) ; 
    axis on square ; 
    box on ; 
    grid on ; 
    title({['Trace segment angles, n=', num2str(length(traceLengths))];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_histoangle') ; 
    
end ; 
