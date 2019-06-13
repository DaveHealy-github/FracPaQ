function guiFracPaQ2Dcracktensor(traces, northCorrection, xMax, yMax, flag_revY, flag_revX)
%   guiFracPaQ2Dcracktensor.m 
%       calculates and plots statistics of trace segment angles  
%       
%   David Healy
%   November 2016 
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

%   add 90 degrees to segment angles to get POLES for crack tensor 
traceAngles = [ traces.segmentAngle ] + 90 ; 
traceAngles = round(traceAngles - northCorrection) ; 

traceLengths = [ traces.segmentLength ] ; 

if flag_revX 
    traceAngles = 180 - traceAngles ; 
    for i = 1:max(size(traceAngles))
        if traceAngles(i) < 0 
            traceAngles(i) = traceAngles(i) + 360 ; 
        end ;
    end ; 
end ; 

if flag_revY 
    traceAngles = 180 - traceAngles ; 
    for i = 1:max(size(traceAngles))
        if traceAngles(i) < 0 
            traceAngles(i) = traceAngles(i) + 360 ; 
        end ;
    end ; 
end ; 

A = xMax * yMax ; 

%   2D, 2nd rank crack tensor
F2_2D = zeros(2,2) ; 
for i = 1:2
        
    for j = 1:2 
        
        for p = 1:max(size(traceLengths)) 

            n(1) = cosd(traceAngles(p)) ; 
            n(2) = sind(traceAngles(p)) ; 
    
            F2_2D(i,j) = F2_2D(i,j) + ( 1 / A ) * traceLengths(p)^2 * n(i) * n(j) ; 

        end ; 
        
    end ; 
    
end ; 

% disp(F2_2D) ; 
% disp(trace(F2_2D)) ; 

%   2D, 4th rank crack tensor
F4_2D = zeros(2,2,2,2) ; 
for i = 1:2
        
    for j = 1:2 
        
        for k = 1:2 
            
            for l = 1:2 
        
                for p = 1:max(size(traceLengths)) 

                    n(1) = cosd(traceAngles(p)) ; 
                    n(2) = sind(traceAngles(p)) ; 
    
                    F4_2D(i,j,k,l) = F4_2D(i,j,k,l) + ( 1 / A ) * traceLengths(p)^2 * n(i) * n(j) * n(k) * n(l) ; 
            
                end ; 
                
            end ; 
                    
        end ; 
        
    end ; 
    
end ; 

% disp(F4_2D) ; 

%   2D, 8th rank crack tensor
F8_2D = zeros(2,2,2,2,2,2,2,2) ; 
for i = 1:2
        
    for j = 1:2 
        
        for k = 1:2 
            
            for l = 1:2 
        
                for r = 1:2

                    for s = 1:2 

                        for t = 1:2 

                            for u = 1:2 
        
                                for p = 1:max(size(traceLengths)) 

                                    n(1) = cosd(traceAngles(p)) ; 
                                    n(2) = sind(traceAngles(p)) ; 

                                    F8_2D(i,j,k,l,r,s,t,u) = F8_2D(i,j,k,l,r,s,t,u) + ( 1 / A ) * traceLengths(p)^2 * n(i) * n(j) * n(k) * n(l) * n(r) * n(s) * n(t) * n(u) ; 

                                end ; 
                
                            end ; 
                            
                        end ; 
                        
                    end ; 
                    
                end ; 
                
            end ; 
                    
        end ; 
        
    end ; 
    
end ; 

% disp(F4_2D) ; 

%   display a polar plot
ia = 0 ; 
ninc = 360 ; 
F0 = zeros(1,ninc+1) ; 
F0(:) = sum(traceLengths.^2) / A ; 
F2 = zeros(1,ninc+1) ; 
F4 = zeros(1,ninc+1) ; 
F8 = zeros(1,ninc+1) ; 

for alpha = 0:(2*pi/ninc):2*pi
    
    v(1) = cos(alpha) ; 
    v(2) = sin(alpha) ; 
    
    ia = ia + 1 ; 
    
    for i = 1:2 
        
        for j = 1:2 
            
            F2(ia) = F2(ia) + F2_2D(i,j) * v(i) * v(j) ; 
          
            for k = 1:2 
                
                for l = 1:2 
                    
                    F4(ia) = F4(ia) + F4_2D(i,j,k,l) * v(i) * v(j) * v(k) * v(l) ; 
                    
                    for r = 1:2

                        for s = 1:2 

                            for t = 1:2 

                                for u = 1:2 
                                    
                                    F8(ia) = F8(ia) + F8_2D(i,j,k,l,r,s,t,u) * v(i) * v(j) * v(k) * v(l) * v(r) * v(s) * v(t) * v(u) ;
                                    
                                end ; 
                                
                            end ; 
                            
                        end ; 
                        
                    end ; 
                    
                end ; 
                
            end ; 
            
        end ; 
                    
    end ; 
        
end ; 

lw = 1.5 ; 
f = figure ; 
polarplot(0:(2*pi/ninc):2*pi, F0, '-m', 'LineWidth', lw) ; 
hold on ; 
polarplot(0:(2*pi/ninc):2*pi, F2, '-b', 'LineWidth', lw) ; 
polarplot(0:(2*pi/ninc):2*pi, F4, '-r', 'LineWidth', lw) ; 
polarplot(0:(2*pi/ninc):2*pi, F8, '-g', 'LineWidth', lw) ; 
hold off ; 
ax = gca ; 
ax.ThetaDir = 'clockwise' ; 
ax.ThetaZeroLocation = 'top' ; 
legend('0^{th}', '2^{nd}', '4^{th}', '8^{th}', 'Location', 'southoutside', 'Orientation', 'horizontal') ; 
title({['Crack tensors, n=', num2str(length(traceLengths))];''}) ;

guiPrint(f, 'FracPaQ2D_cracktensor') ; 

end 
