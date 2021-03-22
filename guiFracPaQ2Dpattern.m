function guiFracPaQ2Dpattern(traces, numPixelsPerMetre, ...
                             nBlocks, ... 
                             flag_intensitymap, flag_densitymap, ... 
                             flag_triangle, flag_showcircles, ...
                             nCircles, flag_revY, flag_revX, sColour, nPixelsItoY)
%   guiFracPaQ2Dpattern.m
%       calculates and plots statistics of trace segment patterns
%
%   David Healy
%   July 2014
%   d.healy@abdn.ac.uk
%
%   Modified by:
%   Nikolai Andrianov 
%   January 2019 
%
%   Modified by:
%   David Healy 
%   February 2019 
%
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

if numPixelsPerMetre > 0
    sUnits = ' metres' ; 
else 
    sUnits = ' pixels' ; 
end 

[xMin, xMax, yMin, yMax] = getMapLimits(traces) ; 

numTraces = length(traces) ;
traceLengths = [ traces.segmentLength ] ;
mapArea = (xMax - xMin) * (yMax - yMin) ; 

if flag_intensitymap || flag_densitymap || flag_showcircles
    
%       % apply circular scan lines and windows
%       % calculate I, D for a selected set of points
%       %   define circle centres
%         xNumCircle = nCircles ;
%         yNumCircle = nCircles ;
%         xDeltaCircle = ( xMax - xMin ) / ( xNumCircle + 1 ) ;
%         yDeltaCircle = ( yMax - yMin ) / ( yNumCircle + 1 ) ;
%     
%         %   set circle radius, as function of x and y increments
%         rCircle = 0.99 * min(xDeltaCircle, yDeltaCircle) / 2 ;
    
    %% X dimension is longer than y
    if ( xMax - xMin ) > ( yMax - yMin )
        yNumCircle = nCircles ;
        yDeltaCircle = ( yMax - yMin ) / ( yNumCircle + 1 ) ;
        %   set circle radius, as function of y increments
        rCircle = 0.99 * yDeltaCircle / 2 ;
        % Calculate number of circles in x to match the image dimensions
        % based on the radius determined by the number of circles in y
        xDeltaCircle=(rCircle*2)/0.99;
        xNumCircle=floor((( xMax - xMin ) / xDeltaCircle) - 1);
        
    %% Y dimension is longer than x
    elseif ( xMax - xMin ) < ( yMax - yMin )
        xNumCircle = nCircles ;
        xDeltaCircle = ( xMax - xMin ) / ( xNumCircle + 1 ) ;
        %   set circle radius, as function of x increments
        rCircle = 0.99 * xDeltaCircle / 2 ;
        % Calculate number of circles in y to match the image dimensions
        % based on the radius determined by the number of circles in x
        yDeltaCircle=(rCircle*2)/0.99;
        yNumCircle=floor((( yMax - yMin ) / yDeltaCircle) - 1);
        
    %% X and y dimensions are equal
    elseif ( xMax - xMin ) == ( yMax - yMin )
        %   define circle centres
        xNumCircle = nCircles ;
        yNumCircle = nCircles ;
        xDeltaCircle = ( xMax - xMin ) / ( xNumCircle + 1 ) ;
        yDeltaCircle = ( yMax - yMin ) / ( yNumCircle + 1 ) ;
        %   set circle radius, as function of x and y increments
        rCircle = 0.99 * min(xDeltaCircle, yDeltaCircle) / 2 ;
        
    end
    
    disp(' ') ;
    disp('Circular scan windows...') ;
    disp(['Circle increment in X: ', num2str(xDeltaCircle, '%8.2E'), sUnits]) ;
    disp(['Circle increment in Y: ', num2str(yDeltaCircle, '%8.2E'), sUnits]) ;
    disp(['Circle radius: ', num2str(rCircle, '%8.2E'), sUnits]) ;
    rCircleMetres = rCircle ;
    I = zeros(yNumCircle, xNumCircle) ;
    D = zeros(yNumCircle, xNumCircle) ;
    
end ;

