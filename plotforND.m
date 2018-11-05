%   plot for ND paper 
close all ; 
clear all ; 

%   colour - b = blue 
sColour = 'b' ; 
%   bin size in degrees 
nRoseBins = 10 ; 

traceAngles = xlsread('9AXZ - orientations (ascending).xlsx') ; 
% traceAngles = traceAngles' ; 

%   double the trace angle data over 360 degrees 
traceAngles2 = [ round(traceAngles) ; ...
                 round(traceAngles) + 180 ] ;
for i = 1:max(size(traceAngles2))
    if traceAngles2(i) < 0 
        traceAngles2(i) = traceAngles2(i) + 360 ; 
    end ; 
    if traceAngles2(i) > 360 
        traceAngles2(i) = traceAngles2(i) - 360 ; 
    end ; 
end ; 

f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

roseEqualArea(traceAngles2, nRoseBins, 0, 0, false, sColour) ; 
title({['0.5 m, n=', num2str(length(traceAngles2)/2)];''}) ; 

%   save to file 
guiPrint(f, 'roseangleEqArea_9AXZ') ; 
