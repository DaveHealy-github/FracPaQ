%   FracPaQ2Dwave_2_Morlet.m 
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
%   and modified by Dave Healy, January 2018 
%   University of Aberdeen

clear all ; 

disp(' ') ; 
disp(['*** Started FracPaQ2D_Morlet_wavev2.m at ', datestr(now), '...']) ; 
disp(' ') ; 

%   get the image file name 
%fnImage = input('Enter full filename of image in single quotes:') ; 

%fnImage = 'Ouillon.tiff' ; 
%fnImage = 'RightAngle.tiff' ; 
%fnImage = 'Orkney1aBinary.tiff' ;
%fnImage = 'Fracture_Map_WA_thickness.tif' ;
%fnImage = 'H16Z2_Rescaled.tif' ;

fnImage = 'Fractures_H12Z.tif' ;
 
disp(strcat('Image file selected: ', fnImage)) ; 

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

figure ; 
imshow(dataImage, 'InitialMagnification', 'fit') ; 

%   flip black to white and vice versa - black is high (1), white is low (0) 
dataImageBW = ( ( double(dataImage) - 255 ) .* -1 ) ./ 255 ; 

iPlot = 0 ; 
deltatheta = 18 ; 
a = [4,16] ; 
theta =  0:pi/deltatheta:pi  ; 
thetaDeg = theta * 180 / pi ; 
L = 1 ./ a  ;

na = max(size(a)) ; 
ntheta = max(size(theta)) ; 
nL = max(size(L)) ; 
WCnorm = zeros(nxImage, nyImage, ntheta, nL) ;  
WCopt = zeros(nxImage, nyImage) ; 
nC = 8 ; 
scrsz = get(0,'ScreenSize') ;

for ia = 1:na
    
    disp(strcat('a=', num2str(a(ia)))) ; 
      
    for itheta = 1:ntheta 
        
        for iL = 1:nL
         
            [ WC, eta ] = morletCWT(dataImageBW, 1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ;
            [ WCself, etaself ] = morletCWTself(1:nxImage, 1:nyImage, a(ia), theta(itheta), L(iL)) ; 

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
%     disp(max(max(WCnorm_theta))) ; 
    wcThreshold = max(max(WCnorm_theta)) * 0.5 ;  
    indexWCopt = find(WCnorm_theta > wcThreshold) ; 
    WCopt(indexWCopt) = WCnorm_theta(indexWCopt) ; 
    thetaopt = thetamax(indexWCopt) ; 
    thetaopt_4_mean =[ thetaopt; thetaopt+pi ] ;
    thetaopt2 = [ thetaopt; thetaopt + pi ] - pi/2 ;
    
    hwc = figure('Position',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]) ; 
    set(gcf, 'PaperPositionMode', 'manual') ; 
    set(gcf, 'PaperUnits', 'inches') ; 
    set(gcf, 'PaperPosition', [ 0.25 0.25 9 9 ]) ; 

    bAxes = subplot(2,2,1) ; 
    imshow(dataImageBW) ; 
    set(gca,'YDir','reverse') ; 
    axis on equal tight ; 
    box on ; 
    caxis([ 0 1 ]) ; 
    colormap(bAxes, bone);
    colorbar('eastoutside') ;         
    title('Binary image') ; 
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 

    wAxes = subplot(2,2,2) ; 
    imshow(WCnorm_theta) ; 
    set(gca,'YDir','reverse') ; 
    axis on equal tight ; 
    box on ; 
    caxis([ 0 1 ]) ; 
    colormap (wAxes, hot);
    colorbar('eastoutside') ;         
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
    title(strcat('WC Map, a=', num2str(a(ia)))) ; 
             
    subplot(2,2,3) ;
    thetaopt2_deg = thetaopt2 .* 180 / pi ;
    for i = 1:max(size(thetaopt2_deg))
        if thetaopt2_deg(i) < 0 
            thetaopt2_deg(i) = thetaopt2_deg(i) + 360 ; 
        end ; 
    end ; 
%     roseEqualArea_first(thetaopt2_deg, 18, 0, 0) ;
    fMean = true ; 
    sColour = '[ 0 0 1 ]' ; 
    roseEqualArea(thetaopt2_deg, deltatheta, 0, 0, fMean, sColour) ;

%     h = rose(thetaopt2, (deltatheta*2)+1/2) ; 
%     hline = findobj(gca, 'Type', 'line') ; 
%     x = get(h, 'XData') ; 
%     y = get(h, 'YData') ; 
%     p = patch(x, y, 'b') ; 
%     set(gca, 'View', [-90, 90], 'YDir', 'reverse') ; 
    title({['Orientation (equal area) WC Theta_{opt}, threshold=', num2str(wcThreshold, '%4.2f')];''}) ; 
             
    subplot(2,2,4) ;
    [ nwc, binwc ] = hist(reshape(WCnorm_theta, nxImage*nyImage, 1), 20) ; 
    hold on ; 
    bar(binwc, nwc, 1, 'FaceColor',[0    0.4510    0.7412]) ;
    plot([wcThreshold, wcThreshold], [0 max(nwc)], '-r', 'LineWidth', 2) ; 
    hold off ; 
    axis on square tight ;
    box on ; 
    xlim([ 0 1 ]) ; 
    xlabel('WC_{opt}') ; 
    ylabel('Frequency') ; 
    title(strcat('WC Histogram_{opt}, a=', num2str(a(ia)))) ; 

%     %   write the trace angles to text file for EZ-ROSE plotting
%     sortedAngles = sort(thetaopt2 .* 180 / pi) ; 
%     fnRose = strcat('FracPaQ2Dwavev2_Morlet_EZROSE_a', num2str(a(ia)), '.txt') ;
%     fidRose = fopen(fnRose, 'wt') ; 
%     for i = 1:max(size(sortedAngles)) 
%         fprintf(fidRose, '%g\n', sortedAngles(i)) ; 
%     end ; 
%     fclose(fidRose) ; 

   %   write the trace angles to text file for stat. analysis

    fnMean = strcat('Thetas4Mean_morlet', num2str(a(ia)), '.txt') ;
    fidMean = fopen(fnMean, 'wt') ; 
    for i = 1:max(size(thetaopt_4_mean)) 
        fprintf(fidMean, '%g\n', thetaopt_4_mean(i)) ; 
    end ; 
    fclose(fidMean) ; 
    
    fnPrint = strcat('Morlet_WC_Map_H16Z2_', num2str(a(ia))) ; 
    print('-djpeg', '-r300', fnPrint) ; 
    
end ; 

disp(' ') ; 
disp(['*** ...finished FracPaQ2D_Morlet_wavev2.m at ', datestr(now), '.']) ; 
disp(' ') ; 
