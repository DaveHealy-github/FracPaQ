function guiFracPaQ2Dgraphs(traces, numPixelsPerMetre, ...
                            x, y, sColour, ...
                            nScanCircles, ...  
                            flag_revX, flag_revY, ... 
                            flag_tracelengthgraphalong, ...
                            flag_segmentlengthgraphalong, ...
                            flag_segmentanglegraphalong, ...
                            flag_intensitygraphalong, ...
                            flag_densitygraphalong, ...
                            flag_tracelengthgraphfrom, ...
                            flag_segmentlengthgraphfrom, ...
                            flag_segmentanglegraphfrom)
%   guiFracPaQ2Dgraphs.m
%       plots line graphs 
%
%   David Healy
%   May 2019
%   d.healy@abdn.ac.uk
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

if numPixelsPerMetre > 0
    sUnits = ' metres' ; 
else 
    sUnits = ' pixels' ; 
end 

[xMin, xMax, yMin, yMax] = getMapLimits(traces) ; 

x1 = x(1) ; 
x2 = x(2) ; 
y1 = y(1) ; 
y2 = y(2) ; 
% disp([x1, y1]) ; 
% disp([x2, y2]) ; 

numTraces = length(traces) ;
traceLengths = [ traces.segmentLength ] ;

if flag_tracelengthgraphalong || flag_segmentlengthgraphalong || flag_segmentanglegraphalong
    
    %   find intersections of scan line and traces and segments 
    k = 0 ;
    for i = 1:numTraces
        
        for j = 1:traces(i).nSegments
            
            k = k + 1 ;
            segmentsxy(k, :) = [ traces(i).Segment(j).Point1(1), traces(i).Segment(j).Point1(2), ...
                traces(i).Segment(j).Point2(1), traces(i).Segment(j).Point2(2) ] ;
            
        end ;
        
    end ;
    
    % Keep a reference to the corresponding trace in segments 
    k = 0 ;
    for i = 1:length(traces)
        for j = 1:traces(i).nSegments
            k = k + 1 ;
            segmentTraceLength(k) = traces(i).totalLength ; 
            segmentLength(k) = traces(i).segmentLength(j) ; 
            segmentAngle(k) = traces(i).segmentAngle(j) ; 
        end
    end

    segmentsxy = segmentsxy(~any(isnan(segmentsxy),2),:) ; 
    nInt = 0 ; 
    scanXY = [ x(1), y(1), x(2), y(2) ] ; 

    intScan = lineSegmentIntersect(scanXY, segmentsxy) ; 

    for i = 1:size(segmentsxy,1) 

        %   check that the scan line is not the same as the matched line 
        if intScan.coincAdjacencyMatrix(1, i) < 1 

            %   is there an intersection? 
            if intScan.intAdjacencyMatrix(1, i) > 0

                nInt = nInt + 1 ; 

                %   get coords of intersection 
                xInt(nInt) = intScan.intMatrixX(1, i) ; 
                yInt(nInt) = intScan.intMatrixY(1, i) ; 
                
                %   get length of intersected trace
                lTrace(nInt) = segmentTraceLength(i) ; 
                
                %   get length of intersected segment
                lSegment(nInt) = segmentLength(i) ; 
                
                %   get angle of intersected segment
                aSegment(nInt) = segmentAngle(i) ; 

            end ; 

        end ;

    end ; 
    
    dInt = sqrt((x1 - xInt).^2 + (y1 - yInt).^2) ; 

end ; 

% disp(nInt) ; 
% disp(dInt) ; 
% disp(lTrace) ; 
% disp(lSegment) ; 
% disp(aSegment) ; 

