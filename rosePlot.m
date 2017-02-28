function rosePlot(roseAngles, nb, typ, fscale) 
% This is a replacement of MATLAB's rose
% for those in the geophysical sciences.
% It draws a rose diagram of the azimuths (in degrees) 
% in the vector az, after classifying them into
% nb classes. typ is set to 1 (the default value)
% for 360 degree data, or 2 for 180 degree data.
% set fscale = 0 for arithmetic, 1 for square root
% scale for frequency.
% This version uses a modified verson of centaxes
% (centax2) to plot a central scale: to turn this
% off, comment out the call to centax2.  The
% scale shown is the frequency, or the square root
% of the frequency, depending on fscale.
%
% Written by Gerry Middleton, December 1996
%
%   Modified by Dave Healy
%       February 2017

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

if typ == 2    % double, then divide by 2 if necessary
  k = find(roseAngles > 179.99) ;
  roseAngles(k) = roseAngles(k) - 180 ;    % corrected az
  az2 = [roseAngles;(roseAngles+180)] ;    % extended az
end ; 

x = 0:360/nb:360 ;
x2 = 180/nb:360/nb:(360 - 180/nb) ;  % class limits

if typ == 1        
  [f,x2] = histc(roseAngles,x2) ;   % draw histogram
%   stairs(x, [f 0]) ;
else
  xx = [0:360/nb:180] ;    % change x scale
  x3 = [180/nb:360/nb:180-180/nb] ;   % frequencies for histogram
  [f,x3] = hist(roseAngles,x3) ;   % draw histogram
%   stairs(xx, [f 0]) ;
  [f, x2] = histc(az2, x2) ; % frequencies for rose 
end ; 

ftot = sum(f) ;    % find total frequency
if typ == 2
  ftot = ftot/2 ;  % modify if 180 data
end ; 

fmax = max(f) ;    % set up axes for histogram

if typ == 1
  axis([0 360 0 (fmax+1)]) ;
else
  axis([0 180 0 (fmax+1)]) ;
end ; 

set(gca, 'XTick',x) ;

% fh = figure ;          % begin new figure for rose
ff = f ;

if fscale == 1   % scale frequency by maximum
   f = sqrt(f) ;
   fmax = max(f) ;
   f0 = fmax/10 ;
else
   f0 = fmax/10 ;
end ; 

xt = [-fmax:fmax/4:fmax] ;
yt = xt ;

% plot axes
p = plot([-fmax,-f0],[0,0],'k', [f0 fmax], [0, 0],'k',...
  [0,0],[-fmax,-f0],'k', [0 0], [f0,fmax], 'k');
% centax2 ;
axis('square') ;
axis('off') ;
hold on ; 
% % blank out central square, and draw inner circle
% h = fill([-f0 -f0 f0 f0],[-f0 f0 f0 -f0],[0.8 0.8 0.8],...
%    'EdgeColor',[0.8 0.8 0.8]) ;
% arc(f0,0,360) ;
% text(-0.6*f0, 0, num2str(ftot)) ;  % print total frequency
% for i = 1:nb     % draw arcs
%   arc(f(i), x(i), x(i+1)) ;
% end ; 
rs10 = f0*sin(pi*x(1:nb)/180) ;   % draw radial lines
rc10 = f0*cos(pi*x(1:nb)/180) ;
rs1 = f(1:nb) .* sin(pi*x(1:nb)/180) ;
rc1 = f(1:nb) .* cos(pi*x(1:nb)/180) ;
rs20 = f0*sin(pi*x(2:nb+1)/180) ;
rc20 = f0*cos(pi*x(2:nb+1)/180) ;
rs2 = f(1:nb) .* sin(pi*x(2:nb+1)/180) ;
rc2 = f(1:nb) .* cos(pi*x(2:nb+1)/180) ;
k = find(f > 0) ;
plot([rs10(k); rs1(k)],[rc10(k); rc1(k)],'b','linewidth',2) ;
plot([rs20(k); rs2(k)],[rc20(k); rc2(k)],'b','linewidth',2) ;
arc2(fmax, 0, 360) ;  % draw dotted circles at fmax and fmax/2
arc2(fmax/2, 0, 360) ;
if fscale == 1       % and at fmax/1.4 or fmax/4
   arc2(fmax/sqrt(2), 0, 360) ; 
else
   arc2(fmax/4, 0, 360) ; 
end ; 
hold off ; 

