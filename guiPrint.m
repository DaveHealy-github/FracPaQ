function guiPrint(fig, fn) 
%   guiPrint.m 
%       prints figures in standard format, and adds tag to metadata  
%       
%   David Healy
%   July 2016 
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

global sTag ; 

set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'centimeters') ; 
set(gcf, 'PaperPosition', [ 1 1 20 20 ]) ; 

fn1 = [fn, sTag, '.png'] ; 
print(fig, '-dpng', '-r600', fn1) ;
% fn = [fn, sTag, '.tif'] ; 
% print(fig, '-dtiff', '-r600', fn) ;

%   add some FracPaQ metadata to the file 
% t = Tiff(fn, 'r+') ; 
% t.setTag('Artist', 'FracPaQ2D version 2.6.1') ; 
% t.rewriteDirectory() ; 
% t.close() ; 

end 