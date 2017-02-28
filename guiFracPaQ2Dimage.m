function [ traces, xMin, yMin, xMax, yMax ] = guiFracPaQ2Dimage(sFile, numPixelsPerMetre, nPeaks, dThreshold, dGap, dMin, ax)
%   guiFracPaQ2Dimage.m 
%       extracts lines (traces) from supplied binary image file 
%       
%   David Healy
%   August 2016
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

hWait = waitbar(0.5, 'Reading image file...', 'Name', 'Preview') ; 

Iin = imread(sFile) ; 

xMin = 0 ; 
yMin = 0 ; 
xMax = size(Iin, 2) ; 
yMax = size(Iin, 1) ; 
% maxPossLength = ceil(sqrt(xMax^2 + yMax^2)) ; 

BW = imcomplement(Iin) ; 
BW = bwmorph(BW, 'clean') ; 

%   HT  
houghRhoRes = 1 ; 
houghThetaRes = 0.5 ; 
disp('HT settings...') ; 
disp(['hough() with rho resolution = ', num2str(houghRhoRes)]) ; 
disp(['hough() with theta resolution = ', num2str(houghThetaRes)]) ; 
[H, theta, rho] = hough(BW, 'RhoResolution', houghRhoRes, 'Theta', -90:houghThetaRes:90-houghThetaRes) ; 

%   find peaks in HT
% numPeaks = 500 ; 
% peakThresholdFactor = 0.25 ; 
peakThreshold = ceil(dThreshold*max(H(:))) ; 
disp(['houghPeaks() with numPeaks = ', num2str(nPeaks), ...
        ', threshold factor = ', num2str(dThreshold)]) ; 
P = houghpeaks(H, nPeaks, 'threshold', peakThreshold) ;   
x = theta(P(:, 2)) ;
y = rho(P(:, 1)) ;
disp(['Found ', num2str(max(size(P))), ' peaks']) ; 
disp(['max(H) = ', num2str(max(max(H)))]) ; 

%   find lines from peaks 
% fillGap = ceil(maxPossLength*0.01) ;  % merge line segments with a gap of < % of image size   
% minLength = ceil(maxPossLength*0.02) ; % keep merged lines with length > % of image size 
disp(['houghLines() with FillGap = ', num2str(dGap), ...
        ', MinLength = ', num2str(dMin)]) ; 
lines = houghlines(BW, theta, rho, P, 'FillGap', dGap, 'MinLength', dMin) ;

close(hWait) ; 

% subplot(2, 2, 4) ; 
%imshow(Iin) ; 
axis on equal ; 
box on ; 
hold on ; 
maxLength = 0 ;
lengths = zeros(length(lines), 1) ; 
angles = zeros(length(lines), 1) ;
for k = 1:length(lines)
    
   xy = [ lines(k).point1 ; lines(k).point2 ] ;
   
   tanAngle = ( lines(k).point2(1) - lines(k).point1(1) ) / ... 
              ( lines(k).point2(2) - lines(k).point1(2) ) ; 
   
   angles(k) = atan(tanAngle) * 180 / pi ; 
   if angles(k) < 0 
       angles(k) = angles(k) + 180 ; 
   end ; 
   
   plot(ax, xy(:, 1), xy(:, 2), 'LineWidth', 0.75, 'Color', 'blue') ;

   %    plot beginnings and ends of lines
   %plot( xy(1, 1), xy(1, 2), '-', 'LineWidth', 1, 'Color', 'yellow') ;
   %plot( xy(2, 1), xy(2, 2), '-', 'LineWidth', 1, 'Color', 'red') ;

   %    determine the endpoints of the longest line segment
   lengths(k) = norm( lines(k).point1 - lines(k).point2 ) ;
   if ( lengths(k) > maxLength )
      maxLength = lengths(k) ;
   end ; 
   
   %    fill the return structure with line properties 
   traces(k).Segment(1).Point1 = [ lines(k).point1 ] ; 
   traces(k).Segment(1).Point2 = [ lines(k).point2 ] ; 
   
   traces(k).Node(1).x = lines(k).point1(1) ; 
   traces(k).Node(1).y = lines(k).point1(2) ; 
   traces(k).Node(2).x = lines(k).point2(1) ; 
   traces(k).Node(2).y = lines(k).point2(2) ; 
   
   traces(k).segmentLength(1) = lengths(k) ; 
   traces(k).segmentAngle(1) = angles(k) ; 
   traces(k).nSegments = 1 ;  
   traces(k).nNodes = 2 ;  
   
   traces(k).Segment(1).startLength = 0 ;
   traces(k).Segment(1).endLength = traces(1).segmentLength(1) ;

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
                    theta2 = traces(k).segmentAngle(m) ; 
                    deltaX = midl * sind(theta2) ; 
                    deltaY = midl * cosd(theta2) ; 
                    traces(k).midpointX = traces(k).Segment(m).Point1(1) + deltaX ; 
                    traces(k).midpointY = traces(k).Segment(m).Point1(2) + deltaY ; 
                else
