function guiFracPaQ2Dtensor(traces, xMin, yMin, xMax, yMax, northCorrection, nLambda, flag_revY, flag_revX, nAperture, nApertureFactor, nApertureExponent, nPixels, sColour) 
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
traceAngles = [ traces.segmentAngle ]' ; 
traceLengths = [ traces.segmentLength ] ;
nTraces = length(traces) ; 

if flag_revX 
    traceAngles = 180 - traceAngles ; 
end ; 
if flag_revY 
    traceAngles = 180 - traceAngles ; 
end ; 

nSegments = length(traceAngles) ; 

N11 = 0 ; 
N22 = 0 ; 
N12 = 0 ; 

%   we need the poles to the traces, so add 90 degrees
traceAnglesPoles = traceAngles + 90 ; 
traceAnglesPoles(isnan(traceAnglesPoles)) = 0 ; 

%   calculate N11, N22 and N12 
for i = 1:nSegments  
    
    l = cos( ( 90 - traceAnglesPoles(i) ) * pi / 180 ) ; 
    m = cos( traceAnglesPoles(i) * pi / 180 ) ; 
    
    N11 = N11 + l^2 ; 
    N22 = N22 + m^2 ; 
    N12 = N12 + ( l * m ) ; 
    
end 

N11 = N11 / nSegments ; 
N22 = N22 / nSegments ; 
N12 = N12 / nSegments ; 

%   calculate P11, P22 and P12 
k = 0 ; 
for i = 1:nTraces
    
    for j = 1:traces(i).nSegments 
        
        k = k + 1 ; 
        segmentsxy(k, :) = [ traces(i).Segment(j).Point1(1), traces(i).Segment(j).Point1(2), ... 
                           traces(i).Segment(j).Point2(1), traces(i).Segment(j).Point2(2) ] ;
   
    end ;
    
end ; 

if nAperture > 0 
    %   fixed aperture
    t = nAperture ;
else 
    %   aperture scaled to length 
    t = nApertureFactor .* traceLengths.^nApertureExponent ; 
end ; 

[ ~, ~, mq ] = probePlane(3, xMin, yMin, xMax, yMax, segmentsxy, 2) ; 
nq1 = mq(1) ; 
nq2 = mq(2) ;
nq12 = mean([nq1, nq2]) ; 

%   Suzuki et al., 1998; equation 5
P11 = mean(t.^3) * nq2 * N11 ; 
P22 = mean(t.^3) * nq1 * N22 ; 
P12 = mean(t.^3) * nq12 * N12 ; 

%   calculate k11, k22, k12 
lambda = nLambda ; 
k11 = lambda * P22 ; 
k22 = lambda * P11 ; 
k12 = -lambda * P12 ;

[ eigVec, eigVal ] = eig([ k11, k12 ; k12, k22 ]) ; 
k1 = eigVal(2,2) ; 
k2 = eigVal(1,1) ;
% disp(eigVec) ; 
% disp(eigVal) ; 
thetatrace = acos(eigVec(2,2)) * 180 / pi ; 
kratio = k1 / k2 ; 
if flag_revX 
    kazimuth = thetatrace - northCorrection ; 
else
    kazimuth = 180 - thetatrace - northCorrection ; 
end ; 
if flag_revY 
    kazimuth = thetatrace - northCorrection ; 
else
    kazimuth = 180 - thetatrace - northCorrection ; 
end ; 

disp(' ') ; 
disp('Permeability tensor:') ; 
if nPixels > 0 
    disp(['k1 = ', num2str(k1), ' m^2']) ; 
    disp(['k2 = ', num2str(k2), ' m^2']) ; 
    disp(['Azimuth of k1 = ', num2str(kazimuth, '%03f'), ' degrees']) ; 
else 
    disp(['k1 = ', num2str(k1), ' pixels^2']) ; 
    disp(['k2 = ', num2str(k2), ' pixels^2']) ; 
    disp(['Azimuth of k1 = ', num2str(kazimuth, '%03f'), ' degrees']) ; 
end ;     

%   plot azimuthal variation of k 
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

%   permeability in the direction of flow (after Long et al., 1982. WRR)
ek1 = sqrt(k1) ; 
ek2 = sqrt(k2) ; 

f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

plotEllipse(ek1, ek2, kazimuth, sColour) ; 

title({['Permeability in direction of flow, k_1:k_2=', ...
            num2str(round(kratio), '%i'), ':1, ', ...
            'k_1 azimuth=', num2str(round(kazimuth), '%03i')];''}) ; 

%   save to file 
guiPrint(f, 'FracPaQ2D_permtensor_flow') ; 

%   permeability in the direction of gradient (after Long et al., 1982.
%   WRR)
ek1 = 1 / sqrt(k1) ; 
ek2 = 1 / sqrt(k2) ; 

f = figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

plotEllipse(ek1, ek2, kazimuth, sColour) ; 

title({['Permeability in direction of gradient, k_1:k_2=', ...
            num2str(round(kratio), '%i'), ':1, ', ...
            'k_1 azimuth=', num2str(round(kazimuth), '%03i')];''}) ; 

%   save to file 
guiPrint(f, 'FracPaQ2D_permtensor_gradient') ; 

end 
