close all ;

a = [2, 16] ;
L = [1/4, 1/8, 1/32] ; 
nTheta = 9 ; 
fMorlet = 1 ; 
sColour = '[ 0 0 1 ]' ; 

disp(' ') ; 
disp(['*** Started testWavelet.m at ', datestr(now), '...']) ; 
disp(' ') ; 

guiFracPaQ2Dwavelet2('test.jpg', a, L, nTheta, fMorlet, sColour) ; 

%   clean up and quit 
disp(' ') ; 
disp(['*** ...finished testWavelet.m at ', datestr(now), '.']) ; 