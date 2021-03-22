function guiFracPaQ2Dcracktensor(traces, northCorrection, flag_revY, flag_revX)
%   guiFracPaQ2Dcracktensor.m 
%       calculates and plots statistics of trace segment angles  
%       
%   David Healy
%   November 2016 
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

%   add 90 degrees to segment angles to get POLES for crack tensor 
traceAngles = [ traces.segmentAngle ] + 90 ; 
traceAngles = round(traceAngles - northCorrection) ; 
traceLengths = [ traces.segmentLength ] ; 

[xMin, xMax, yMin, yMax] = getMapLimits(traces) ; 

if flag_revX 
    traceAngles = reverseAxis(traceAngles) ; 
end

if flag_revY 
    traceAngles = reverseAxis(traceAngles) ; 
end 

A = (xMax-xMin) * (yMax-yMin) ; 
disp(A) ; 

%   2D, 2nd rank crack or fabric tensor (Oda)
[F2, F2pol] = getF2tensor(traceLengths, traceAngles, A) ; 

%   2D, 4th rank crack tensor
[F4, F4pol] = getF4tensor(traceLengths, traceAngles, A) ; 

%   2D, 8th rank crack tensor
[F8, F8pol] = getF8tensor(traceLengths, traceAngles, A) ; 

%   2D, 16th rank crack tensor
%[F16, F16pol] = getF16tensor(traceLengths, traceAngles, A) ; 

lw = 1.5 ; 
ninc = 360 ; 
alpha = 0:(2*pi/ninc):2*pi ; 
F0pol = zeros(1,ninc+1) ; 
F0pol(:) = sum(traceLengths.^2) / A ; 

f = figure ; 
polarplot(alpha, F0pol, '-m', 'LineWidth', lw) ; 
hold on ; 
polarplot(alpha, F2pol, '-b', 'LineWidth', lw) ; 
polarplot(alpha, F4pol, '-r', 'LineWidth', lw) ; 
polarplot(alpha, F8pol, '-g', 'LineWidth', lw) ; 
%polarplot(alpha, F16pol, '-c', 'LineWidth', lw) ; 
hold off ; 
ax = gca ; 
ax.ThetaDir = 'clockwise' ; 
ax.ThetaZeroLocation = 'top' ; 
legend('0^{th}', '2^{nd}', '4^{th}', '8^{th}', 'Location', 'southoutside', 'Orientation', 'horizontal') ; 
title({['Crack tensors, n=', num2str(length(traceLengths))];''}) ;

guiPrint(f, 'FracPaQ2D_cracktensor') ; 

end 
