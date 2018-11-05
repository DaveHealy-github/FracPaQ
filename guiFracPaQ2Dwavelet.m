function guiFracPaQ2Dwavelet(traces, xMin, yMin, xMax, yMax, a, L, nTheta, fMorlet, sColour) 
%   guiFracPaQ2Dwavelet.m 
%
%   Fracture pattern quantification in 2D using wavelets 
%
%   Based on: 
%       Ouillon et al., 1995 NPG
%
%   using fully anisotropic Morlet wavelets
%
%   Dave Healy, December 2011 
%   and modified by Roberto Emanuele Rizzo, March 2016, 
%   University of Aberdeen
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

%   find a square region, centred within the trace map 
xRange = xMax - xMin ;
yRange = yMax - yMin ; 

xC = xMin + xRange / 2 ; 
yC = yMin + yRange / 2 ; 

if xRange > yRange
    xRange = yRange ; 
else
    yRange = xRange ; 
end ; 
xMin = xC - xRange / 2 ; 
xMax = xC + xRange / 2 ; 
yMin = yC - yRange / 2 ; 
yMax = yC + yRange / 2 ; 

%   write the current trace map to a binary image file for signal
%   processing 
%   save trace map as 8-bit binary bmp, no border, no title etc 
fig = figure ; 
% fig.Visible = 'off' ; 
output_size = [ (xMax-xMin) (yMax-yMin) ] ; 
resolution = 72 ;  
set(gcf, 'Units', 'inches') ; 
set(gcf, 'Position', [ 0, 0, output_size/resolution ]) ;
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperSize', output_size/resolution) ; 
set(gcf, 'PaperPosition', [ 0, 0, output_size/resolution ]) ; 
nTraces = length(traces) ; 
hold on ; 
for k = 1:nTraces
    plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', '-k') ;
end ;     
hold off ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
axis off tight equal ;
set(gca, 'position', [0 0 1 1], 'units', 'normalized') ; 
print(fig, 'FracPaQ2Dwavelet.tif', '-dbmpmono', ['-r', num2str(resolution)]) ;
% close(fig) ; 

%   read in the image file 
fnImage = 'FracPaQ2Dwavelet.tif' ;
info = imfinfo(fnImage) ; 
disp(' ') ; 
nxImage = info.Width ; 
nyImage = info.Height ; 
disp(strcat('Image width=', num2str(nxImage))) ; 
disp(strcat('Image height=', num2str(nyImage))) ; 

%   read the file data
if nxImage ~= nyImage 
    error('FATAL ERROR: Raw image MUST BE SQUARE, with same number of pixels in X and Y.') ; 
else 
    dataImage = imread(fnImage) ; 
end ;     

%   flip black to white and vice versa - black is high (1), white is low (0) 
dataImageBW = ( ( double(dataImage) - 255 ) .* -1 ) ./ 255 ; 

disp(size(dataImage)); 
disp(size(dataImageBW)) ; 

