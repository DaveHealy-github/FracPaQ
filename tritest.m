f = figure ;
set(gcf, 'PaperPositionMode', 'manual') ;
set(gcf, 'PaperUnits', 'inches') ;
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ;
triData = [ 32, 32, 36 ] ; 

hold on ;
triplot() ; 
tripts(triData, '', 0) ; 
hold off ; 