function [ traces, xMin, yMin, xMax, yMax ] = readTraces(fnList)

% sColour = 'b' ; 
sColour = [211/255 211/255 211/255] ; 

[ listPoints, result ] = readtext(fnList, '\t', '', '', 'numeric') ; 

nTraces = result.rows ; 
nMaxNodes = ( result.max / 2 ) ; 

xMin = 9e32 ; 
yMin = 9e32 ; 
xMax = -9e32 ; 
yMax = -9e32 ; 

for i = 1:nTraces  
    
    k = 1 ; 
    s = 0 ; 
    
    for j = 1:nMaxNodes 
        
        if ~isempty(listPoints(i, k)) && ~isnan(listPoints(i, k))

            pointX = listPoints(i, k) ; 
            pointY = listPoints(i, k+1) ; 
            
            traces(i).Node(j).x = pointX ; 
            traces(i).Node(j).y = pointY ; 
            traces(i).maxCols = k + 1 ; 
            
            %   add colour attribute for multicolour input files 
            traces(i).Colour = sColour ; 
            
            k = k + 2 ; 
            
            if pointX < xMin 
                xMin = pointX ; 
            end 
            
            if pointY < yMin 
                yMin = pointY ; 
            end  
            if pointX > xMax 
                xMax = pointX ; 
            end 
            
            if pointY > yMax 
                yMax = pointY ; 
            end 
            
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
                    
                end
                
            end
            
        else 
            
            break ; 
            
        end

    end
    
    traces(i).nSegments = s ; 
    traces(i).nNodes = s + 1 ; 
    
end 

nSegments = sum([traces(:).nSegments]) ; 
nNodes = sum([traces(:).nNodes]) ; 

tracesNew = traces ;
disp(size(traces)) ; 
for j = 1:nTraces
    if traces(j).nSegments == 0 || traces(j).nNodes == 1 
        tracesNew(j) = [] ; 
        nTraces = nTraces - 1 ; 
    end 
end 
clear traces ; 
traces = tracesNew ; 
disp(size(traces)) ; 

figure ; 
hold on ; 
for k = 1:nTraces
    
    plot([ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'Color', sColour) ;

    node1index = 1 ; 
    
    for l = 1:traces(k).nSegments
    
        node2index = node1index + 1 ; 
        
        point1X = traces(k).Node(node1index).x ; 
        point1Y = traces(k).Node(node1index).y ; 
        point2X = traces(k).Node(node2index).x ; 
        point2Y = traces(k).Node(node2index).y ; 
        
        traces(k).segmentLength(l) = norm([ point1X, point1Y ] - [ point2X, point2Y ]) ; 

        if isnan(traces(k).segmentLength(l))
            disp([point1X, point1Y]) ; 
            disp([point2X, point2Y]) ; 
        end 
        
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
        
    end
    
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
                end    
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
                end 
            end

            break ;
            
        end 
            
    end 
    
    %   plot trace mid points 
    plot(traces(k).midpointX, traces(k).midpointY, 'or', 'MarkerSize', 3) ;  
    
    %   assign unique ID to each trace 
    traces(k).ID = k ; 
    traces(k).kDegree = 0 ; 
    traces(k).links = [] ; 
    
    %   write ID label by each trace 
%     text(traces(k).midpointX, traces(k).midpointY, num2str(traces(k).ID)) ; 
    
end 

hold off ; 
axis on equal ; 
box on ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
xlabel('X, pixels') ; 
ylabel('Y, pixels') ; 

print -r300 -dpng 'testGraph.png' ; 

end  
