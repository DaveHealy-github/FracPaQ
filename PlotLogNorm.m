function [c3,cn3]=PlotLogNorm(x,z4,mu,sigma,xmin3)

%%
% Author: Roberto Rizzo
% Aberdeen May 2015
% [c3,cn3]=PlotLogNorm(x,z4,mu,sigma)
% Generate the plot of the sorted empirical data (z4), and the
% theoretical curve obtained using the MLE for mu and sigma.

%%
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

% Handles for the plot
h=-zeros(2,1);
x=unique(x);
% Construnct the Empirical C.D.F
c3 = [sort(x) (length(x):-1:1)'./length(x)];

% Construct the Theoretical C.D.F
cn3 = [z4 1-logncdf(z4,mu,sigma)];

cn3(:,2) = cn3(:,2).* c3(find(c3(:,1)>=xmin3,1,'first'),2);

f = figure;
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

h(1)= semilogx(c3(:,1),c3(:,2),':bs','MarkerSize',5,'MarkerFaceColor','b');
hold on
h(2)= semilogx(cn3(:,1),cn3(:,2),'b-.','LineWidth',2);
hold off
%set (gca, 'FontSize', 20, 'FontName', 'Calibri');
grid on
title('Lognormal Distribution MLE');
legend('Observed Data','Estimated Data');
ylabel('Pr(l \geq l)');
xlabel('Length, units')

%   save to file 
%print(f, '-djpeg', '-r300', 'FracPaQ2Dlengths_FittingLogNormal.jpeg') ;