if flag_showcircles
    
    f = figure ;
    %   mapped lines and circle centres
    hold on ;
    for k = 1:numTraces
        plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'Color', sColour) ;
    end ;
    %   for each circle centre
    for i = 1:xNumCircle
        xCentreCircle = xMin + xDeltaCircle * i ;
        for j = 1:yNumCircle
            yCentreCircle = yMin + yDeltaCircle * j ;
            %   *** need to draw the circles actual size here
            %   use rectangle() with 'Curvature' at [1 1] 
            pos = [ xCentreCircle - rCircle, yCentreCircle - rCircle, 2*rCircle, 2*rCircle ] ; 
            rectangle('Position', pos, 'Curvature', [1 1], 'LineWidth', 0.25, 'EdgeColor', 'r') ; 
        end ;
    end ;
    hold off ;
    axis on equal ;
    box on ;
    xlim([xMin xMax]) ;
    ylim([yMin yMax]) ;
    if flag_revX
        set(gca, 'XDir', 'reverse') ;
    end ;
    if flag_revY
        set(gca, 'YDir', 'reverse') ;
    end ;
    xlabel(['X,', sUnits]) ;
    ylabel(['Y,', sUnits]) ;
    title({['Mapped trace segments, n=', num2str(length(traceLengths))];''}) ;
    
    %   save to file
    guiPrint(f, 'FracPaQ2D_scancircle') ;
    
end ;


if flag_intensitymap || flag_densitymap
    
    hWait = waitbar(0, 'Calculating scan circle intersections...', 'Name', 'Intensity/Density maps') ;
    nCircle = 0 ;
    
    %   for each circle centre
    for i = 1:xNumCircle
        
        xCentreCircle = xMin + xDeltaCircle * i ;
        
        for j = 1:yNumCircle
            
            nCircle = nCircle + 1 ;
            
            waitbar(nCircle/(xNumCircle*yNumCircle), hWait, 'Calculating scan circle intersections...') ;
            
            yCentreCircle = yMin + yDeltaCircle * j ;
            
            n = 0 ;
            m = 0 ;

            for k = 1:numTraces
                
                for s = 1:traces(k).nSegments
                    
                    bPoint1Inside = false ;
                    bPoint2Inside = false ;
                    
                    %           first end of line
                    rPoint = sqrt( ( traces(k).Segment(s).Point1(1) - xCentreCircle )^2 ...
                        + ( traces(k).Segment(s).Point1(2) - yCentreCircle )^2 ) ;
                    if rPoint < rCircleMetres
                        m = m + 1 ;
                        bPoint1Inside = true ;
                    end ;
                    
                    %           second end of line
                    rPoint = sqrt( ( traces(k).Segment(s).Point2(1) - xCentreCircle )^2 ...
                        + ( traces(k).Segment(s).Point2(2) - yCentreCircle )^2 ) ;
                    if rPoint < rCircleMetres
                        m = m + 1 ;
                        bPoint2Inside = true ;
                    end ;
                    
                    %           find any intersections of line with circle
                    if ( bPoint1Inside && bPoint2Inside )
                        continue ;
                        
                    elseif bPoint1Inside
                        n = n + 1 ;
                        
                    elseif bPoint2Inside
                        n = n + 1 ;
                        
                    else
                        
                        dx = traces(k).Segment(s).Point2(1) - traces(k).Segment(s).Point1(1) ;
                        dy = traces(k).Segment(s).Point2(2) - traces(k).Segment(s).Point1(2) ;
                        dr = sqrt( dx^2 + dy^2 ) ;
%                         Det = traces(k).Segment(s).Point1(1) * traces(k).Segment(s).Point2(2) - ...
%                             traces(k).Segment(s).Point2(1) * traces(k).Segment(s).Point1(2) - ...
%                             xCentreCircle * ( traces(k).Segment(s).Point2(2) - traces(k).Segment(s).Point1(2) ) + ...
%                             yCentreCircle * ( traces(k).Segment(s).Point2(1) - traces(k).Segment(s).Point1(1) ) ;
                         
                        x1new = traces(k).Segment(s).Point1(1) - xCentreCircle ; 
                        x2new = traces(k).Segment(s).Point2(1) - xCentreCircle ;
                        y1new = traces(k).Segment(s).Point1(2) - yCentreCircle ; 
                        y2new = traces(k).Segment(s).Point2(2) - yCentreCircle ; 
                        
                        Det = x1new * y2new - x2new * y1new ;
                        
                        deltaSecant = rCircleMetres^2 * dr^2 - Det^2 ;
                        
                        if deltaSecant > 0
                            
                            %   this test checks to see if the adjusted line end
                            %   points are either side of the circle centre
                            %   (to correct a bug where finite line
                            %   segments far away from circle, but
                            %   aligned to intersect were being reported as
                            %   intersections)
                            if ( ( x1new < 0 && x2new >= 0 ) || ...
                                 ( x1new > 0 && x2new <= 0 ) ) && ...    
                               ( ( y1new < 0 && y2new >= 0 ) || ...
                                 ( y1new > 0 && y2new <= 0 ) )    

                                n = n + 2 ;

                            end ; 
                                
                        end ;
                        
                    end ;
                    
                end ;
                
            end ;
            
            %       calculate I
            I(j, i) = n / ( 4 * rCircleMetres ) ;
            
            %       calculate D
            D(j, i) = m / ( 2 * pi * rCircleMetres^2 ) ;
            
            % %       calculate MTL
            %         if m > 0
            %             MTL(j, i) = 0.5 * pi * rCircleMetres * ( n / m ) ;
            %         else
            %             MTL(j, i) = sqrt(xMax^2 + yMax^2) ;
            %         end ;
            
        end ;
        
    end ;
    
    close(hWait) ;
    
