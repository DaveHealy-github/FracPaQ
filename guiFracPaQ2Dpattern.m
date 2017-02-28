function guiFracPaQ2Dpattern(traces, numPixelsPerMetre, xMin, yMin, xMax, yMax, ...
    flag_intensitymap, flag_densitymap, flag_triangle, flag_showcircles, nCircles, flag_reverse)
%   guiFracPaQ2Dpattern.m
%       calculates and plots statistics of trace segment patterns
%
%   David Healy
%   July 2014
%   d.healy@abdn.ac.uk

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

numTraces = length(traces) ;
traceLengths = [ traces.segmentLength ] ;

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
    if xMax - xMin > yMax - yMin
        yNumCircle = nCircles ;
        yDeltaCircle = ( yMax - yMin ) / ( yNumCircle + 1 ) ;
        %   set circle radius, as function of y increments
        rCircle = 0.99 * yDeltaCircle / 2 ;
        xDeltaCircle=(rCircle*2)/0.99;
        xNumCircle=floor((( xMax - xMin ) / xDeltaCircle) - 1);
        
    %% Y dimension is longer than x
    elseif xMax - xMin < yMax - yMin
        xNumCircle = nCircles ;
        xDeltaCircle = ( xMax - xMin ) / ( xNumCircle + 1 ) ;
        %   set circle radius, as function of x increments
        yDeltaCircle=(rCircle*2)/0.99;
        rCircle = 0.99 * min(xDeltaCircle, yDeltaCircle) / 2 ;
        yNumCircle=floor((( yMax - yMin ) / yDeltaCircle) - 1);
        
    %% X and y dimensions are equal
    elseif xMax - xMin == yMax - yMin
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
    if numPixelsPerMetre > 0
        disp(['Circle increment in X: ', num2str(xDeltaCircle, '%8.2E'), ' metres']) ;
        disp(['Circle increment in Y: ', num2str(yDeltaCircle, '%8.2E'), ' metres']) ;
        disp(['Circle radius: ', num2str(rCircle, '%8.2E'), ' metres']) ;
        rCircleMetres = rCircle ;
    else
        disp(['Circle increment in X: ', num2str(xDeltaCircle, '%8.2E'), ' pixels']) ;
        disp(['Circle increment in Y: ', num2str(yDeltaCircle, '%8.2E'), ' pixels']) ;
        disp(['Circle radius: ', num2str(rCircle, '%8.2E'), ' pixels']) ;
        rCircleMetres = rCircle ;
    end ;
    I = zeros(yNumCircle, xNumCircle) ;
    D = zeros(yNumCircle, xNumCircle) ;
    
end ;

