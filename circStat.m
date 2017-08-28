function [ cMean, cStddev, cRes ] = circStat(vAngles) 
%   calculate circular mean and standard deviation of supplied angles
%
%   arguments:
%       vAngles - vector of orientations in degrees 
%   
%   Dave Healy 
%   February 2017 
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

nAngles = length(vAngles) / 2 ; 

V = sum(cosd(2*vAngles(1:nAngles))) ; 
W = sum(sind(2*vAngles(1:nAngles))) ; 

%cMean = atand(W/V)/2 ; 
cMean = atan2d(W,V)/2 ; 
if cMean < 0 
    cMean = cMean + 180 ; 
end ; 
cRes = sqrt(V^2 + W^2) / nAngles ; 
cStddev = 180 * sqrt( 2 * (1 - cRes) ) / pi ; 

end