end ;

if flag_triangle
    
    %   connectivity plot
    k = 0 ;
    for i = 1:numTraces
        
        for j = 1:traces(i).nSegments
            
            k = k + 1 ;
            segmentsxy(k, :) = [ traces(i).Segment(j).Point1(1), traces(i).Segment(j).Point1(2), ...
                traces(i).Segment(j).Point2(1), traces(i).Segment(j).Point2(2) ] ;
            
        end ;
        
    end ;
    
    [cY, cX, cI] = getConnectivity(traces, segmentsxy, xMin, yMin, xMax, yMax, ...
                                    nBlocks, flag_revX, flag_revY, ...
                                    numPixelsPerMetre, nPixelsItoY) ;
    cTot = cY + cX + cI ;
    disp('Connectivity...') ;
    disp(['Y:X:I = ', ...
        num2str(cY/cTot, '%5.2f'), ':', ...
        num2str(cX/cTot, '%5.2f'), ':', ...
        num2str(cI/cTot, '%5.2f')]) ;
    disp(['Total number of I-Y-X nodes: ', num2str(cTot, '%4.0f')]) ;
    xX = 0.5 * ( 2 * cX + cI ) / cTot ;
    yX = sqrt(3) * 0.5 * cI / cTot ;
    triData = [ (cY/cTot)*100, (cX/cTot)*100, (cI/cTot)*100 ] ;

    %   equations 5c in Sanderson & Nixon, 2015 
    triLinesCL2 = [ 50, 0, 50 ; 0, 33, 67 ] ; 
    triLinesCL357 = [ (8.3/9.3)*100, 0, (1/9.3)*100 ; 0, (0.8925/1.8925)*100, (1/1.8925)*100 ] ; 
    
    f = figure ;
    hold on ;
    triplot() ; 
    tripts(triData, '', 0, sColour) ; 
    tripts(triLinesCL2, '', 1, sColour) ; 
    tripts(triLinesCL357, '', 1, sColour) ; 
    tripts(triLinesCL2(2,:), '\it C_L\rm = 2', 2, sColour) ; 
    tripts(triLinesCL357(2,:), '\it C_L\rm = 3.57', 2, sColour) ; 
    hold off ;
    
    % Title with fractions of Y, X, I
    title({'Connectivity of traces'; ...
           ['Y:X:I = ', ...
            num2str(cY/cTot, '%5.2f'), ':', ...
            num2str(cX/cTot, '%5.2f'), ':', ...
            num2str(cI/cTot, '%5.2f')];''}) ;
    
    %   save to file
    guiPrint(f, 'FracPaQ2D_IYXtriangle') ;
    
    %   write a file of counts
    fn = ['FracPaQ2Dconnectivity', sTag, '.txt'] ; 
    fidConn = fopen(fn, 'wt') ;
    fprintf(fidConn, '%s %i\n', 'I', cI) ;
    fprintf(fidConn, '%s %i\n', 'X', cX) ;
    fprintf(fidConn, '%s %i\n', 'Y', cY) ;
    fclose(fidConn) ;
    
end ;

if flag_intensitymap || flag_densitymap
    
    if flag_intensitymap
        %   plot trace intensity, I
        f = figure ;
