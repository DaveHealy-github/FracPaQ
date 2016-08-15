function guiFracPaQ2Dtensor(traces, xMin, yMin, xMax, yMax, nAperture, nLamda, flag_reverse) 
%   guiFracPaQ2Dtensor.m
%
%   Dave Healy
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

%   trace segment angles are measured from Y-axis, clockwise is positive 
nTraces = length(traces) ; 
traceAngles = [ traces.segmentAngle ]' ; 
traceLengths = [ traces.segmentLength ] ;

traceAngles = traceAngles ; 
if flag_reverse 
    traceAngles = 180 - traceAngles ; 
end ; 

nSegments = length(traceAngles) ; 

N11 = 0 ; 
N22 = 0 ; 
N12 = 0 ; 

%   we need the poles to the traces, so add 90 degrees
traceAnglesPoles = traceAngles + 90 ; 

%   calculate N11, N22 and N12 
for i = 1:nSegments  
    
    l = cos( ( 90 - traceAnglesPoles(i) ) * pi / 180 ) ; 
    m = cos( traceAnglesPoles(i) * pi / 180 ) ; 
    
    N11 = N11 + l^2 ; 
    N22 = N22 + m^2 ; 
    N12 = N12 + ( l * m ) ; 
    
end 

N11 = N11 / nTraces ; 
N22 = N22 / nTraces ; 
N12 = N12 / nTraces ; 

% disp(N11) ; 
% disp(N22) ; 
% disp(N12) ; 

%   calculate P11, P22 and P12 
k = 0 ; 
for i = 1:nTraces
    
    for j = 1:traces(i).nSegments 
        
        k = k + 1 ; 
        segmentsxy(k, :) = [ traces(i).Segment(j).Point1(1), traces(i).Segment(j).Point1(2), ... 
                           traces(i).Segment(j).Point2(1), traces(i).Segment(j).Point2(2) ] ;
   
    end ;
    
end ; 

t = nAperture ; 
[ ~, ~, mq ] = probePlane(3, xMin, yMin, xMax, yMax, segmentsxy, 2) ; 
nq1 = mq(1) ; 
nq2 = mq(2) ;
nq12 = mean([nq1, nq2]) ; 

% disp(nq1) ; 
% disp(nq2) ; 
% disp(nq12) ; 

P11 = t^3 * nq2 * N11 ; 
P22 = t^3 * nq1 * N22 ; 
P12 = t^3 * nq12 * N12 ; 

% disp(P11) ; 
% disp(P22) ; 
% disp(P12) ; 

%   calculate k11, k22, k12 
lamda = nLamda ; 
k11 = lamda * P22 ; 
k22 = lamda * P11 ; 
k12 = -lamda * P12 ;

% disp('Cartesian k_ij:') ; 
% disp(k11) ; 
% disp(k22) ; 
% disp(k12) ; 

[ eigVec, eigVal ] = eig([ k11, k12 ; k12, k22 ]) ; 
k1 = eigVal(2,2) ; 
k2 = eigVal(1,1) ;
% disp(eigVec) ; 
% disp(eigVal) ; 
thetatrace = acos(eigVec(2,2)) * 180 / pi ; 
kratio = k1 / k2 ; 
if flag_reverse 
    kazimuth = thetatrace ; 
else
    kazimuth = 180 - thetatrace ; 
end ; 

disp(' ') ; 
disp('Permeability tensor: k1, k2 and theta...') ; 
disp(k1) ; 
disp(k2) ; 
disp(kazimuth) ; 

%   plot azimuthal variation of k 

% %   mapped lines 
% subplot(1, 2, 1) ; 
% hold on ; 
% for k = 1:length(traces)
%     
%     plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 1, 'Color', 'green') ;
% 
% end ; 
% hold off ; 
% %set(gca,'YDir', 'reverse') ; 
% axis on equal ; 
% box on ; 
% xlim([0 xMax]) ; 
% ylim([0 yMax]) ; 
% xlabel('X, pixels') ; 
% ylabel('Y, pixels') ; 
% title(['Mapped trace segments, n=', num2str(nSegments)]) ; 

theta = thetatrace - 90 ; 
x = -k1:k1/10:k1 ; 
y = sqrt( k2^2 * ( 1 - x.^2 / k1^2 ) ) ; 
xprime = x * cos(theta*pi/180) - y * sin(theta*pi/180) ; 
yprime = x * sin(theta*pi/180) + y * cos(theta*pi/180) ; 
y = -sqrt( k2^2 * ( 1 - x.^2 / k1^2 ) ) ; 
xprime2 = x * cos(theta*pi/180) - y * sin(theta*pi/180) ; 
yprime2 = x * sin(theta*pi/180) + y * cos(theta*pi/180) ; 
% xprime = x * cos(thetatrace*pi/180) - y * sin(thetatrace*pi/180) ; 
% yprime = x * sin(thetatrace*pi/180) + y * cos(thetatrace*pi/180) ; 
% y = -sqrt( k2^2 * ( 1 - x.^2 / k1^2 ) ) ; 
% xprime2 = x * cos(thetatrace*pi/180) - y * sin(thetatrace*pi/180) ; 
% yprime2 = x * sin(thetatrace*pi/180) + y * cos(thetatrace*pi/180) ; 
lim = max([max(xprime), max(yprime)]) * 1.2 ; 

% subplot(1,2,2) ; 
% scrsz = get(0,'ScreenSize') ;
% figure('OuterPosition',[1 scrsz(4)/2 scrsz(3)/2 scrsz(4)/2]) ; 

f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

hold on ; 
rectangle('Position', [-k2/2 -k1/2 k2 k1], 'Curvature', [1 1], 'EdgeColor', 'b', 'FaceColor', 'b') ; 
plot([-k2/2*1.2, +k2/2*1.2], [0, 0], '-k') ; 
plot([0, 0], [-k1/2*1.2, +k1/2*1.2], '-k') ; 
hold off ; 
view(kazimuth, 90) ; 
axis equal off ; 
% xlim([-lim lim]) ; 
% ylim([-lim lim]) ; 
title(['Permeability, k_1:k_2=', ...
            num2str(round(kratio), '%i'), ':1, ', ...
            'k_1 azimuth=', num2str(round(kazimuth), '%03i')]) ; 

%   save to file 
guiPrint(f, 'FracPaQ2D_permtensor') ; 
