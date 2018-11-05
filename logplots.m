%   test script to explore different log-log plots 

close all ; 

a = importdata('FracPaQ2Dsegmentlengths.txt') ; 
minLength = min(a) ; 
maxLength = max(a) ; 
nBins = 30 ; 
sColour = 'b' ; 

%   1. basic histogram of lengths - counts not %
f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

[ nSegmentLengths, binSegmentLengths ] = hist(a, ...
                            minLength:(maxLength-minLength)/nBins:maxLength) ; 
yyaxis left ;                         
bar(binSegmentLengths, nSegmentLengths, 1, 'FaceColor', sColour) ;
hold on ; 
plot([minLength, minLength], [0, max(nSegmentLengths)*1.1], '-r', 'LineWidth', 1) ;  
plot([maxLength, maxLength], [0, max(nSegmentLengths)*1.1], '-r', 'LineWidth', 1) ;  
ylim([0 max(nSegmentLengths)*1.1]) ; 
ylabel('Frequency') ; 
yyaxis right ; 
bar(binSegmentLengths, (nSegmentLengths/sum(nSegmentLengths))*100, 1, 'FaceColor', sColour) ;
hold off ; 
xlim([0 maxLength*1.1]) ; 
ylim([0 max(nSegmentLengths/sum(nSegmentLengths)*100)*1.1]) ; 
xlabel('Length') ; 
ylabel('Frequency, %') ; 
axis on square ; 
box on ; 
grid on ; 
title({['Histogram of lengths, n=', num2str(length(a))];''}) ; 

%  2. log-log - counts v l 
f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

[ nSegmentLengths, binSegmentLengths ] = hist(a, ... 
                             minLength:(maxLength-minLength)/nBins:maxLength) ; 
loglog(binSegmentLengths, nSegmentLengths, 's', ...
    'LineWidth', 1, 'Color', sColour, 'MarkerFaceColor', sColour) ;
slopen = abs(diff(nSegmentLengths) /  ((maxLength-minLength)/nBins)) ; 
hold on ; 
% plot(binSegmentLengths(1:length(slopen)), slopen, '--', 'LineWidth', 1, 'Color', sColour) ; 
plot([minLength, minLength], [0.1, max(nSegmentLengths)*1.1], '-r', 'LineWidth', 1) ;  
plot([maxLength, maxLength], [0.1, max(nSegmentLengths)*1.1], '-r', 'LineWidth', 1) ;  
hold off ; 
set(gca,'XTick', [1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2, 1e3, 1e4]) ; 
xlim([minLength*0.9 maxLength*1.1]) ; 
ylim([0.1 max(nSegmentLengths)*1.1]) ; 
xlabel('Length, L') ; 
ylabel('n(L)') ; 
axis on square ; 
box on ; 
grid on ; 
title({['Density distribution of lengths, n=', num2str(length(a))];''}) ; 

%   3. log-log plot cf cumulative frequency, C(l) in the notation of Bonnet et al., 2001 
f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

[ nSegmentLengths, binSegmentLengths ] = hist(a, minLength:maxLength) ; 
cLengths = cumsum(nSegmentLengths) ; 
loglog((minLength:maxLength), (max(cLengths) - cLengths), 's', ... 
       'LineWidth', 1, 'Color', sColour, 'MarkerFaceColor', sColour) ;
slopeC = abs(diff(max(cLengths)-cLengths)) ; 
hold on ; 
% plot(binSegmentLengths(1:length(slopeC)), slopeC, '--', 'LineWidth', 1, 'Color', sColour) ; 
plot([minLength, minLength], [0.1, max(cLengths)*1.2], '-r', 'LineWidth', 1) ; 
plot([maxLength, maxLength], [0.1, max(cLengths)*1.2], '-r', 'LineWidth', 1) ;
hold off ;        
set(gca,'XTick', [1e-3, 1e-2, 1e-1, 1e0, 1e1, 1e2, 1e3, 1e4]) ; 
xlim([minLength*0.9 maxLength*1.1]) ; 
ylim([0.1 max(cLengths)*1.1]) ; 
xlabel('Length, L') ; 
ylabel('C(L)') ; 
axis on square ; 
box on ; 
grid on ; 
title({['Cumulative distribution of lengths, n=', num2str(length(a))];''}) ; 