%         contourf(X2, Y2, Inew, nContours) ;
        xv = xMin+xDeltaCircle:xDeltaCircle:xMax-xDeltaCircle ; 
        yv = yMin+yDeltaCircle:yDeltaCircle:yMax-yDeltaCircle ; 
        
        imagesc(xv, yv, I) ; 

        ax = gca ; 
        ax.YDir = 'normal' ;
        axis on equal ;
        box on ;
        xlim([xMin xMax]) ;
        ylim([yMin yMax]) ;
        if flag_revX
            set(gca, 'XDir', 'reverse') ;
        end ;
        if flag_revY
            set(gca, 'YDir', 'reverse') ;
        end ;
        title({'Estimated Intensity of segments (P21)';''}) ;
        xlabel(['X,', sUnits]) ;
        ylabel(['Y,', sUnits]) ;
        c = colorbar('location', 'southoutside') ;
        if numPixelsPerMetre > 0
            c.Label.String = 'Intensity of segments (P21), metre^{-1}' ; 
        else 
            c.Label.String = 'Intensity of segments (P21), pixel^{-1}' ; 
        end 
        cmap = colormap('hot') ; 
        cmap = flipud(cmap) ; 
        colormap(cmap) ; 
        caxis([0 max(max(I))]) ; 

        %   save to file
        guiPrint(f, 'FracPaQ2D_intensityP21') ;
        
        %   print Intensity for whole map area
        disp(' ') ; 
        disp('Intensity for whole map:') ; 
        if numPixelsPerMetre > 0
            disp([num2str(sum(traceLengths)/mapArea), ' metre^-1']) ; 
        else 
            disp([num2str(sum(traceLengths)/mapArea), ' pixel^-1']) ; 
        end ; 
            
    end ;
    
    if flag_densitymap
        %   plot trace density, D
        f = figure ;
%         contourf(X2, Y2, Dnew, nContours) ;
        
        xv = xMin+xDeltaCircle:xDeltaCircle:xMax-xDeltaCircle ; 
        yv = yMin+yDeltaCircle:yDeltaCircle:yMax-yDeltaCircle ; 
        
        imagesc(xv, yv, D) ; 

        ax = gca ; 
        ax.YDir = 'normal' ;

        axis on equal ;
        box on ;
        xlim([xMin xMax]) ;
        ylim([yMin yMax]) ;
        if flag_revX
            set(gca, 'XDir', 'reverse') ;
        end ;
        if flag_revY
            set(gca, 'YDir', 'reverse') ;
        end ;
        title({'Estimated Density of segments (P20)';''}) ;
        xlabel(['X,', sUnits]) ;
        ylabel(['Y,', sUnits]) ;
        c = colorbar('southoutside') ; 
        if numPixelsPerMetre > 0
            c.Label.String = 'Density of segments (P20), metre^{-2}' ; 
        else
            c.Label.String = 'Density of segments (P20), pixel^{-2}' ; 
        end
        cmap = colormap('hot') ; 
        cmap = flipud(cmap) ; 
        colormap(cmap) ; 
        caxis([0 max(max(D))]) ; 
        
        %   save to file
        guiPrint(f, 'FracPaQ2D_densityP20') ;
        
        %   print Density for whole map area
        disp(' ') ; 
        disp('Density for whole map:') ; 
        if numPixelsPerMetre > 0
            disp([num2str(length(traceLengths)/mapArea), ' metre^-2']) ; 
        else 
            disp([num2str(length(traceLengths)/mapArea), ' pixel^-2']) ; 
        end ; 

    end ;
    
    %   write I and D data to file
    fn1 = ['FracPaQ2Dintensity', sTag, '.txt'] ; 
    fn2 = ['FracPaQ2Ddensity', sTag, '.txt'] ; 
    fidIntensity = fopen(fn1, 'wt') ;
    fidDensity = fopen(fn2, 'wt') ;
    for i = 1:xNumCircle
        
        xCentreCircle = xMin + xDeltaCircle * i ;
        
        for j = 1:yNumCircle
            
            yCentreCircle = yMin + yDeltaCircle * j ;
            
            fprintf(fidIntensity, '%8.1f %8.1f %14.8f\n', xCentreCircle, yCentreCircle, I(j, i)) ;
            fprintf(fidDensity, '%8.1f %8.1f %14.8f\n', xCentreCircle, yCentreCircle, D(j, i)) ;
            
        end ;
        
    end ;
    fclose(fidIntensity) ;
    fclose(fidDensity) ;
    
end ;


end 
