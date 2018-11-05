
close all ; 

sColourBlue = '[0.48, 0.41, 0.93]' ; 
sColourGreen = '[0.24, 0.70, 0.44]' ; 
sColourRed = '[0.86, 0.08, 0.24]' ; 

nPix = 100 ; 
flag_shownodes = false ; 
flag_revY = false ; 
flag_revX = false ; 

figure ; 
ax = gca ; 

[ traces_blue, xMinB, yMinB, xMaxB, yMaxB] = guiFracPaQ2Dlist('Souter_Blue.txt', nPix, ax, sColourRed) ; 
[ traces_green, xMinG, yMinG, xMaxG, yMaxG] = guiFracPaQ2Dlist('Souter_Green.txt', nPix, ax, sColourGreen) ; 
[ traces_red, xMinR, yMinR, xMaxR, yMaxR] = guiFracPaQ2Dlist('Souter_Red.txt', nPix, ax, sColourRed) ; 

xMin = min([xMinB, xMinG, xMinR]) ; 
xMax = max([xMaxB, xMaxG, xMaxR]) ; 
yMin = min([yMinB, yMinG, yMinR]) ; 
yMax = max([yMaxB, yMaxG, yMaxR]) ; 

f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 12 12 ]) ; 

hold on ; 
[ nTBlue, nSBlue, nNBlue ] = guiFracPaQ2Dtracemap2(traces_blue, nPix, xMin, yMin, xMax, yMax, flag_shownodes, flag_revY, flag_revX, sColourBlue) ; 
[ nTGreen, nSGreen, nNGreen ] = guiFracPaQ2Dtracemap2(traces_green, nPix, xMin, yMin, xMax, yMax, flag_shownodes, flag_revY, flag_revX, sColourGreen) ; 
[ nTRed, nSRed, nNRed ] = guiFracPaQ2Dtracemap2(traces_red, nPix, xMin, yMin, xMax, yMax, flag_shownodes, flag_revY, flag_revX, sColourRed) ;
hold off ;
axis on equal ; 
box on ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
if nPix > 0 
    xlabel('X, metres') ; 
    ylabel('Y, metres') ; 
else
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
end ; 
title({['Mapped traces (n=', num2str(nTBlue+nTGreen+nTRed), ...
       '), segments (n=', num2str(nSBlue+nSGreen+nSRed), ...
       ') & nodes (n=', num2str(nNBlue+nNGreen+nNRed), ')'];''}) ; 

%   save to file 
guiPrint(f, 'Souter_tracemap') ; 