if flag_tracelengthgraphalong
    %   plot intersected trace length versus distance along arbitrary line (e.g. a fault)
    f = figure ;
    hold on ;
    for i = 1:max(size(lTrace))
        plot(dInt(i), lTrace(i), 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b') ;
    end ;
    hold off ;
    xlabel(['Distance along line from point 1,', sUnits]);
    ylabel(['Trace length,', sUnits]) ;
    xlim([0 max(dInt)]) ; 
    ylim([0 max(lTrace)]) ; 
    box on ;
    grid on ;
    title('Trace lengths') ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_tracelengthalonggraph') ;
end ; 

if flag_segmentlengthgraphalong
    %   plot intersected segment length versus distance along arbitrary line (e.g. a fault)
    f = figure ;
    hold on ;
    for i = 1:max(size(lSegment))
        plot(dInt(i), lSegment(i), 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b') ;
    end ;
    hold off ;
    xlabel(['Distance along line from point 1,', sUnits]);
    ylabel(['Segment length,', sUnits]) ;
    xlim([0 max(dInt)]) ; 
    ylim([0 max(lSegment)]) ; 
    box on ;
    grid on ;
    title('Segment lengths') ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_segmentlengthalonggraph') ;
end ; 

if flag_segmentanglegraphalong
    %   plot intersected segment angle versus distance along arbitrary line (e.g. a fault)
    f = figure ;
    hold on ;
    for i = 1:max(size(aSegment))
        plot(dInt(i), aSegment(i), 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b') ;
    end ;
    hold off ;
    xlabel(['Distance along line from point 1,', sUnits]);
    ylabel('Segment angle, degrees') ;
    xlim([0 max(dInt)]) ; 
    ylim([0 180]) ; 
    box on ;
    grid on ;
    title('Segment angles') ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_segmentanglealonggraph') ;
end ; 

if flag_intensitygraphalong || flag_densitygraphalong

    %   divide line into N equal intervals, each node = scan circle centre 
%     nScanCircles = 10 ; 
    lScanLine = sqrt((x1-x2)^2 + (y1-y2)^2) ; 
    diamScanCircle = (lScanLine / nScanCircles) ; 
    radScanCircle = diamScanCircle / 2 ; 
    distScanCircles = [ linspace(radScanCircle, lScanLine-radScanCircle, nScanCircles) ] ;  
    theta = atan2d(y2-y1, x2-x1) ; 
    deltaX = cosd(theta) * radScanCircle ; 
    deltaY = sind(theta) * radScanCircle ; 
    xScanCircles = [ linspace(x1+deltaX, x2-deltaX, nScanCircles) ] ; 
    yScanCircles = [ linspace(y1+deltaY, y2-deltaY, nScanCircles) ] ; 

    %   plot the trace map with the selected line overlain 
    f = figure ;
    hold on ;
    for k = 1:numTraces

        plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'Color', sColour) ;

    end ;
    plot( [x1, x2], [y1, y2], '-m', 'LineWidth', 1) ;
    hp1 = plot( x1, y1, '-s', 'LineWidth', 1, 'MarkerEdgeColor', 'c', 'MarkerFaceColor', 'c') ;
    hp2 = plot( x2, y2, '-s', 'LineWidth', 1, 'MarkerEdgeColor', 'g', 'MarkerFaceColor', 'g') ;
    for i = 1:nScanCircles 
        pos = [ xScanCircles(i)-radScanCircle, yScanCircles(i)-radScanCircle, 2*radScanCircle, 2*radScanCircle ] ; 
        rectangle('Position', pos, 'Curvature', [1 1], 'LineWidth', 0.5, 'EdgeColor', 'r') ; 
    end ; 
    hold off ;
    axis on equal ;
    box on ;
    xlim([xMin xMax]) ;
    ylim([yMin yMax]) ;
    legend([hp1, hp2], 'Point 1', 'Point 2', 'Location', 'southoutside', 'Orientation', 'horizontal') ; 
    if flag_revX
        set(gca, 'XDir', 'reverse') ;
    end ;
    if flag_revY
        set(gca, 'YDir', 'reverse') ;
    end ;
    xlabel(['X,', sUnits]) ;
    ylabel(['Y,', sUnits]) ;
    title(['Mapped trace segments, n=', num2str(length(traceLengths))]) ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_graphtracemap') ;

    hWait = waitbar(0, 'Calculating scan circle intersections...', 'Name', 'Intensity/Density along a line') ;
    nCircle = 0 ;
    numTraces = length(traces) ;

    %   for each circle centre
    for i = 1:nScanCircles
        
        nCircle = nCircle + 1 ;
        waitbar(nCircle/(nScanCircles), hWait, 'Calculating scan circle intersections...') ;

        n = 0 ;
        m = 0 ;
        xCentreCircle = xScanCircles(i) ; 
        yCentreCircle = yScanCircles(i) ; 

        for k = 1:numTraces
                
            for s = 1:traces(k).nSegments
                    
                bPoint1Inside = false ;
                bPoint2Inside = false ;

                %           first end of line
                rPoint = sqrt( ( traces(k).Segment(s).Point1(1) - xCentreCircle )^2 ...
                    + ( traces(k).Segment(s).Point1(2) - yCentreCircle )^2 ) ;
                if rPoint < radScanCircle
                    m = m + 1 ;
                    bPoint1Inside = true ;
                end ;

                %           second end of line
                rPoint = sqrt( ( traces(k).Segment(s).Point2(1) - xCentreCircle )^2 ...
                    + ( traces(k).Segment(s).Point2(2) - yCentreCircle )^2 ) ;
                if rPoint < radScanCircle
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

                    deltaSecant = radScanCircle^2 * dr^2 - Det^2 ;

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
        I(i) = n / ( 4 * radScanCircle ) ;

        %       calculate D
        D(i) = m / ( 2 * pi * radScanCircle ) ;

    end ;
    close(hWait) ;

    %   plot graph of I versus distance along line 
    f = figure ;
    hold on ;
    for i = 1:nScanCircles
        plot(distScanCircles(i), I(i), 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b') ;
    end ;
    hold off ;
    xlabel(['Distance along line from point 1,', sUnits]);
    ylabel(['Intensity,' sUnits, '^{-1}']) ;
    xlim([0 max(distScanCircles)]) ; 
    ylim([0 max(I)]) ; 
    box on ;
    grid on ;
    title('Estimated intensity (P21), pixel^{-1}') ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_intensityalonggraph') ;

    %   plot graph of D versus distance along line 
    f = figure ;
    hold on ;
    for i = 1:nScanCircles
        plot(distScanCircles(i), D(i), 'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b') ;
    end ;
    hold off ;
    xlabel(['Distance along line from point 1,', sUnits]);
    ylabel(['Density,', sUnits, '^{-2}']) ;
    xlim([0 max(distScanCircles)]) ; 
    ylim([0 max(D)]) ; 
    box on ;
    grid on ;
    title('Estimated density (P20), pixel^{-2}') ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_densityalonggraph') ;
    
end ; 

if flag_tracelengthgraphfrom
    %   plot trace length versus distance from arbitrary line (e.g. a fault)
    %   use distance of trace centre measured perpendicular to the line
    f = figure ;
    hold on ;
    for i = 1:numTraces

        %   calculate perpendicular distance from trace centre to line
        traces(i).perpDistance = ( ( x2 - x1 ) * ( y1 - traces(i).midpointY ) ...
                                        - ( x1 - traces(i).midpointX ) * ( y2 - y1 ) ) ...
                                    / sqrt( ( x2 - x1 )^2 + ( y2 - y1 )^2 ) ;

%         plot(abs(traces(i).perpDistance), traces(i).totalLength, ...
        plot((traces(i).perpDistance), traces(i).totalLength, ...
                'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b') ;

    end ;
    hold off ;
    xlabel(['Perpendicular distance from line,' sUnits]);
    ylabel(['Trace length,', sUnits]) ;
    box on ;
    grid on ;
    title('Trace lengths') ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_tracelengthfromgraph') ;
end ; 

if flag_segmentlengthgraphfrom
    f = figure ;
    hold on ;
    for i = 1:numTraces

        for j = 1:traces(i).nSegments

            %   calculate perpendicular distance from segment centre to line
            traces(i).Segment(j).perpDistance = ( ( x2 - x1 ) * ( y1 - traces(i).Segment(j).midpointY ) ...
                                            - ( x1 - traces(i).Segment(j).midpointX ) * ( y2 - y1 ) ) ...
                                        / sqrt( ( x2 - x1 )^2 + ( y2 - y1 )^2 ) ;

%             plot(abs(traces(i).Segment(j).perpDistance), traces(i).segmentLength(j), ...
            plot((traces(i).Segment(j).perpDistance), traces(i).segmentLength(j), ...
                    'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b') ;

        end ;

    end ;
    hold off ;
    xlabel(['Perpendicular distance from line,', sUnits]);
    ylabel(['Segment length,', sUnits]) ;
    box on ;
    grid on ;
    title('Segment lengths') ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_segmentlengthfromgraph') ;
end ; 

if flag_segmentanglegraphfrom
    f = figure ;
    hold on ;
    for i = 1:numTraces

        for j = 1:traces(i).nSegments

            %   calculate perpendicular distance from segment centre to line
            traces(i).Segment(j).perpDistance = ( ( x2 - x1 ) * ( y1 - traces(i).Segment(j).midpointY ) ...
                                            - ( x1 - traces(i).Segment(j).midpointX ) * ( y2 - y1 ) ) ...
                                        / sqrt( ( x2 - x1 )^2 + ( y2 - y1 )^2 ) ;

%             plot(abs(traces(i).Segment(j).perpDistance), traces(i).segmentAngle(j), ...
            plot((traces(i).Segment(j).perpDistance), traces(i).segmentAngle(j), ...
                'o', 'MarkerEdgeColor', 'b', 'MarkerFaceColor', 'b') ;

        end ;

    end ;
    hold off ;
    xlabel(['Perpendicular distance from line,', sUnits]) ;
    ylabel('Segment angle, degrees') ;
    ylim([0 180]) ; 
    box on ;
    grid on ;
    title('Segment angles') ;

    %   save to file
    guiPrint(f, 'guiFracPaQ2D_segmentanglefromgraph') ;
end ; 

end 