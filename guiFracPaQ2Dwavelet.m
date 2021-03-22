function guiFracPaQ2Dwavelet(traces, a, L, deltaTheta, fMorlet, sColour, flag_revX, flag_revY) 
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

global sTag ; 

%   print the tracemap to a figure file for later use 
fwave = figure ; 
fwave.Visible = 'off' ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 27 27 ]) ; 
nTraces = length(traces) ; 
maxTraceLength = max([traces(:).totalLength]) ; 
hold on ; 
for k = 1:nTraces
    %   NB: arbitrary 45% of max length for getting thicker lines... 
    if traces(k).totalLength >= (0.45 * maxTraceLength) 
        plot([ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 4, 'Color', 'k') ;
    else
        plot([ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 1, 'Color', 'k') ;
    end        
end
hold off ; 
axis equal off ;  
print(fwave, 'FracPaQ2D_wavelet_traces.png', '-dpng', '-r72') ; 
close(fwave) ; 

dataImage = imread('FracPaQ2D_wavelet_traces.png') ; 
dataImage = rgb2gray(dataImage) ; 

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
xmin = 0 ; 
xmax = nxImage ; 
ymin = 0 ; 
ymax = nyImage ; 

% theta = deg2rad(deltaTheta/2):deg2rad(deltaTheta):pi-deg2rad(deltaTheta/2) ; 
theta = 0:deg2rad(deltaTheta):pi-deg2rad(deltaTheta) ; 
thetaDeg = rad2deg(theta) ; 

na = max(size(a)) ; 
ntheta = max(size(theta)) ; 
nL = max(size(L)) ; 

WCnorm = zeros(nxImage, nyImage, ntheta, nL) ;  
WCopt = zeros(nxImage, nyImage) ; 
iPlot = 0 ; 

hWait = waitbar(0, 'Calculating Wavelet coefficients...', 'Name', 'Wavelet analysis') ;

disp(['Started Wavelet analysis at ', datestr(now)]) ; 

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
            %   we shouldn't need the factor of 2.5 when using linear colourspaces
            %   e.g. from cmocean... 
            WCnorm(:, :, itheta, iL) = abs( ( WC ./ a(ia) ) ./ limitWCself ) .* 2.5 ; 
%             WCnorm(:, :, itheta, iL) = abs( ( WC ./ a(ia) ) ./ limitWCself ) ; 
            iPlot = iPlot + 1 ; 
            
        end ; 
        
    end ;

    f = figure ; 

    subplot(2,2,1) ; 
    imshow(dataImageBW, 'InitialMagnification', 33) ; 
    axis on equal tight ; 
    box on ; 
    caxis([ 0 1 ]) ; 
    colormap(bone);
    colorbar('eastoutside') ;         
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
    title({'Binary image';''}) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'normal') ; 
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
    
    %   WC map    
    subplot(2,2,2) ; 
    imshow(WCnorm_theta, 'InitialMagnification', 33) ; 
    set(gca,'YDir','reverse') ; 
    axis on equal tight ; 
    box on ; 
    cmocean('thermal') ; 
    caxis([ 0 1 ]) ; 
    colorbar('eastoutside') ;         
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
    title({strcat('WC map, a=', num2str(a(ia)));''}) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'normal') ; 
    end ; 
    
    thetaopt_deg = round(rad2deg(thetaopt')) ; 
    thetaopt2_deg = [ thetaopt_deg, ( thetaopt_deg + 180.0 ) ] ; 
    thetaopt2_deg = thetaopt2_deg - 90 ; 
    for i = 1:max(size(thetaopt2_deg))
        if thetaopt2_deg(i) < 0 
            thetaopt2_deg(i) = thetaopt2_deg(i) + 360 ; 
        end ; 
    end ; 
    if flag_revX 
        thetaopt2_deg = reverseAxis(thetaopt2_deg) ; 
    end ; 
    if flag_revY 
        thetaopt2_deg = reverseAxis(thetaopt2_deg) ; 
    end ; 
    
    %   equal area rose     
    subplot(2,2,3) ; 
    fMean = false ; 
    roseEqualArea(thetaopt2_deg, deltaTheta, 0, 0, fMean, sColour) ;
    title({['Distribution of \theta_{opt}, WC threshold=', num2str(wcThreshold, '%4.2f')];''}) ; 
             
    %   WC histo     
    subplot(2,2,4) ; 
    [ nwc, binwc ] = hist(reshape(WCnorm_theta, nxImage*nyImage, 1), 20) ; 
    hold on ; 
    bar(binwc, log10(nwc), 1, 'FaceColor', sColour) ;
    plot([wcThreshold, wcThreshold], [0 max(nwc)], '-r', 'LineWidth', 2) ; 
    hold off ; 
    axis on square ;
    box on ; 
    grid on ; 
    ylim([ 0 log10(max(nwc)*1.1)]) ; 
    xlabel('WC_{opt}') ; 
    ylabel('log_{10}(frequency)') ; 
    title({strcat('WC histogram, a=', num2str(a(ia)));''}) ; 

    fnPrint = strcat('FracPaQ2Dwavelet_a', num2str(a(ia))) ; 
    guiPrint(f, fnPrint) ; 

    %   write the trace angles to text file for stat. analysis
    fnMean = strcat('FracPaQ2Dwavelet_theta_a', num2str(a(ia)), sTag, '.txt') ;
    fidMean = fopen(fnMean, 'wt') ; 
    for i = 1:max(size(thetaopt2_deg)) 
        fprintf(fidMean, '%g\n', thetaopt2_deg(i)) ; 
    end ; 
    fclose(fidMean) ; 
    
end ; 

close(hWait) ;
disp(['*** ...finished Wavelet analysis at ', datestr(now)]) ; 

end 