% % deltatheta = 18 ; 
% % a = [2, 4, 6, 8, 12, 16, 24, 32] ; 
% theta =  0:pi/nTheta:pi  ; 
% thetaDeg = theta * 180 / pi ; 
% % L = [ 1/4, 1/6, 1/8, 1/16, 1/32, 1/64] ;
% 
% na = max(size(a)) ; 
% ntheta = max(size(theta)) ; 
% nL = max(size(L)) ; 
% 
% WCnorm = zeros(nxImage, nyImage, ntheta, nL) ;  
% WCopt = zeros(nxImage, nyImage) ; 
% iPlot = 0 ; 
% 
% %   need a uiwait bar here... 
% hWait = waitbar(0, 'Calculating Wavelet coefficients...', 'Name', 'Wavelet analysis') ;
% 
% for ia = 1:na
%     
%     disp(strcat('a=', num2str(a(ia)))) ; 
% 
%     for itheta = 1:ntheta 
%         
%         for iL = 1:nL
%          
%             if fMorlet  
%                 [ WC, eta ] = morletCWT(dataImageBW, 1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ;
%                 [ WCself, etaself ] = morletCWTself(1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ; 
%                 disp('Morlet wavelet stats:') ;
%                 disp(strcat('Max WC=', num2str(max(max(WC./a(ia)))))) ; 
%                 disp(strcat('Max WC self=', num2str(max(max(WCself))))) ; 
%                 disp(strcat('Max eta=', num2str(max(max(eta))))) ; 
%                 disp(strcat('Max eta self=', num2str(max(max(etaself))))) ; 
%             else
%                 [ WC, eta ] = mexicanhatCWT(dataImageBW, 1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ;
%                 [ WCself, etaself ] = mexicanhatCWTself(1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ; 
% %                 disp('Mexican Hat wavelet stats:') ;
% %                 disp(strcat('Max WC=', num2str(max(max(WC./a(ia)))))) ; 
% %                 disp(strcat('Max WC self=', num2str(max(max(WCself))))) ; 
% %                 disp(strcat('Max eta=', num2str(max(max(eta))))) ; 
% %                 disp(strcat('Max eta self=', num2str(max(max(etaself))))) ; 
%             end ; 
% 
%             limitWC = max( max(max(WC./a(ia))), abs(min(min(WC./a(ia)))) ) ; 
%             limitWCself = max( max(max(WCself)), abs(min(min(WCself))) ) ; 
%   
%             %   normalise WC by max value of WCself
%             WCnorm(:, :, itheta, iL) = abs( ( WC ./ a(ia) ) ./ limitWCself ).*2.5 ; 
%             
%             iPlot = iPlot + 1 ; 
% 
%         end ; 
%         
%     end ;
%                         
%     %   find optimum value of WC at each (x,y) - i.e. highest values among all 
%     %   combinations of theta and L, and save the corresponding values
%     %   of theta and L too
%     [ WCnorm_L, indexWCnorm_L ] = max(WCnorm, [], 4) ; 
%     Lmax = L(indexWCnorm_L) ;  
%     [ WCnorm_theta, indexWCnorm_theta ] = max(WCnorm_L, [], 3) ; 
%     thetamax = theta(indexWCnorm_theta) ; 
%     
%     %   threshold the optimised & normalised WC map 
%     disp(max(max(WCnorm_theta))) ; 
%     wcThreshold = max(max(WCnorm_theta)) * 0.5 ;  
%     indexWCopt = find(WCnorm_theta > wcThreshold) ; 
%     WCopt(indexWCopt) = WCnorm_theta(indexWCopt) ; 
%     thetaopt = thetamax(indexWCopt) ; 
%     thetaopt_4_mean =[ thetaopt; thetaopt+pi ];
%     thetaopt2 = [ thetaopt; thetaopt+pi ] - pi/2 ;
% 
%     %   binary image map    
%     f = figure ; 
%     set(gcf, 'PaperPositionMode', 'manual') ; 
%     set(gcf, 'PaperUnits', 'inches') ; 
%     set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 
% 
%     imshow(dataImageBW, 'InitialMagnification', 'fit') ; 
%     set(gca,'YDir','reverse') ; 
%     axis on equal tight ; 
%     box on ; 
%     caxis([ 0 1 ]) ; 
%     cmocean('gray') ;
%     colorbar('eastoutside') ;         
%     title('Binary image') ; 
%     xlabel('X, pixels') ; 
%     ylabel('Y, pixels') ; 
% 
%     fnPrint = strcat('FracPaQ2Dwavelet_binary_a', num2str(a(ia))) ; 
%     guiPrint(f, fnPrint) ; 
% 
%     %   WC map    
%     f = figure ; 
%     set(gcf, 'PaperPositionMode', 'manual') ; 
%     set(gcf, 'PaperUnits', 'inches') ; 
%     set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 
% 
%     imshow(WCnorm_theta, 'InitialMagnification', 'fit') ; 
%     set(gca,'YDir','reverse') ; 
%     axis on square tight ; 
%     box on ; 
%     caxis([ 0 1 ]) ; 
%     cmocean('thermal') ;
%     colorbar('eastoutside') ;         
%     xlabel('X, pixels') ; 
%     ylabel('Y, pixels') ; 
%     title(strcat('WC Map, a=', num2str(a(ia)))) ; 
%              
%     fnPrint = strcat('FracPaQ2Dwavelet_WCmap_a', num2str(a(ia))) ; 
%     guiPrint(f, fnPrint) ; 
% 
%     %   equal area rose     
%     f = figure ; 
%     set(gcf, 'PaperPositionMode', 'manual') ; 
%     set(gcf, 'PaperUnits', 'inches') ; 
%     set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 
% 
%     thetaopt2_deg=thetaopt2.* 180 / pi;
%     roseEqualArea(thetaopt2_deg, 18, 0, 0, sColour) ;
%     title({['Orientations of WC Theta_{opt}, threshold=', num2str(wcThreshold, '%4.2f')];''}) ; 
%              
%     fnPrint = strcat('FracPaQ2Dwavelet_rose_a', num2str(a(ia))) ; 
%     guiPrint(f, fnPrint) ; 
% 
%     %   WC histo     
%     f = figure ; 
%     set(gcf, 'PaperPositionMode', 'manual') ; 
%     set(gcf, 'PaperUnits', 'inches') ; 
%     set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 
% 
%     [ nwc, binwc ] = hist(reshape(WCnorm_theta, nxImage*nyImage, 1), 20) ; 
%     hold on ; 
%     bar(binwc, nwc, 1, 'FaceColor', sColour) ;
%     plot([wcThreshold, wcThreshold], [0 max(nwc)], '-r', 'LineWidth', 2) ; 
%     hold off ; 
%     axis on square tight ;
%     box on ; 
%     xlim([ 0 1 ]) ; 
%     ylim([ 0 max(nwc)*1.1]) ; 
%     xlabel('WC_{opt}') ; 
%     ylabel('Frequency') ; 
%     title(strcat('WC Histogram_{opt}, a=', num2str(a(ia)))) ; 
% 
%     fnPrint = strcat('FracPaQ2Dwavelet_WChisto_a', num2str(a(ia))) ; 
%     guiPrint(f, fnPrint) ; 
% 
%     %   write the trace angles to text file for stat. analysis
%     fnMean = strcat('Thetas4Mean_morlet', num2str(a(ia)), '.txt') ;
%     fidMean = fopen(fnMean, 'wt') ; 
%     for i = 1:max(size(thetaopt_4_mean)) 
%         fprintf(fidMean, '%g\n', thetaopt_4_mean(i)) ; 
%     end ; 
%     fclose(fidMean) ; 
%     
% end ; 
% 
% close(hWait) ;

end 