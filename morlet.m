function [ mx ] = morlet(x, y, k, A, C)
%
% This function calculates the 2-D fully-anisotropic Morlet wavelet 
% over the spatial domain defined by vectors x and y. 
%
% Created by: 	Kaye L. Powell and Roseanna M. Neupauer
%		University of Virginia
%		Department of Civil Engineering
%
% Created on: 	June 29, 2004
% 
% INPUT VARIABLES:
%	x	spatial discretization in the x direction 
%			(1-D vector of length nx)
%	y	spatial discretization in the y direction 
%			(1-D vector of length ny)
%	k	wave vector (1-D vector of length 2)
%	A	anisotropy matrix (diagonal matrix of size 2x2)
%	C	linear transformation matrix (2x2)
%
% OUTPUT VARIABLES:
% 	mx	value of the wavelet at each (x,y) location 
%			(2-D array of size ny,nx )
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

% generate a grid 
[ xf, yf ] = meshgrid(x, y) ;

% calculate A^T A
Anew = A' * A ;

% create Cx vector for each x,y pair.
xx = C(1,1) * xf + C(1,2) * yf ;
yy = C(2,1) * xf + C(2,2) * yf ;

% calculate the values of the wavelet for the rotated and scaled grid
maxT2 = xx .* xx * Anew(1,1) + yy .* yy * Anew(2,2) ;  
mx = exp(1i * (k(1) * xx + k(2) * yy)) .* exp(-maxT2/2) ;

end 