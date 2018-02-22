function [c,cn]=PlotPowerLaw(x,y,z,xmin,alpha,sCol)
%%
% Author: Roberto Rizzo
% Aberdeen April 2015
% [c,cn]=PlotPowerLaw(x,z,xmin,alpha)
% Generate the plot of the sorted empirical data (z), and the
% theoretical curve obtained using the MLE for alpha and xmin.

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
c = [sort(x) (length(x):-1:1)'./length(x)];

% Construct the theoretical C.D.F.
cn = [z (z./xmin).^(-alpha+1)];

cn(:,2) = cn(:,2).* c(find(c(:,1)>=xmin,1,'first'),2);

f = figure;
set(gcf, 'PaperPositionMode', 'manual') ; 
set(gcf, 'PaperUnits', 'inches') ; 
set(gcf, 'PaperPosition', [ 0.25 0.25 6 6 ]) ; 

h(1) = loglog(c(:,1),c(:,2),':s','Color',sCol,'MarkerSize',5,'MarkerFaceColor',sCol);
hold on;
h(2) = loglog(cn(:,1),cn(:,2),'-.','Color',sCol,'LineWidth',2);

PosLc = max(y);
PosUc = min(y);

YL = ylim();

plot([PosUc PosUc], YL, 'r--')
plot([PosLc PosLc], YL, 'r--')

hold off

% xr = [10.^floor(log10(min(x))) 10.^ceil(log10(max(x)))];
% xrt = (round(log10(xr(1))):2:round(log10(xr(2))));
% if length(xrt)<4, xrt = (round(log10(xr(1))):1:round(log10(xr(2)))); end;
% yr = [10.^floor(log10(1/length(x))) 1];
% yrt = (round(log10(yr(1))):2:round(log10(yr(2))));
% if length(yrt)<4, yrt = (round(log10(yr(1))):1:round(log10(yr(2)))); end;

% set (gca,'XLim',xr,'XTick',10.^xrt);
% set (gca,'YLim',yr,'YTick',10.^yrt);
%set (gca, 'FontSize', 20, 'FontName', 'Calibri');
grid on;
title('Power Law Distribution MLE');
legend('Observed Data','Estimated Data','Upper cut-off', 'Lower cut-off');
ylabel ('Pr(l \geq l)');
xlabel ('Length, units');
dim = [ .2 .025 .3 .3 ] ; 
str = [ '\alpha = ', num2str(alpha), ', \itx_{min}\rm = ', num2str(xmin) ] ; 
annotation('textbox', dim, 'String', str, 'FitBoxToText', 'on', 'BackgroundColor', 'w') ; 

end 