close all ; 

%   image size 
nx = 100 ; 
ny = nx ; 

%   background image size 
nx2 = nx * 3 ; 
ny2 = nx2 ; 

%   position of image in background 
ix = floor(nx2/2 - nx/2) ;
iy = ix ; 

imTest = eye(nx, ny) ; 

figure ; 
imshow(imTest) ;
title({'imTest';''}) ; 
axis on equal tight ; 
box on ; 

imTestComp = imcomplement(imTest) ; 
imTestCompClean = bwmorph(imTestComp, 'clean') ; 
imTestBackground = ones(nx2, ny2) ; 
imTestBackground(ix:ix+nx-1, iy:iy+ny-1) = imTestCompClean ; 

figure ; 
imshow(imTestComp) ;
title({'imTestComp';''}) ; 
axis on equal tight ; 
box on ; 

figure ; 
imshow(imTestCompClean) ;
title({'imTestClean';''}) ; 
axis on equal tight ; 
box on ; 

figure ; 
bwmap = [ 0, 0, 0 ; 1, 1, 1 ] ; 
colormap(bwmap) ; 
imshow(imTestBackground) ;
axis equal tight off ; 
print -dbmp256 'testImage.bmp' ; 

imInfo = imfinfo('testImage.bmp') ; 
disp(imInfo) ; 
