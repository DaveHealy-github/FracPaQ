%   script with examples of pre-processing of image files for FracPaQ2D
%       running one or more of these steps should make a graphics file 
%       readable by FracPaQ2D and better suited to the Hough transform 
%       method used to 'find' the fracture traces
%   
%   Dave Healy
%   January 2018
%   Aberdeen

close all ; 

%   Example 1 - colour jpeg from a digital camera
fnEx1 = 'MacduffColourCropped.jpg' ; 
%fnEx1 = 'Orkney1a.jpg' ; 

%   Step 1 - list the image file attributes  
info = imfinfo(fnEx1) ; 
disp(info) ; 

%   Step 2 - read the file in 
imgEx1 = imread(fnEx1) ; 

%   Step 3 - convert to grayscale 
if ~strcmp('grayscale', info.ColorType)   
    imgEx1gray = rgb2gray(imgEx1) ; 
else
    imgEx1gray = imgEx1 ; 
end ; 

%   Step 4a - median filtering 
imgEx1med = medfilt2(imgEx1gray, [20 20]) ; 

%   Step 4b - find the difference 
imgEx1diff = imgEx1med - imgEx1gray ; 

%   Step 5 - Sobel edge
imgEx1edge = edge(imgEx1diff) ; 

%   Step 6 - skeleton 
imgEx1close = bwmorph(imgEx1edge, 'close', 'inf') ; 

%   Step 7 - thin & invert 
imgEx1inv = bwmorph(imgEx1close, 'thin', 'inf') ; 

figure ; 
subplot(2,3,1) ; 
imshow(imgEx1gray) ; 
title('Grayscale of input') ; 

subplot(2,3,2) ; 
imshow(imgEx1med) ; 
title('Median filter') ;

subplot(2,3,3) ; 
imshow(imgEx1diff) ; 
title('Median filter - raw gray') ;

subplot(2,3,4) ; 
imshow(imgEx1edge) ; 
title('Sobel edges') ;

subplot(2,3,5) ; 
imshow(imgEx1close) ; 
title('Closed edges') ;

subplot(2,3,6) ; 
imshow(~imgEx1inv) ; 
title('Thinned & inverted') ;

%   Step 8 - write the new image file  
imwrite((~imgEx1inv).*255, 'FracPaQ2D_Example1_processed.tif') ; 

%   Step 9 - list the new image file attributes  
info = imfinfo('FracPaQ2D_Example1_processed.tif') ; 
disp(info) ; 
