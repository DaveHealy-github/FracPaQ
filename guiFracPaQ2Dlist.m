function [ traces, xMin, yMin, xMax, yMax ] = guiFracPaQ2Dlist(fnList, numPixelsPerMetre, ax, sColour)
%   guiFracPaQ2Dlist.m 
%       returns traces from supplied file of end points  
%       
%   David Healy
%   July 2016
%   d.healy@abdn.ac.uk 

%   process an ASCII text file of end point pairs - x1, y1, x2, y2, ... xn, yn 
%   one fracture trace per line, any number of points per trace 
%   open file and read in end point pairs 
%   traces are divided into segments (a.k.a 'branches')

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

hWait = waitbar(0.5, 'Reading node file...', 'Name', 'Preview') ; 

[ listPoints, result ] = readtext(fnList, '\t', '', '', 'numeric') ; 

nTraces = result.rows ; 
nMaxNodes = ( result.max / 2 ) ; 

xMin = 9e32 ; 
yMin = 9e32 ; 
xMax = 0 ; 
yMax = 0 ; 
for i = 1:nTraces  
    
    k = 1 ; 
    s = 0 ; 
    
    for j = 1:nMaxNodes 
        
        if ~isempty(listPoints(i, k)) && ~isnan(listPoints(i, k))

            if numPixelsPerMetre > 0 
                pointX = listPoints(i, k) / numPixelsPerMetre ; 
                pointY = listPoints(i, k+1) / numPixelsPerMetre ; 
            else 
                pointX = listPoints(i, k) ; 
                pointY = listPoints(i, k+1) ; 
            end ; 
            
            traces(i).Node(j).x = pointX ; 
            traces(i).Node(j).y = pointY ; 
            traces(i).maxCols = k + 1 ; 
            
            %   add colour attribute for multicolour input files 
            traces(i).Colour = sColour ; 
            
            k = k + 2 ; 
            
            if pointX < xMin 
                xMin = pointX ; 
            end ; 
            
            if pointY < yMin 
                yMin = pointY ; 
            end ; 
            if pointX > xMax 
                xMax = pointX ; 
            end ; 
            
            if pointY > yMax 
                yMax = pointY ; 
            end ; 
            
            if j > 1 
                
                %   check for duplicate points, e.g. from mistaken double
                %   click in Adobe or Corel when building .SVG file
                if pointX == traces(i).Node(j-1).x && ...  
                   pointY == traces(i).Node(j-1).y
                   
                   continue ; 
                   
                else 
                    
                    s = s + 1 ; 
                
                    traces(i).Segment(s).Point1 = [ traces(i).Node(j-1).x, traces(i).Node(j-1).y ] ;
                    traces(i).Segment(s).Point2 = [ pointX, pointY ] ;
                    
                end ; 
                
            end ; 
            
        else 
            
            break ; 
            
        end ; 

    end ; 
    
    traces(i).nSegments = s ; 
    traces(i).nNodes = s + 1 ; 
    
end ; 

nSegments = sum([traces(:).nSegments]) ; 
nNodes = sum([traces(:).nNodes]) ; 
close(hWait) ;

