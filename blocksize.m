
close all ; 

% BW = imread('blocksize_test.bmp') ; 
BW = imread('FracPaQ2D_blocksize.bmp') ; 
BW1 = imbinarize(BW) ; 

% info = imfinfo('FracPaQ2D_blocksize.bmp') ;
% disp(info) ; 

% BW2 = imcomplement(BW1) ; 
BW3 = bwconncomp(BW1) ; 

s = regionprops(BW3, 'Centroid') ; 
centroids = cat(1,s.Centroid) ; 

figure ; 
% set(gcf, 'PaperPositionMode', 'manual') ; 
% set(gcf, 'PaperUnits', 'inches') ; 
% set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 
imshow(BW1, 'Border', 'loose', 'InitialMagnification', 'fit') ; 
hold on ; 
plot(centroids(:,1), centroids(:,2), 'o', 'MarkerFaceColor', 'r', 'MarkerEdgeColor', 'r') ; 
hold off ; 
axis on equal ;

figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 
s2 = regionprops(BW3, 'Area') ; 
areas = cat(1, s2.Area) ; 
[ nAreas, binAreas ] = hist(areas, min(areas):(max(areas)-min(areas))/1000:max(areas)) ;
cAreas = cumsum(nAreas) ;
loglog((min(areas):(max(areas)-min(areas))/1000:max(areas)), (max(cAreas) - cAreas), 'sb') ;
grid on ;
