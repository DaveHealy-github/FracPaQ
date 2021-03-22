function plotMohr2D(s1, s2, pf) 

thetaMohr = 0:1:360 ; 
sin2thetaMohr = sind(2 * thetaMohr) ; 
cos2thetaMohr = cosd(2 * thetaMohr) ; 

tau12Mohr = ( ( s1 - s2 ) / 2 ) * sin2thetaMohr ; 
sigma12Mohr = ( s1 + s2 ) / 2 ... 
                       + ( ( s1 - s2 ) / 2 ) * cos2thetaMohr ;  

lw = 1 ; 
plot(sigma12Mohr, tau12Mohr, '-r', 'LineWidth', lw) ;

if pf > 0 
    hold on ; 
    plot(sigma12Mohr-pf, tau12Mohr, '-.b', 'LineWidth', lw) ;
    hold off ; 
    legend('Stress', 'Effective stress', 'Location', 'northwest') ; 
else 
    legend('Stress', 'Location', 'northwest') ; 
end 

axis equal on ; 
box on ; 
grid on ; 
xlim([0 max(sigma12Mohr*1.1)]) ; 
ylim([0 max(tau12Mohr)*1.2]) ; 
