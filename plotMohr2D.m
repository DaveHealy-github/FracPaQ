function plotMohr2D(s1, s2, pf, C0, mu, sn, tau) 
%   plot a Mohr diagram for given principal stresses, pore fluid pressure 
%       include a failure or sliding criterion line if given 
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

thetaMohr = 0:1:360 ; 
sin2thetaMohr = sind(2 * thetaMohr) ; 
cos2thetaMohr = cosd(2 * thetaMohr) ; 

tau12Mohr = ( ( s1 - s2 ) / 2 ) * sin2thetaMohr ; 
sigma12Mohr = ( s1 + s2 ) / 2 ... 
                       + ( ( s1 - s2 ) / 2 ) * cos2thetaMohr ;  

lw = 1 ; 
plot(sigma12Mohr, tau12Mohr, '-k', 'LineWidth', lw) ;
hold on ; 
if pf > 0 
    plot(sigma12Mohr-pf, tau12Mohr, '-b', 'LineWidth', lw) ;
end 
plot([0, s1], [C0, mu*s1+C0], '-r', 'LineWidth', lw) ;
%plot(sn, tau, 'ok') ; 
hold off ; 

if pf > 0 
    legend('Stress', 'Effective stress', 'Sliding or Failure', 'Location', 'northwest') ; 
else 
    legend('Stress', 'Sliding or Failure', 'Location', 'northeast') ; 
end 

axis equal on ; 
box on ; 
grid on ; 
xlim([0 max(sigma12Mohr*1.1)]) ; 
ylim([0 s1*0.5]) ; 
xlabel('Normal stress, MPa') ; 
ylabel('Shear stress, MPa') ; 
title({['Mohr diagram \mu=', num2str(mu), ', C_0=', num2str(C0), ' MPa'];''}) ; 

end 
