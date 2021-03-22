function [c3,cn3]=PlotLogNorm(x,y,z4,mu,sigma,xmin3,sCol)

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

h(1)= semilogx(c3(:,1),c3(:,2),':s','Color',sCol,'MarkerSize',8,'MarkerFaceColor',sCol);
hold on
h(2)= semilogx(cn3(:,1),cn3(:,2),'-.','Color','k','LineWidth',2);

%Locate the position of Upper and Lower cut-off if applied
PosLc = max(y);
PosUc = min(y);

YL = ylim();

plot([PosUc PosUc], YL, 'r--')
plot([PosLc PosLc], YL, 'r--')

hold off
%set (gca, 'FontSize', 20, 'FontName', 'Calibri');
grid on
title('Lognormal Distribution MLE');
legend('Observed Data','Estimated Data', 'Upper cut-off', 'Lower cut-off');
ylabel('Pr(l \geq l)');
xlabel('Length, units')
dim = [ .2 .025 .3 .3 ] ; 
str = [ '\mu = ', num2str(mu), ', \sigma = ', num2str(sigma) ] ; 
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', 'BackgroundColor', 'w') ; 

end 