%                     disp('Quad SE') ; 
                    theta2 = 180 - traces(k).segmentAngle(m) ; 
                    deltaX = midl * sind(theta2) ; 
                    deltaY = midl * cosd(theta2) ; 
                    traces(k).midpointX = traces(k).Segment(m).Point1(1) + deltaX ; 
                    traces(k).midpointY = traces(k).Segment(m).Point1(2) - deltaY ; 
                end ;     
            else 
                if traces(k).Segment(m).Point1(2) >= traces(k).Segment(m).Point2(2)
%                     disp('Quad SW') ; 
                    theta2 = 90 - traces(k).segmentAngle(m) ;  
                    deltaX = midl * cosd(theta2) ; 
                    deltaY = midl * sind(theta2) ; 
                    traces(k).midpointX = traces(k).Segment(m).Point1(1) - deltaX ; 
                    traces(k).midpointY = traces(k).Segment(m).Point1(2) - deltaY ; 
                else
%                     disp('Quad NW') ; 
                    theta2 = traces(k).segmentAngle(m) - 90 ;  
                    deltaX = midl * cosd(theta2) ; 
                    deltaY = midl * sind(theta2) ; 
                    traces(k).midpointX = traces(k).Segment(m).Point1(1) - deltaX ; 
                    traces(k).midpointY = traces(k).Segment(m).Point1(2) + deltaY ; 
                end ; 
            end ; 

            break ;
            
        end ; 
            
    end ; 
    
end ; 
hold off ; 
set(ax,'YDir','normal') ; 
xlim([xMin xMax]) ; 
ylim([yMin yMax]) ; 
xlabel('X, pixels') ; 
ylabel('Y, pixels') ; 

%   show 3D surface of H to visualise peaks - helps selection of threshold 
scrsz = get(0,'ScreenSize') ;
%f = figure('OuterPosition',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]) ; 
f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

[ newX, newY ] = meshgrid(-90:houghThetaRes:(90-houghThetaRes), ...
                    -(round(norm(size(BW)))-1):houghRhoRes:(round(norm(size(BW)))-1)) ; 

Hthreshold = zeros(size(H)) ; 
Hthresholdlog10 = zeros(size(H)) ; 
Hthreshold(:,:) = peakThreshold ; 
Hthresholdlog10(:,:) = log10(peakThreshold) ; 

subplot(2, 2, 1) ; 
imshow(Iin) ; 
title('Binary image') ; 
axis on equal ; 
box on ; 
set(gca,'YDir','normal') ; 
xlim([0 xMax]) ; 
ylim([0 yMax]) ; 
xlabel('X, pixels') ; 
ylabel('Y, pixels') ; 

% mesh(newX, newY, H) ; 
% axis tight on square ; 
% box on ; 
% set(gca,'YDir', 'reverse') ; 
% title('Hough peaks, 3D') ; 
% xlabel('\theta, degrees') ; 
% ylabel('\rho, pixels') ;
% zlabel('H') ; 
% colormap(hot) ; 

subplot(2, 2, 2) ; 
hold on ; 
mesh(newX, newY, H) ; 
surf(newX, newY, Hthreshold) ; 
hold off ; 
axis tight on square ; 
box on ; 
view(090, 0) ; 
title('Hough peaks, side') ; 
xlabel('\theta, degrees') ; 
ylabel('\rho, pixels') ;
zlabel('H') ; 
colormap(hot) ; 

% subplot(2, 2, 3) ; 
% hold on ; 
% mesh(newX, newY, log10(H)) ; 
% surf(newX, newY, Hthresholdlog10) ; 
% hold off ; 
% axis tight on square ; 
% box on ; 
% view(090, 0) ; 
% title('Hough peaks, side') ; 
% xlabel('\theta, degrees') ; 
% ylabel('\rho, pixels') ;
% zlabel('log_{10} H') ; 
% colormap(hot) ; 

subplot(2, 2, 3) ; 
mesh(newX, newY, H) ; 
axis tight on square ; 
box on ; 
view(0, 90) ; 
xlabel('\theta, degrees') ; 
ylabel('\rho, pixels') ; 
set(gca,'YDir', 'reverse') ; 
title('Hough peaks, plan') ;
colormap(hot) ; 

subplot(2, 2, 4) ; 
hold on ; 
mesh(newX, newY, H) ; 
surf(newX, newY, Hthreshold) ; 
axis tight on square ; 
box on ; 
view(0, 0) ; 
title('Hough peaks, side') ; 
xlabel('\theta, degrees') ; 
ylabel('\rho, pixels') ;
zlabel('H') ; 
colormap(hot) ; 
% 
% subplot(2, 3, 6) ; 
% hold on ; 
% mesh(newX, newY, log10(H)) ; 
% surf(newX, newY, Hthresholdlog10) ; 
% hold off ; 
% axis tight on square ; 
% box on ; 
% view(0, 0) ; 
% title('Hough peaks, side') ; 
% xlabel('\theta, degrees') ; 
% ylabel('\rho, pixels') ;
% zlabel('log_{10} H') ; 
% colormap(hot) ; 

%   save to file 
%print(f, '-djpeg', '-r300', 'FracPaQ2Dhough.jpeg') ; 