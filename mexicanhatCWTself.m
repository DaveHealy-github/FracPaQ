function [WC, eta] = mexicanhatCWTself(x, y, a, theta, L)
%
% This routine performs the wavelet analysis of a two-dimensional
% function using an anisotropic Mexican hat wavelet. The
% function must be defined on a uniformly-spaced regular grid. 
% The wavelet transform is calculated using convolution with Fast 
% Fourier Transforms.
% 
% Created by: 	Dave Healy 
%
%   based on code for the Morlet wavelet 
%       by Kaye L. Powell and Roseanna M. Neupauer
%		University of Virginia
%		Department of Civil Engineering
%
% INPUT VARIABLES:
%	f       function to be analyzed (2-D array of size ny,nx )
%	x       spatial discretization of f in the x direction 
%			(1-D vector of length nx)
%	y       spatial discretization of f in the y direction 
%			(1-D vector of length ny)
%	a       vector of scales for wavelet analsis (1-D vector of length na)
%   theta   vector of orientations for wavelet analysis 
%			(1-D vector of length ntheta)
%   L       vector of anisotropy ratios for wavelet analysis 
%			(1-D vector of length nl)
%
% OUTPUT VARIABLES:
% 	WC	wavelet coefficients for each location for each combination
%			of scale, orientation, and anisotropy ratio
%			(5-D array of size ny,nx,na,ntheta,nl)
%	eta	eta function for each combination of scale, orientation,
%			and anisotropy ratio (3-D array of size na,ntheta,nl)
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

% determine vector lengths
nx = length(x) ;
ny = length(y) ;
na = length(a) ;
ntheta = length(theta) ;
nl = length(L) ;

% identify the mid-point and discretization of the spatial domain
midx = ceil(nx/2) ;
midy = ceil(ny/2) ;
dx = abs(x(2)-x(1)) ;
dy = abs(y(2)-y(1)) ;

% initialize some variables
gprime = zeros(2*ny-1, 2*nx-1) ;
WC = zeros(ny, nx, na, ntheta, nl) ;

% perform wavelet transform to calculate the wavelet coefficient for
% each combination of scale, orientation, and anisotropy ratio
for ia = 1:na

    ax = a(ia) ;
    
    for ith = 1:ntheta
        
        ango=theta(ith) ;
        C = [ cos(ango), sin(ango) ; -sin(ango), cos(ango) ] ;
        
        for il = 1:nl

            A = [ L(il), 0 ; 0, 1 ] ;
%             gprime(1:ny, 1:nx) = ( sqrt(det(A)) / ( ax ) ) * ...
%                                     mexicanhat(-(x-x(midx)) / ax, -(y-y(midy)) / ax, A, C) ;
            gprime(1:ny, 1:nx) = ( 1 / ( ax ) ) * ...
                                    mexicanhat(-(x-x(midx)) / ax, -(y-y(midy)) / ax, A, C) ;
            gfft = fft2(gprime) ;
            temp = ifft2(gfft .* gfft) * dx * dy ;
            WC(:, :, ia, ith, il) = temp(midy:midy+ny-1, midx:midx+nx-1) ;
            
        end ;
        
    end ;
    
%     fprintf('Working .......  %4.1f%% completed. \n', ia / na * 100 ) ;
    
end ; 

eta = permute(squeeze(sum(squeeze(sum(abs(WC).^2, 1)),1)), [1,2,3]) ; 

end 