if flag_showcircles
    
    f = figure ;
    set(gcf, 'PaperPositionMode', 'manual') ;
    set(gcf, 'PaperUnits', 'inches') ;
    set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ;
    
    %   mapped lines and circle centres
    hold on ;
    for k = 1:numTraces
        plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'Color', 'blue') ;
    end ;
    %   for each circle centre
    for i = 1:xNumCircle
        xCentreCircle = xMin + xDeltaCircle * i ;
        for j = 1:yNumCircle
            yCentreCircle = yMin + yDeltaCircle * j ;
            %   *** need to draw the circles actual size here
            plot( xCentreCircle, yCentreCircle, ...
                'or', 'MarkerEdgeColor', 'r', ...
                'MarkerSize', 12) ;
        end ;
    end ;
    hold off ;
    axis on equal ;
    box on ;
    xlim([xMin xMax]) ;
    ylim([yMin yMax]) ;
    if flag_reverse
        set(gca, 'YDir', 'reverse') ;
    end ;
    if numPixelsPerMetre > 0
        xlabel('X, metres') ;
        ylabel('Y, metres') ;
    else
        xlabel('X, pixels') ;
        ylabel('Y, pixels') ;
    end ;
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
                        Det = traces(k).Segment(s).Point1(1) * traces(k).Segment(s).Point2(2) - ...
                            traces(k).Segment(s).Point2(1) * traces(k).Segment(s).Point1(2) - ...
                            xCentreCircle * ( traces(k).Segment(s).Point2(2) - traces(k).Segment(s).Point1(2) ) + ...
                            yCentreCircle * ( traces(k).Segment(s).Point2(1) - traces(k).Segment(s).Point1(1) ) ;
                        
                        deltaSecant = rCircleMetres^2 * dr^2 - Det^2 ;
                        
                        if deltaSecant > 0
                            n = n + 2 ;
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
    
    [ cY, cX, cI ] = getConnectivity(traces, segmentsxy, xMax, yMax) ;
    disp(' ') ;
    cTot = cY + cX + cI ;
    disp('Connectivity...') ;
    disp(['Y:X:I = ', ...
        num2str(cY/cTot, '%5.2f'), ':', ...
        num2str(cX/cTot, '%5.2f'), ':', ...
        num2str(cI/cTot, '%5.2f')]) ;
    disp(['Total number of connections: ', num2str(cTot, '%4.0f')]) ;
    xX = 0.5 * ( 2 * cX + cI ) / cTot ;
    yX = sqrt(3) * 0.5 * cI / cTot ;
    
    %   CL = 2 line
    CL2x1 = 0.25 ;
    CL2y1 = sqrt(3) / 4 ;
    CL2x2 = 0.5 + 1/3 * cosd(60) ;
    CL2y2 = sind(60) * 2/3 ;
    
    %   CL = 3.57 line
    CL357x1 = 0.12 * cosd(60) ;
    CL357y1 = 0.12 * sind(60) ;
    CL357x2 = 0.5 + 0.472 * cosd(60) ;
    CL357y2 = sind(60) * 0.528 ;
    
    % subplot(2, 2, 2) ;
    % figure('OuterPosition',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]) ;
    f = figure ;
    set(gcf, 'PaperPositionMode', 'manual') ;
    set(gcf, 'PaperUnits', 'inches') ;
    set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ;
    
    hold on ;
    plot([CL2x1, CL2x2], [CL2y1, CL2y2], '-r', 'LineWidth', 1) ;
    plot([CL357x1, CL357x2], [CL357y1, CL357y2], '--r', 'LineWidth', 1) ;
    plot(xX, yX, 'ob', 'MarkerFaceColor', 'b', 'MarkerSize', 15) ;
    plot([0, 1, 0.5, 0], [0, 0, sqrt(3)/2, 0], '-k', 'LineWidth', 2) ;
    hold off ;
    legend('C_L = 2.0', 'C_L = 3.57', 'Location', 'northeast') ;
    axis equal off ;
    xlim([-0.05 1*1.1]) ;
    ylim([0 (sqrt(3)/2)*1.1]) ;
    text(-0.05, 0, 'Y', 'HorizontalAlignment', 'right') ;
    text(1.05, 0, 'X') ;
    text(0.5, (sqrt(3)/2)*1.05, 'I') ;
    title({['Connectivity of trace segments, Y:X:I = ', ...
        num2str(cY/cTot, '%5.2f'), ':', ...
        num2str(cX/cTot, '%5.2f'), ':', ...
        num2str(cI/cTot, '%5.2f')];''}) ;
    
    %   save to file
    guiPrint(f, 'FracPaQ2D_IYXtriangle') ;
    
    %   write a file of counts
    fidConn = fopen('FracPaQ2Dconnectivity.txt', 'wt') ;
    fprintf(fidConn, '%s %i\n', 'I', cI) ;
    fprintf(fidConn, '%s %i\n', 'X', cX) ;
    fprintf(fidConn, '%s %i\n', 'Y', cY) ;
    fclose(fidConn) ;
    
end ;

if flag_intensitymap || flag_densitymap
    
    %   interpolate I and D over reduced X, Y
    [ X1, Y1 ] = meshgrid( ((xMin+xDeltaCircle):xDeltaCircle:xMax-xDeltaCircle), ...
        ((yMin+yDeltaCircle):yDeltaCircle:yMax-yDeltaCircle) ) ;
    Iinterp = TriScatteredInterp(reshape(X1, xNumCircle*yNumCircle, 1), ...
        reshape(Y1, xNumCircle*yNumCircle, 1), ...
        reshape(I, xNumCircle*yNumCircle, 1), ...
        'natural') ;
    Dinterp = TriScatteredInterp(reshape(X1, xNumCircle*yNumCircle, 1), ...
        reshape(Y1, xNumCircle*yNumCircle, 1), ...
        reshape(D, xNumCircle*yNumCircle, 1), ...
        'natural') ;
    
    %   create new, finer, X, Y grid
    [ X2, Y2 ] = meshgrid( ((xMin+xDeltaCircle):xDeltaCircle/10:xMax-xDeltaCircle), ...
        ((xMin+yDeltaCircle):yDeltaCircle/10:yMax-yDeltaCircle) ) ;
    Inew = Iinterp(X2, Y2) ;
    Dnew = Dinterp(X2, Y2) ;
    nContours = 20 ;
    
    if flag_intensitymap
        %   plot trace intensity, I
        f = figure ;
        set(gcf, 'PaperPositionMode', 'manual') ;
        set(gcf, 'PaperUnits', 'inches') ;
        set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ;
        
        colormap(jet) ;
        
        contourf(X2, Y2, Inew, nContours) ;
        axis on equal ;
        box on ;
        xlim([xMin xMax]) ;
        ylim([yMin yMax]) ;
        if flag_reverse
            set(gca, 'YDir', 'reverse') ;
        end ;
        if numPixelsPerMetre > 0
            title({'Estimated Intensity of trace segments (P21), metre^{-1}';''}) ;
            xlabel('X, metres') ;
            ylabel('Y, metres') ;
        else
            title({'Estimated Intensity of trace segments (P21), pixel^{-1}';''}) ;
            xlabel('X, pixels') ;
            ylabel('Y, pixels') ;
        end ;
        colorbar ; % ('location', 'southoutside') ;
        
        %   save to file
        guiPrint(f, 'FracPaQ2D_intensityP21') ;
        
    end ;
    
    if flag_densitymap
        %   plot trace density, D
        f = figure ;
        set(gcf, 'PaperPositionMode', 'manual') ;
        set(gcf, 'PaperUnits', 'inches') ;
        set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ;
        
        colormap(jet) ;
        
        contourf(X2, Y2, Dnew, nContours) ;
        axis on equal ;
        box on ;
        xlim([xMin xMax]) ;
        ylim([yMin yMax]) ;
        if flag_reverse
            set(gca, 'YDir', 'reverse') ;
        end ;
        if numPixelsPerMetre > 0
            title({'Estimated Density of trace segments (P20), metre^{-2}';''}) ;
            xlabel('X, metres') ;
            ylabel('Y, metres') ;
        else
            title({'Estimated Density of trace segments (P20), pixel^{-2}';''}) ;
            xlabel('X, pixels') ;
            ylabel('Y, pixels') ;
        end ;
        colorbar ; % ('location', 'southoutside') ;
        
        %   save to file
        guiPrint(f, 'FracPaQ2D_densityP20') ;
        
    end ;
    
    %   write I, D and MTL fto file
    fidIntensity = fopen('FracPaQ2Dintensity.txt', 'wt') ;
    fidDensity = fopen('FracPaQ2Ddensity.txt', 'wt') ;
    for i = 1:xNumCircle
        
        xCentreCircle = xDeltaCircle * i ;
        
        for j = 1:yNumCircle
            
            yCentreCircle = yDeltaCircle * j ;
            
            fprintf(fidIntensity, '%8.1f %8.1f %14.8f\n', xCentreCircle, yCentreCircle, I(j, i)) ;
            fprintf(fidDensity, '%8.1f %8.1f %14.8f\n', xCentreCircle, yCentreCircle, D(j, i)) ;
            
        end ;
        
    end ;
    fclose(fidIntensity) ;
    fclose(fidDensity) ;
    
