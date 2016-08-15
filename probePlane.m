function [ m, m_ij, mq ] = probePlane(x, xMin, yMin, xMax, yMax, traces, nq)
%   probePlane.m
%
%   Uses stereology methods on 3 orthogonal 2D images to define 
%   3D fabric and crack tensors  
%
%   references:
%       Suzuki et al., 1998 IJRMMS v35 
%       Oda et al., 2002 JGR v107
%
%   David Healy
%   August 2012 
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

%   run scan traces over the image, centred on the image mid point
%   at nq different angles 
xMid = floor((xMax-xMin)/2) ; 
yMid = floor((yMax-yMin)/2) ; 
nLines = 1 ; 
if nLines == 1 
%     disp(' ') ; 
%     disp('*** Using radial scanlines...') ; 
    lenScanline = 0.9 * min(xMax-xMin, yMax-yMin) ; 
else       
%     disp(' ') ; 
%     disp('*** Using parallel scanlines...') ; 
    lenScanline = 0.9 * sqrt((xMax-xMin)^2 + (yMax-yMin)^2) ; 
end ; 
d = lenScanline / nLines ; 
id = -10:1:10 ; 
id = id' ; 
mq = zeros(nq, 1) ; 
mq_new = zeros(nq, 1) ; 

% subplot(1,3,x) ; 
% hold on ; 
traces = traces(~any(isnan(traces),2),:) ; 

%   X2 (Y) plane - ref line is x3 (Z)
if x == 2 

    for a = 1:nq 

        angleScan = ( a - 1 ) * pi / nq ; 
        sina = sin(angleScan) ; 
        cosa = cos(angleScan) ; 
%         disp(['Angle of this scan line = ', num2str(angleScan*180/pi), ' deg']) ; 

        if nLines > 1 
            %   define parallel scan lines 
            deltaX = sina * d ; 
            deltaY = cosa * d ; 

            x1Scan = xMid - ( id * deltaX ) + ( sina * lenScanline ) / 2 ; 
            y1Scan = yMid + ( id * deltaY ) + ( cosa * lenScanline ) / 2 ; 

            x2Scan = xMid - ( id * deltaX ) - ( sina * lenScanline ) / 2 ; 
            y2Scan = yMid + ( id * deltaY ) - ( cosa * lenScanline ) / 2 ; 
        else 
            %   define radial scan line: length, angle and end points 
            x1Scan = xMid + ( sina * lenScanline ) / 2 ;  
            y1Scan = yMid + ( cosa * lenScanline ) / 2 ; 
            x2Scan = xMid - ( sina * lenScanline ) / 2 ; 
            y2Scan = yMid - ( cosa * lenScanline ) / 2 ; 
        end ; 

        %   find which traces intersected by scan line - their angles and lengths  
        scanXY = [ round(x1Scan), round(y1Scan), round(x2Scan), round(y2Scan) ] ; 

        intersectionScan = lineSegmentIntersect(scanXY, traces) ; 

        %   count intersections of scan line with traces 
        numIntersections = max(size(find(intersectionScan.intMatrixX > 0))) ; 

        %   normalise count by total scan line length 
        mq(a) = numIntersections / ( nLines * lenScanline ) ; 
%         disp(['Count of intersections = ', num2str(numIntersections)]) ;
%         disp(['Normalised count of intersections = ', num2str(mq(a))]) ;

%         if a == 1 
%             plot([x1Scan'; x2Scan'], [y1Scan'; y2Scan'], '-r', 'LineWidth', 1) ; 
%         elseif a == nq 
%             plot([x1Scan'; x2Scan'], [y1Scan'; y2Scan'], '-b', 'LineWidth', 1) ; 
%         else 
%             plot([x1Scan'; x2Scan'], [y1Scan'; y2Scan'], '-k') ; 
%         end ; 
        
    end ; 
    
    %   ?re-order mq?
    for b = 1:nq/2+1 
        mq_new(b) = mq(nq/2-b+2) ;
    end ; 
    for c = nq/2+2:nq
        mq_new(c) = mq(nq-c+nq/2+2) ;
    end ;
    mq = mq_new ; 
    
%   X3 (Z) plane - ref line is x1 (X)
%   X1 (X) plane - ref line is x2 (Y)
else
    
    for a = 1:nq 

        angleScan = ( a - 1 ) * pi / nq ; 
        sina = sin(angleScan) ; 
        cosa = cos(angleScan) ; 
%         disp(['Angle of this scan line = ', num2str(angleScan*180/pi), ' deg']) ; 

        if nLines > 1  
            %   define parallel scan lines 
            deltaX = cosa * d ; 
            deltaY = sina * d ; 

            x1Scan = xMid - ( id * deltaX ) + ( cosa * lenScanline ) / 2 ; 
            y1Scan = yMid + ( id * deltaY ) + ( sina * lenScanline ) / 2 ; 

            x2Scan = xMid - ( id * deltaX ) - ( cosa * lenScanline ) / 2 ; 
            y2Scan = yMid + ( id * deltaY ) - ( sina * lenScanline ) / 2 ; 
        else 
            %   define radial scan line: length, angle and end points 
            x1Scan = xMid + ( cosa * lenScanline ) / 2 ;  
            y1Scan = yMid + ( sina * lenScanline ) / 2 ; 
            x2Scan = xMid - ( cosa * lenScanline ) / 2 ; 
            y2Scan = yMid - ( sina * lenScanline ) / 2 ; 
        end ; 

        %   find which traces intersected by scan line - their angles and lengths  
        scanXY = [ x1Scan, y1Scan, x2Scan, y2Scan ] ; 

        intersectionScan = lineSegmentIntersect(scanXY, traces) ; 

        %   count intersections of scan line with traces 
        numIntersections = max(size(find(intersectionScan.intMatrixX > 0))) ; 

        %   normalise count by total scan line length 
        mq(a) = numIntersections / ( nLines * lenScanline ) ; 
%         disp(['Count of intersections = ', num2str(numIntersections)]) ;
%         disp(['Normalised count of intersections = ', num2str(mq(a))]) ;

%         if a == 1 
%             plot([x1Scan'; x2Scan'], [y1Scan'; y2Scan'], '-r', 'LineWidth', 1) ; 
%         elseif a == nq 
%             plot([x1Scan'; x2Scan'], [y1Scan'; y2Scan'], '-b', 'LineWidth', 1) ; 
%         else 
%             plot([x1Scan'; x2Scan'], [y1Scan'; y2Scan'], '-k') ; 
%         end ; 
        
    end ; 
    
end ; 
% hold off ; 
% axis equal on ; 
% box on ; 
% xlim([0 xMax]) ; 
% ylim([0 yMax]) ; 

m = 2 * pi * sum(mq) / nq ;

summqa = 0 ; 
for a = 1:nq 
    summqa = summqa + ( mq(a) * sin( 2 * pi * (a-1) / nq ) ) ; 
end ;

m_ij = pi * summqa / nq ; 
