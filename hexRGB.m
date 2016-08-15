function [ rgb ] = hexRGB(sHex)

rgb1 = hex2dec(sHex(1:2))/255 ; 
rgb2 = hex2dec(sHex(3:4))/255 ; 
rgb3 = hex2dec(sHex(5:6))/255 ; 

disp(rgb1) ; 

rgb = ['[', num2str(rgb1, '%0.2f'), ' ', num2str(rgb2, '%0.2f'), ' ', num2str(rgb3, '%0.2f'), ']'] ;  