end ;

% %   plot trace length versus distance from arbitrary line (e.g. a fault)
% %   use distance of trace centre measured perpendicular to the line
% x1_line = 700 ;
% y1_line = 200 ;
%
% x2_line = 300 ;
% y2_line = 1050 ;
%
% f = figure ;
% set(gcf, 'PaperPositionMode', 'manual') ;
% set(gcf, 'PaperUnits', 'inches') ;
% set(gcf, 'PaperPosition', [ 0.25 0.25 8 15 ]) ;
%
% subplot(3,1,1) ;
% hold on ;
% for k = 1:numTraces
%
%     plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', '-b', 'LineWidth', 1) ;
%     plot( [ x1_line, x2_line ], [ y1_line, y2_line ], '-r', 'LineWidth', 1) ;
%
% end ;
% hold off ;
% axis on equal ;
% box on ;
% xlim([xMin xMax]) ;
% ylim([yMin yMax]) ;
% if numPixelsPerMetre > 0
%     xlabel('X, metres') ;
%     ylabel('Y, metres') ;
% else
%     xlabel('X, pixels') ;
%     ylabel('Y, pixels') ;
% end ;
% title(['Mapped trace segments, n=', num2str(length(traceLengths))]) ;
%
% subplot(3,1,2) ;
% hold on ;
% for i = 1:numTraces
%
%     %   calculate perpendicular distance from trace centre to line
%     traces(i).perpDistance = ( ( x2_line - x1_line ) * ( y1_line - traces(i).midpointY ) ...
%                                     - ( x1_line - traces(i).midpointX ) * ( y2_line - y1_line ) ) ...
%                                 / sqrt( ( x2_line - x1_line )^2 + ( y2_line - y1_line )^2 ) ;
%
%     plot(abs(traces(i).perpDistance), traces(i).totalLength, 'ob') ;
%
% end ;
% hold off ;
% xlabel('Perpendicular distance from line, units');
% ylabel('Trace length, units') ;
% box on ;
% grid on ;
% title('Do fracture sizes vary with distance from a fault?') ;
%
% subplot(3,1,3) ;
% hold on ;
% for i = 1:numTraces
%
%     for j = 1:traces(i).nSegments
%
%         %   calculate perpendicular distance from trace centre to line
%         traces(i).Segment(j).perpDistance = ( ( x2_line - x1_line ) * ( y1_line - traces(i).Segment(j).midpointY ) ...
%                                         - ( x1_line - traces(i).Segment(j).midpointX ) * ( y2_line - y1_line ) ) ...
%                                     / sqrt( ( x2_line - x1_line )^2 + ( y2_line - y1_line )^2 ) ;
%
%         plot(abs(traces(i).Segment(j).perpDistance), traces(i).segmentLength(j), 'ob') ;
%
%     end ;
%
% end ;
% hold off ;
% xlabel('Perpendicular distance from line, units');
% ylabel('Segment length, units') ;
% box on ;
% grid on ;
% title('Do fracture sizes vary with distance from a fault?') ;
%
% %   save to file
% guiPrint(f, 'guiFracPaQ2D_length_v_distance') ;
