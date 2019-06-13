function guiFracPaQ2Dwavelet3(a, L, deltaTheta, fMorlet, sColour) 
%   guiFracPaQ2Dwavelet.m 
%
%   Fracture pattern quantification in 2D using wavelets 
%
%   Based on: 
%       Ouillon et al., 1995 NPG
%
%   using Fully Anisotropic Morlet wavelets
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

dataImage = imread('Fractures_H12Z.tif') ; 

%   get the size of the passed image 
szImage = size(dataImage) ; 
nyImage = szImage(1) ;
nxImage = szImage(2) ;
disp(['Image width=', num2str(nxImage)]) ; 
disp(['Image height=', num2str(nyImage)]) ; 

%   flip black to white and vice versa - black is high (1), white is low (0) 
maxBW = max(max(dataImage)) ; 
dataImageBW = ( ( double(dataImage) - double(maxBW) ) .* -1 ) ./ double(maxBW) ; 

%   trace map, inverted 
f = figure ; 

imshow(dataImageBW, 'InitialMagnification', 33) ; 
set(gca,'YDir','reverse') ; 
axis on equal tight ; 
box on ; 
caxis([ 0 1 ]) ; 
colormap(bone);
colorbar('southoutside') ;         
title({'Binary image';''}) ; 
xlabel('X, pixels') ; 
ylabel('Y, pixels') ; 

guiPrint(f, 'FracPaQ2Dwavelet_tracemap') ; 

xmin = 0 ; 
xmax = nxImage ; 
ymin = 0 ; 
ymax = nyImage ; 

nTheta = ( 360 / deltaTheta ) / 2 ; 
theta =  0:pi/nTheta:pi  ; 
thetaDeg = theta * 180 / pi ; 

na = max(size(a)) ; 
ntheta = max(size(theta)) ; 
nL = max(size(L)) ; 

WCnorm = zeros(nxImage, nyImage, ntheta, nL) ;  
WCopt = zeros(nxImage, nyImage) ; 
iPlot = 0 ; 

hWait = waitbar(0, 'Calculating Wavelet coefficients...', 'Name', 'Wavelet analysis') ;

for ia = 1:na
    
    disp(['Processing length scale a = ', num2str(a(ia))]) ; 

    for itheta = 1:ntheta 
        
        for iL = 1:nL
         
            fraction = iPlot / ( na * ntheta * nL ) ; 
            waitbar(fraction, hWait, 'Calculating Wavelet coefficients...') ; 
            
            if fMorlet  
                [ WC, eta ] = morletCWT(dataImageBW, 1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ;
                [ WCself, etaself ] = morletCWTself(1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ; 
            else
                [ WC, eta ] = mexicanhatCWT(dataImageBW, 1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ;
                [ WCself, etaself ] = mexicanhatCWTself(1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ; 
            end ; 

            limitWC = max( max(max(WC./a(ia))), abs(min(min(WC./a(ia)))) ) ; 
            limitWCself = max( max(max(WCself)), abs(min(min(WCself))) ) ; 
  
            %   normalise WC by max value of WCself
            WCnorm(:, :, itheta, iL) = abs( ( WC ./ a(ia) ) ./ limitWCself ).*2.5 ; 
            
            iPlot = iPlot + 1 ; 

        end ; 
        
    end ;
                        
    %   find optimum value of WC at each (x,y) - i.e. highest values among all 
    %   combinations of theta and L, and save the corresponding values
    %   of theta and L too
    [ WCnorm_L, indexWCnorm_L ] = max(WCnorm, [], 4) ; 
    Lmax = L(indexWCnorm_L) ;  
    [ WCnorm_theta, indexWCnorm_theta ] = max(WCnorm_L, [], 3) ; 
    thetamax = theta(indexWCnorm_theta) ; 
    
    %   threshold the optimised & normalised WC map 
    disp(['*** Maximum normalised WC_theta = ', num2str(max(max(WCnorm_theta)))]) ; 
    wcThreshold = max(max(WCnorm_theta)) * 0.5 ;  
    indexWCopt = find(WCnorm_theta > wcThreshold) ; 
    WCopt(indexWCopt) = WCnorm_theta(indexWCopt) ; 
    thetaopt = thetamax(indexWCopt) ; 
    thetaopt_4_mean =[ thetaopt ; thetaopt + pi ] ;
    thetaopt2 = [ thetaopt ; thetaopt + pi ] - pi/2 ;

    %   WC map    
    f = figure ; 

    imshow(WCnorm_theta, 'InitialMagnification', 33, 'Colormap', cmocean('thermal')) ; 
    set(gca,'YDir','reverse') ; 
    axis on equal tight ; 
    box on ; 
    caxis([ 0 1 ]) ; 
    colorbar('southoutside') ;         
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
    title({strcat('WC Map, a=', num2str(a(ia)));''}) ; 
             
    fnPrint = strcat('FracPaQ2Dwavelet_WCmap_a', num2str(a(ia))) ; 
    guiPrint(f, fnPrint) ; 

    %   equal area rose     
    f = figure ; 

    thetaopt2_deg = thetaopt2 .* 180 / pi ;
    for i = 1:max(size(thetaopt2_deg))
        if thetaopt2_deg(i) < 0 
            thetaopt2_deg(i) = thetaopt2_deg(i) + 360 ; 
        end ; 
    end ; 
    fMean = false ; 
    roseEqualArea(thetaopt2_deg, deltaTheta, 0, 0, fMean, sColour) ;
    title({['Orientations of WC Theta_{opt}, threshold=', num2str(wcThreshold, '%4.2f')];''}) ; 
             
    fnPrint = strcat('FracPaQ2Dwavelet_rose_a', num2str(a(ia))) ; 
    guiPrint(f, fnPrint) ; 

    %   WC histo     
    f = figure ; 

    [ nwc, binwc ] = hist(reshape(WCnorm_theta, nxImage*nyImage, 1), 20) ; 
    hold on ; 
    bar(binwc, nwc, 1, 'FaceColor', sColour) ;
    plot([wcThreshold, wcThreshold], [0 max(nwc)], '-r', 'LineWidth', 2) ; 
    hold off ; 
    axis on square ;
    box on ; 
    grid on ; 
    ylim([ 0 max(nwc)*1.1]) ; 
    xlabel('WC_{opt}') ; 
    ylabel('Frequency') ; 
    title({strcat('WC Histogram_{opt}, a=', num2str(a(ia)));''}) ; 

    fnPrint = strcat('FracPaQ2Dwavelet_WChisto_a', num2str(a(ia))) ; 
    guiPrint(f, fnPrint) ; 

    %   write the trace angles to text file for stat. analysis
    fnMean = strcat('Thetas4Mean_morlet', num2str(a(ia)), '.txt') ;
    fidMean = fopen(fnMean, 'wt') ; 
    for i = 1:max(size(thetaopt_4_mean)) 
        fprintf(fidMean, '%g\n', thetaopt_4_mean(i)) ; 
    end ; 
    fclose(fidMean) ; 
    
end ; 

close(hWait) ;

end 