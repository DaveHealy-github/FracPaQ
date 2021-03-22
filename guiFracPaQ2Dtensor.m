function guiFracPaQ2Dtensor(traces, northCorrection, nLambda, ... 
                            flag_revY, flag_revX, ...
                            nAperture, nApertureFactor, nApertureExponent, ...
                            nPixels, sColour) 
%   guiFracPaQ2Dtensor.m
%
%   Dave Healy
%   July 2014
%   d.healy@abdn.ac.uk
%
%   Modified:
%   February 2021 
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
nSegments = length(traceAngles) ; 

if nPixels > 0 
    sUnits = ' metres' ; 
else 
    sUnits = ' pixels' ; 
end 

if flag_revX 
    traceAngles = reverseAxis(traceAngles) ; 
end ; 

if flag_revY 
    traceAngles = reverseAxis(traceAngles) ; 
end ; 

[xMin, xMax, yMin, yMax] = getMapLimits(traces) ; 
area = (xMax - xMin) * (yMax - yMin) ; 

%   calculate Oda F (fabric) tensor 
tracePoles = traceAngles + 90. - northCorrection ; 
[F2, F2pol] = getF2tensor(traceLengths, tracePoles, area) ; 
F0 = sum(eig(F2)) ; 
Fmax = max(eig(F2)) ; 

lw = 1.5 ; 
ninc = 360 ; 
alpha = 0:(2*pi/ninc):2*pi ; 

% figure ; 
% polarplot(alpha, F2pol, '-r', 'LineWidth', lw) ; 
% ax = gca ; 
% ax.ThetaDir = 'clockwise' ; 
% ax.ThetaZeroLocation = 'top' ; 
% title({['Fabric tensor, n=', num2str(length(traceLengths))];''}) ;

t = zeros(length(traceLengths)) ; 
%   calculate Oda P tensor 
if nAperture > 0 
    %   fixed aperture
    t(:) = nAperture ;
else 
    %   aperture scaled to length 
    t = nApertureFactor .* traceLengths.^nApertureExponent ; 
end 

P = zeros(2,2) ; 
l = cosd(tracePoles) ; 
m = sind(tracePoles) ; 
for i = 1:nSegments
    P(1,1) = P(1,1) + (t(i)^3. * traceLengths(i) * l(i) * l(i)) / area ;  
    P(2,2) = P(2,2) + (t(i)^3. * traceLengths(i) * m(i) * m(i)) / area ;  
    P(1,2) = P(1,2) + (t(i)^3. * traceLengths(i) * l(i) * m(i)) / area ;  
end 
P(2,1) = P(1,2) ; 

%   calculate permeability tensor 
kronecker = diag(ones(2,1)) ; 
K = (nLambda / 12.) .* (trace(P) .* kronecker - P) ; 
Kmax = max(eig(K)) ; 
Kmin = min(eig(K)) ; 
disp(['Maximum permeability = ', num2str(Kmax), sUnits, '^2']) ; 
disp(['Minimum permeability = ', num2str(Kmin), sUnits, '^2']) ; 

%   plot permeability 
Kpol = zeros(length(alpha)) ; 
for a = 1:length(alpha)
    Kpol(a) = K(1,1) * cos(alpha(a))^2 + ... 
              K(1,2) * 2. * cos(alpha(a)) * sin(alpha(a)) + ...
              K(2,2) * sin(alpha(a))^2 ; 
end 

f = figure ; 
polarplot(alpha, Kpol, '-b', 'LineWidth', lw) ; 
ax = gca ; 
ax.ThetaDir = 'clockwise' ; 
ax.ThetaZeroLocation = 'top' ; 
title(['Permeability tensor,', sUnits, '^2']) ; 

%   save to file 
guiPrint(f, 'FracPaQ2D_permeability_polar') ; 


end 