% hold on ; 
for k = 1:nTraces
    
    plot(ax, [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'Color', sColour) ;

    node1index = 1 ; 
    
    for l = 1:traces(k).nSegments
    
        node2index = node1index + 1 ; 
        
        point1X = traces(k).Node(node1index).x ; 
        point1Y = traces(k).Node(node1index).y ; 
        point2X = traces(k).Node(node2index).x ; 
        point2Y = traces(k).Node(node2index).y ; 
        
        traces(k).segmentLength(l) = norm([ point1X, point1Y ] - [ point2X, point2Y ]) ; 
        
        tanAngle = ( point2X - point1X ) / ( point2Y - point1Y ) ; 
        Angle = atan(tanAngle) * 180 / pi ; 
        if Angle < 0 
            Angle = Angle + 180 ; 
        end ; 
        traces(k).segmentAngle(l) = Angle ; 

        traces(k).Segment(l).startLength = sum(traces(k).segmentLength(1:l-1)) ;
        traces(k).Segment(l).endLength = sum(traces(k).segmentLength(1:l)) ;
        traces(k).Segment(l).midpointX = point1X + ( point2X - point1X ) / 2 ; 
        traces(k).Segment(l).midpointY = point1Y + ( point2Y - point1Y ) / 2 ; 
        
        %   plot segment end points
%         plot(traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point1(2), 'ok', 'MarkerSize', 4) ; 
%         plot(traces(k).Segment(l).Point2(1), traces(k).Segment(l).Point2(2), 'ok', 'MarkerSize', 4) ; 

        node1index = node1index + 1 ; 
        
    end ; 
    
    %    get straight line 'Euclidean' length of whole trace 
    traces(k).euclideanLength = norm( [ traces(k).Node(1).x, traces(k).Node(1).y ] - ...
                                      [ traces(k).Node(traces(k).maxCols/2).x, traces(k).Node(traces(k).maxCols/2).x ] ) ;
   
    %    get total actual length of whole trace 
    traces(k).totalLength = sum(traces(k).segmentLength) ; 
   
    %   find the mid-point of the trace - the fracture 'barycentre'
    traces(k).midLength = traces(k).totalLength / 2 ; 
    
    for m = 1:traces(k).nSegments 
        
        if traces(k).midLength >= traces(k).Segment(m).startLength && ...
           traces(k).midLength < traces(k).Segment(m).endLength 
       
            midl = traces(k).midLength - traces(k).Segment(m).startLength ; 
            
            %   need to know where Point 2 is in relation to Point1 for
            %   this segment 
            if traces(k).Segment(m).Point1(1) <= traces(k).Segment(m).Point2(1)
                if traces(k).Segment(m).Point1(2) <= traces(k).Segment(m).Point2(2)
%                     disp('Quad NE') ; 
                    theta = traces(k).segmentAngle(m) ; 
                    deltaX = midl * sind(theta) ; 
                    deltaY = midl * cosd(theta) ; 
                    traces(k).midpointX = traces(k).Segment(m).Point1(1) + deltaX ; 
                    traces(k).midpointY = traces(k).Segment(m).Point1(2) + deltaY ; 
                else
%                     disp('Quad SE') ; 
                    theta = 180 - traces(k).segmentAngle(m) ; 
                    deltaX = midl * sind(theta) ; 
                    deltaY = midl * cosd(theta) ; 
                    traces(k).midpointX = traces(k).Segment(m).Point1(1) + deltaX ; 
                    traces(k).midpointY = traces(k).Segment(m).Point1(2) - deltaY ; 
                end ;     
            else 
                if traces(k).Segment(m).Point1(2) >= traces(k).Segment(m).Point2(2)
%                     disp('Quad SW') ; 
                    theta = 90 - traces(k).segmentAngle(m) ;  
                    deltaX = midl * cosd(theta) ; 
                    deltaY = midl * sind(theta) ; 
                    traces(k).midpointX = traces(k).Segment(m).Point1(1) - deltaX ; 
                    traces(k).midpointY = traces(k).Segment(m).Point1(2) - deltaY ; 
                else
%                     disp('Quad NW') ; 
                    theta = traces(k).segmentAngle(m) - 90 ;  
                    deltaX = midl * cosd(theta) ; 
                    deltaY = midl * sind(theta) ; 
                    traces(k).midpointX = traces(k).Segment(m).Point1(1) - deltaX ; 
                    traces(k).midpointY = traces(k).Segment(m).Point1(2) + deltaY ; 
                end ; 
            end ; 

            break ;
            
        end ; 
            
    end ; 
    
end ; 
% hold off ; 
axis on equal ; 
box on ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
if numPixelsPerMetre > 0 
    xlabel('X, metres') ; 
    ylabel('Y, metres') ; 
else
    xlabel('X, pixels') ; 
    ylabel('Y, pixels') ; 
end ;

%   new code to enable wavelet analysis
%   print the tracemap to a hidden figure file for later use 
% hold on ; 
fwave = figure ; 
fwave.Visible = 'off' ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 27 27 ]) ; 
maxTraceLength = max([traces(:).totalLength]) ; 
% disp(maxTraceLength) ; 
hold on ; 
for k = 1:nTraces
    if traces(k).totalLength >= (0.45 * maxTraceLength) 
        plot([ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 4, 'Color', 'k') ;
    else
        plot([ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 1, 'Color', 'k') ;
    end ;         
end ; 
hold off ; 
axis equal off ;  
print(fwave, 'FracPaQ2D_wavelet_traces.png', '-dpng', '-r72') ; 
close(fwave) ; 

end  
