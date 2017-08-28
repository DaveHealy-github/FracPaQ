function centax2(ax,orig);
%  The M-file is modified slightly from MATLAB's CENTAXES
%  The original description follows:
%  CENTAXES can be used to change the origin of a 2-D axes
%
%  CENTAXES changes the origin to (0,0) for the current
%  axes and places it at the center of the plot.
%
%  CENTAXES(AX) moves the origin to (0,0) for the axes
%  defined by the handle AX.
%
%  CENTAXES(ORIG) changes the origin of the axes to the
%  origin defined by the 2-element vector ORIG.  The
%  first element is the X-origin and the second element
%  is the Y-origin.
%
%  CENTAXES(AX,ORIG) allows you to specify the axes and 
%  origin.
%
%
%  EXAMPLES:
%
%     t = linspace(-4*pi,4*pi,50);
%     y = sin(t)./t;
%     plot(t,y)
%     centaxes
% 
%     plot(-10:0,-10:0)
%     centaxes(gca,[-5 5])
%
%  Note: This M-file only supports the default 2-D view.  
%        Also, it is not very robust in the sense that you
%        cannot change any axes properties after calling
%        centaxes.m.  If you have to make changes, you have
%        to re-plot the original plot and call centaxes.m 
%        again.
%
%  /////////////////  DISCLAIMER  \\\\\\\\\\\\\\\\\
%  This M-file was written for my own personal use,
%  and it has not been tested, nor is it supported
%  by The MathWorks, Inc.  Please feel free to edit
%  and distribute this file as you see fit.
%  ////////////////////////\\\\\\\\\\\\\\\\\\\\\\\\

% Written by John L. Galenski III - Dec. 12, 1995
% Copyright (c) by The MathWorks, Inc.
% All Rights Reserved
% LDM121295jlg

% Check inputs
if nargin == 0,
  ax = gca; 
  orig = [0 0];
elseif nargin == 1,
  if length(ax) == 1,  % Possibly a handle to the axes
    if ~strcmp(get(ax,'Type'),'axes')
      error('Input must be a handle to an axes or the origin.')
	else
      orig = [0 0];
    end
  elseif length(ax) == 2,  % The origin vector
    ax = gca;
  else
    error('Input must be a handle to an axes or the origin.')
  end
elseif nargin == 2
  if length(ax) == 2 & length(orig)==1  % Swap them
    tmp = ax;
    ax = orig;
    orig = ax;
  end
  if ~strcmp(get(ax,'Type'),'axes')
    error('Input must be a handle to an axes or the origin.')
  end
end

% Start the work.
lim = axis;            % Axis limits.
xt = get(ax,'XTick');  % X-tick locations
yt = get(ax,'YTick');  % Y-tick locations
xc = get(ax,'XColor'); % Color of X-axis
yc = get(ax,'YColor'); % Color of Y-axis
set(gca,'XTickMode','manual', ...  % Fix the tick limits and
        'XLimMode','manual', ...   % locations
        'YTickMode','manual', ...
        'YLimMode','manual');

% Adjust the axes so that the origin is in the middle
if abs(lim(1)) > abs(lim(2))
  xlim = abs(lim(1));
else
  xlim = abs(lim(2));
end
if abs(lim(3))>abs(lim(4))
  ylim = abs(lim(3));
else
  ylim = abs(lim(4));
end
lim = [orig(1)-xlim orig(1)+xlim orig(2)-ylim orig(2)+ylim];
axis(lim)

% Add the new axes --> Each axis (X & Y) are separate lines
axis off
h(1) = line('XData',[lim(1) lim(2)], ...
            'YData',[orig(2) orig(2)], ...
            'Color',xc);
h(2) = line('XData',[orig(1) orig(1)], ...
            'YData',[lim(3) lim(4)], ...
            'Color',yc);

% Add the tick marks
X1 = linspace(lim(1),lim(2),9);
X1 = [X1;X1];
Y1 = [orig(2)-.01*(lim(4)-lim(3));orig(2)+.01*(lim(4)-lim(3))];
line(X1,Y1,'Color',xc)
X2 = [orig(1)-.01*(lim(2)-lim(1));orig(1)+.01*(lim(2)-lim(1))];
Y2 = linspace(lim(3),lim(4),9);
Y2 = [Y2;Y2];
line(X2,Y2,'Color',yc)
set(gca,'XTick',X1(1,:),'YTick',Y2(1,:))

% Label the axes
for i = 1:size(X1,2)
  t1(i) = text(X1(1,i),Y1(1),deblank(sprintf('%3.2g',X1(1,i))));
end
set(t1,'VerticalAlignment','top', ...
      'HorizontalAlignment','center') 
for i = 1:size(Y2,2)
  t2(i) = text(X2(1),Y2(1,i),deblank(sprintf('%3.2g',Y2(1,i))));
end
set(t2,'VerticalAlignment','middle', ...
      'HorizontalAlignment','right') 

end 