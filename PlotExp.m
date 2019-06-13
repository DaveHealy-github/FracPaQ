function [c2,cn2]=PlotExp(x,y,z2,lambda,xmin2,sCol)

%%
% Author: Roberto Rizzo
% Aberdeen May 2015
% [c2,cn2]=PlotExp(x,z2,lambda,xmin2)
% Generate the plot of the sorted empirical data (z2), and the
% theoretical curve obtained using the MLE for lambda and xmin.

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

%%
% Handles for the plot
h = zeros(2,1);
x=unique(x);
% Construct the empirical C.D.F.
c2 = [sort(x) (length(x):-1:1)'./length(x)];

% Construct the theoretical C.D.F.
cn2 = [z2 (exp((lambda).*(xmin2-z2)))];
cn2(:,2) = cn2(:,2).* c2(find(c2(:,1)>=xmin2,1,'first'),2);

f = figure;

h(1) = semilogy(c2(:,1),c2(:,2),':s','Color',sCol,'MarkerSize',5,'MarkerFaceColor',sCol);
hold on
h(2) = semilogy(cn2(:,1),cn2(:,2),'-.','Color',sCol,'LineWidth',1);

PosLc = max(y);
PosUc = min(y);

YL = ylim();

plot([PosUc PosUc], YL, 'r--')
plot([PosLc PosLc], YL, 'r--')
hold off
grid on
%set (gca, 'FontSize', 20, 'FontName', 'Calibri');
title('Exponential Distribution MLE');
legend('Observed Data','Estimated Data','Upper cut-off', 'Lower cut-off');
ylabel('Pr(l \geq l)');
xlabel('Length, units')
dim = [ .2 .025 .3 .3 ] ; 
str = [ '\lambda = ', num2str(lambda) ] ; 
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', 'BackgroundColor', 'w') ;  

end 