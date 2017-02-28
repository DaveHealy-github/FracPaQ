%   plotCrackTensor.m 

%   lengths and angles 
traces.length = ones(1,16)' ; 
traces.angle = [ zeros(1,7)-10, zeros(1,9)+45 ]' ; 
%traces.angle = [ zeros(1,16)+45 ]' ; 

figure ; 
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 
%roseEqualArea([90-traces.angle; 90-traces.angle+180], 10, 0) ; 
roseEqualArea([traces.angle; traces.angle+180], 10, 0) ; 
title(['Trace angles (area weighted), n=', num2str(length(traces.length))]) ; 

% disp(traces.length) ; 
% disp(traces.angle) ; 

xmax = 4 ; 
ymax = 4 ; 
A = xmax * ymax ; 

%   2D, 2nd rank crack tensor
F2_2D = zeros(2,2) ; 
for i = 1:2
        
    for j = 1:2 
        
        for p = 1:max(size(traces.length)) 

            n(1) = cosd(traces.angle(p)) ; 
            n(2) = sind(traces.angle(p)) ; 
    
            F2_2D(i,j) = F2_2D(i,j) + ( 1 / A ) * traces.length(p)^2 * n(i) * n(j) ; 

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
        
                for p = 1:max(size(traces.length)) 

                    n(1) = cosd(traces.angle(p)) ; 
                    n(2) = sind(traces.angle(p)) ; 
    
                    F4_2D(i,j,k,l) = F4_2D(i,j,k,l) + ( 1 / A ) * traces.length(p)^2 * n(i) * n(j) * n(k) * n(l) ; 
            
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
        
                for m = 1:2 
                    
                    for ni = 1:2 
                        
                        for o = 1:2 
                            
                            for p = 1:2 
                                
                                for q = 1:max(size(traces.length)) 

                                    n(1) = cosd(traces.angle(q)) ; 
                                    n(2) = sind(traces.angle(q)) ; 

                                    F8_2D(i,j,k,l,m,ni,o,p) = F8_2D(i,j,k,l,m,ni,o,p) + ...
                                              ( 1 / A ) * traces.length(q)^2 * n(i) * n(j) * n(k) * n(l) * ...
                                              n(m) * n(ni) * n(o) * n(p) ; 

                                end ; 
                                
                            end ; 
                            
                        end ; 
                        
                    end ; 
                    
                end ; 
                
            end ; 
                    
        end ; 
        
    end ; 
    
end ; 

%   display a polar plot
ia = 0 ; 
ninc = 360 ; 
F0 = zeros(1,ninc+1) ; 
F0(:) = sum(traces.length.^2) / A ; 
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
                    
                    for m = 1:2 
                        
                        for n = 1:2 
                            
                            for o = 1:2 
                                
                                for p = 1:2 
                                    
                                    F8(ia) = F8(ia) + F8_2D(i,j,k,l, m, n, o, p) * ...
                                                v(i) * v(j) * v(k) * v(l) * v(m) * v(n) * v(o) * v(p) ;

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
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 
polarplot(0:(2*pi/ninc):2*pi, F0, '-r', 'LineWidth', lw) ; 
hold on ; 
polarplot(0:(2*pi/ninc):2*pi, F2, '-g', 'LineWidth', lw) ; 
polarplot(0:(2*pi/ninc):2*pi, F4, '-b', 'LineWidth', lw) ; 
polarplot(0:(2*pi/ninc):2*pi, F8, '-c', 'LineWidth', lw) ; 
hold off ; 
ax = gca ; 
ax.ThetaDir = 'clockwise' ; 
ax.ThetaZeroLocation = 'top' ; 
legend('0^{th}', '2^{nd}', '4^{th}', '8^{th}', 'Location', 'southoutside', 'Orientation', 'horizontal') ; 

guiPrint(f, 'FracPaQ2D_cracktensor') ; 

