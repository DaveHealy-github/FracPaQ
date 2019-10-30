function guiFracPaQ2Dtracemap(traces, nPixelsPerMetre, nNorth, xMin, yMin, xMax, yMax, ...
                flag_shownodes, flag_revY, flag_revX, sColour, ...
                fMulticolour, flag_tracemap, flag_sliptendency, flag_dilationtendency, ...
                    flag_tracesbylength, flag_segmentsbylength, flag_segmentsbystrike, ...
                    nSigma1, nSigma2, nThetaSigma1) 
%   guiFracPaQ2Dtracemap.m 
%       calculates and plots statistics of line trace segment lengths  
%       
%   David Healy
%   July 2014 
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

nTraces = length(traces) ; 
nSegments = sum([traces(:).nSegments]) ; 
nNodes = sum([traces(:).nNodes]) ; 

if flag_tracemap

    f = figure ; 
    hold on ; 
    for k = 1:nTraces

        plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'Color', sColour) ;

    end ; 

    if flag_shownodes 

        for k = 1:nTraces

            for l = 1:traces(k).nSegments

                %   plot segment end points
                plot(traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point1(2), 'ok', 'MarkerSize', 4) ; 
                plot(traces(k).Segment(l).Point2(1), traces(k).Segment(l).Point2(2), 'ok', 'MarkerSize', 4) ; 

                %   plot segment mid points 
                plot(traces(k).Segment(l).midpointX, traces(k).Segment(l).midpointY, 'sr') ;  

            end ; 

            %   plot trace mid points 
            plot(traces(k).midpointX, traces(k).midpointY, 'or') ;  

        end ; 

    end ; 
    hold off ; 
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'reverse') ; 
    end ; 
    if nPixelsPerMetre > 0 
        xlabel('X, metres') ; 
        ylabel('Y, metres') ; 
    else
        xlabel('X, pixels') ; 
        ylabel('Y, pixels') ; 
    end ; 
    title({['Mapped traces (n=', num2str(nTraces), ...
           '), segments (n=', num2str(nSegments), ...
           ') & nodes (n=', num2str(nNodes), ')'];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_tracemap') ; 

end ; 

%   multcolour tracemap, if necessary 
if fMulticolour
    
    f = figure ; 

    nTraces = length(traces) ; 
    nSegments = sum([traces(:).nSegments]) ; 
    nNodes = sum([traces(:).nNodes]) ; 

    hold on ; 
    for k = 1:nTraces
        plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'Color', traces(k).Colour) ;
    end ; 
    hold off ; 
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'reverse') ; 
    end ; 
    if nPixelsPerMetre > 0 
        xlabel('X, metres') ; 
        ylabel('Y, metres') ; 
    else
        xlabel('X, pixels') ; 
        ylabel('Y, pixels') ; 
    end ; 
    title({['Multicolour traces (n=', num2str(nTraces), ...
           '), segments (n=', num2str(nSegments), ...
           ') & nodes (n=', num2str(nNodes), ')'];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_tracemap_multicolour') ; 

end ; 

if flag_tracesbylength 
    %   trace length by colour map 
    f = figure ; 
    maxtraceLength = max([traces.totalLength]) ; 
    traceColourMap = cmocean('haline') ; 
    colormap(traceColourMap);

    hold on ; 
    for k = 1:nTraces
        iC = round( ( traces(k).totalLength / maxtraceLength ) * 256 ) ; 
        if iC < 1 || isnan(iC) 
           iC = 1 ; 
        end ; 
        plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.75, 'color', traceColourMap(iC,:) ) ;
    end ; 
    hold off ;
    caxis([0 maxtraceLength]) ; 
    c = colorbar('southoutside') ; 
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'reverse') ; 
    end ; 
    if nPixelsPerMetre > 0 
        xlabel('X, metres') ; 
        ylabel('Y, metres') ; 
        c.Label.String = 'Trace length, metres' ;  
    else
        xlabel('X, pixels') ; 
        ylabel('Y, pixels') ; 
        c.Label.String = 'Trace length, pixels' ;  
    end ; 
    title({['Trace length map, n=', num2str(nTraces)];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_tracelengthmap') ; 
end ; 

if flag_segmentsbylength 
    %   segment length by colour map 
    f = figure ; 
    maxsegmentLength = max([traces.segmentLength]) ; 
    segmentColourMap = cmocean('haline') ; 
    colormap(segmentColourMap);

    hold on ; 
    for k = 1:nTraces
        for l = 1:traces(k).nSegments
            iC = round( ( traces(k).segmentLength(l) / maxsegmentLength ) * 256 ) ; 
            if iC < 1 || isnan(iC)
                iC = 1 ; 
            end ; 
            plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
                  [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                        'LineWidth', 0.75, 'color', segmentColourMap(iC,:) ) ;
        end ; 
    end ; 
    hold off ;
    caxis([0 maxsegmentLength]) ; 
    c = colorbar('southoutside') ; 
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'reverse') ; 
    end ; 
    if nPixelsPerMetre > 0 
        xlabel('X, metres') ; 
        ylabel('Y, metres') ; 
        c.Label.String = 'Segment length, metres' ;  
    else
        xlabel('X, pixels') ; 
        ylabel('Y, pixels') ; 
        c.Label.String = 'Segment length, pixels' ;  
    end ; 
    title({['Segment length map, n=', num2str(nSegments)];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_segmentlengthmap') ; 
end ; 

if flag_segmentsbystrike
    %   segment strike by colour map 
    f = figure ; 
    segmentColours = cmocean('phase', 180) ; 

    hold on ; 
    for k = 1:nTraces

        for l = 1:traces(k).nSegments

            if traces(k).segmentLength(l) > 0

                iAngle = round(traces(k).segmentAngle(l) - nNorth) ; 

                if flag_revY 
                    iAngle = 180 - iAngle ; 
                end ; 

                if flag_revX
                    iAngle = 180 - iAngle ; 
                end ; 

                if iAngle < 0  
                    iAngle = iAngle + 360 ; 
                end ; 

                if iAngle > 180  
                    iAngle = iAngle - 180 ; 
                    if iAngle > 180  
                        iAngle = iAngle - 180 ; 
                    end ; 
                end ; 

                if iAngle < 1  
                    iAngle = 180 ; 
                end ; 

                plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
                      [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                            'LineWidth', 0.75, 'color', segmentColours(iAngle,:) ) ;

            end ; 

        end ;

    end ; 
    hold off ;
    colormap(segmentColours) ; 
    caxis([0 180]) ; 
    c = colorbar('southoutside') ; 
    c.Label.String = 'Segment strike, degrees' ;  
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'reverse') ; 
    end ; 
    if nPixelsPerMetre > 0 
        xlabel('X, metres') ; 
        ylabel('Y, metres') ; 
    else
        xlabel('X, pixels') ; 
        ylabel('Y, pixels') ; 
    end ; 
    title({['Segment strike map, n=', num2str(nSegments)];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_segmentstrikemap') ; 
end ; 

%   new maps for slip and dilation tendency in 2D
%   supplied principal stresses, and azimuth of s1 from North (assumed
%   y-axis)
% s1 = 100e6 ;    %   in Pa
% s2 = 50e6 ;     %   in Pa
% nTheta = 30 ;    %   degrees from North (i.e. the y-axis)
nAlpha = 1:180 ; 
Tsmax = max( ((nSigma1-nSigma2).*sind(nAlpha).*cosd(nAlpha)) ... 
                ./ (nSigma1.*cosd(nAlpha).^2+nSigma2.*sind(nAlpha).^2) ) ;  

if flag_sliptendency 
    
    %   1. slip tendency = shear stress/normal stress on the segment 
    f = figure ; 
    segmentColours = cmocean('thermal', 100) ; 

    hold on ; 
    for k = 1:nTraces

        for l = 1:traces(k).nSegments

            if traces(k).segmentLength(l) > 0

                iAngle = round(traces(k).segmentAngle(l) - nNorth) ; 

                if flag_revY 
                    iAngle = 180 - iAngle ; 
                end ; 

                if flag_revX
                    iAngle = 180 - iAngle ; 
                end ; 

                if iAngle < 0  
                    iAngle = iAngle + 360 ; 
                end ; 

                if iAngle > 180  
                    iAngle = iAngle - 180 ; 
                    if iAngle > 180  
                        iAngle = iAngle - 180 ; 
                    end ; 
                end ; 

                if iAngle < 1  
                    iAngle = 180 ; 
                end ; 

                %   get the angle between the pole to this segment and the s1 azimuth 
                iAlpha = ( iAngle + 90 ) - nThetaSigma1 ; 
                %   calculate normal and shear stress on this segment 
                sn = nSigma1 * cosd(iAlpha)^2 + nSigma2 * sind(iAlpha)^2 ; 
                tau = (nSigma1-nSigma2) * sind(iAlpha) * cosd(iAlpha) ; 
                %   calculate slip and dilation tendency on this segment 
                traces(k).Segment(l).Ts = abs(tau / sn) ;
                traces(k).Segment(l).TsNorm = traces(k).Segment(l).Ts / Tsmax ; 
                traces(k).Segment(l).Td = (nSigma1-sn) / (nSigma1-nSigma2) ; 
                iTs = round(traces(k).Segment(l).TsNorm*100) ; 
                if iTs < 1 
                    iTs = 1 ; 
                end ; 
                plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
                      [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                            'LineWidth', 0.75, 'color', segmentColours(iTs,:) ) ;

            end ; 

        end ;

    end ; 
    hold off ;
    colormap(segmentColours) ; 
    caxis([0 1]) ; 
    c = colorbar('southoutside') ; 
    c.Label.String = 'Normalised slip tendency' ;  
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'reverse') ; 
    end ; 
    if nPixelsPerMetre > 0 
        xlabel('X, metres') ; 
        ylabel('Y, metres') ; 
    else
        xlabel('X, pixels') ; 
        ylabel('Y, pixels') ; 
    end ; 
    title({['Normalised slip tendency for \sigma_1=', num2str(nSigma1), ...
            ' MPa, \sigma_2=', num2str(nSigma2), ' MPa, \theta=', num2str(nThetaSigma1), '\circ'];''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_sliptendencymap') ; 
    
    %   rose plots 
    traceAngles = [ traces.segmentAngle ]' ; 
    %   double the trace angle data over 360 degrees 
    traceAngles2 = [ round(traceAngles - nNorth); ...
                     round(traceAngles - nNorth) + 180 ] ;
    for i = 1:max(size(traceAngles2))
        if traceAngles2(i) < 0 
            traceAngles2(i) = traceAngles2(i) + 360 ; 
        end ; 
    end ; 

    if flag_revX 
        traceAngles2 = 180 - traceAngles2 ; 
        for i = 1:max(size(traceAngles2))
            if traceAngles2(i) < 0 
                traceAngles2(i) = traceAngles2(i) + 360 ; 
            end ;
        end ; 
    end ; 

    if flag_revY 
        traceAngles2 = 180 - traceAngles2 ; 
        for i = 1:max(size(traceAngles2))
            if traceAngles2(i) < 0 
                traceAngles2(i) = traceAngles2(i) + 360 ; 
            end ;
        end ; 
    end ; 

    nRoseBins = 10 ; 
    %   rose plot of segment angles colour-coded by normalised Ts 
    f = figure ; 
    roseEqualAreaColourTendency(traceAngles2, nRoseBins, 0, 0, nSigma1, nSigma2, nThetaSigma1, 1) ; 
    title({['Segment angles (equal area), colour-coded by T_s'];''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_sliptendencyrose') ; 

end ; 

if flag_dilationtendency
    
    %   2. dilation tendency on the segment 
    f = figure ; 
    segmentColours = cmocean('thermal', 100) ; 

    hold on ; 
    for k = 1:nTraces

        for l = 1:traces(k).nSegments

            if traces(k).segmentLength(l) > 0

                iAngle = round(traces(k).segmentAngle(l) - nNorth) ; 

                if flag_revY 
                    iAngle = 180 - iAngle ; 
                end ; 

                if flag_revX
                    iAngle = 180 - iAngle ; 
                end ; 

                if iAngle < 0  
                    iAngle = iAngle + 360 ; 
                end ; 

                if iAngle > 180  
                    iAngle = iAngle - 180 ; 
                    if iAngle > 180  
                        iAngle = iAngle - 180 ; 
                    end ; 
                end ; 

                if iAngle < 1  
                    iAngle = 180 ; 
                end ; 

                %   get the angle between the pole to this segment and the s1 azimuth 
                iAlpha = ( iAngle + 90 ) - nThetaSigma1 ; 
                %   calculate normal and shear stress on this segment 
                sn = nSigma1 * cosd(iAlpha)^2 + nSigma2 * sind(iAlpha)^2 ; 
                tau = (nSigma1-nSigma2) * sind(iAlpha) * cosd(iAlpha) ; 
                %   calculate slip and dilation tendency on this segment 
                traces(k).Segment(l).Td = (nSigma1-sn) / (nSigma1-nSigma2) ; 
                
                iTd = round(traces(k).Segment(l).Td*100) ; 
                if iTd < 1 
                    iTd = 1 ; 
                end ; 
                plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
                      [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                            'LineWidth', 0.75, 'color', segmentColours(iTd,:) ) ;

            end ; 

        end ;

    end ; 
    hold off ;
    colormap(segmentColours) ; 
    caxis([0 1]) ; 
    c = colorbar('southoutside') ; 
    c.Label.String = 'Dilation tendency' ;  
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    if flag_revX 
        set(gca, 'XDir', 'reverse') ; 
    end ; 
    if flag_revY 
        set(gca, 'YDir', 'reverse') ; 
    end ; 
    if nPixelsPerMetre > 0 
        xlabel('X, metres') ; 
        ylabel('Y, metres') ; 
    else
        xlabel('X, pixels') ; 
        ylabel('Y, pixels') ; 
    end ; 
    title({['Dilation tendency for \sigma_1=', num2str(nSigma1), ...
            ' MPa, \sigma_2=', num2str(nSigma2), ' MPa, \theta=', num2str(nThetaSigma1), '\circ'];''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_dilationtendencymap') ; 
    
    %   rose plots 
    traceAngles = [ traces.segmentAngle ]' ; 
    %   double the trace angle data over 360 degrees 
    traceAngles2 = [ round(traceAngles - nNorth); ...
                     round(traceAngles - nNorth) + 180 ] ;
    for i = 1:max(size(traceAngles2))
        if traceAngles2(i) < 0 
            traceAngles2(i) = traceAngles2(i) + 360 ; 
        end ; 
    end ; 

    if flag_revX 
        traceAngles2 = 180 - traceAngles2 ; 
        for i = 1:max(size(traceAngles2))
            if traceAngles2(i) < 0 
                traceAngles2(i) = traceAngles2(i) + 360 ; 
            end ;
        end ; 
    end ; 

    if flag_revY 
        traceAngles2 = 180 - traceAngles2 ; 
        for i = 1:max(size(traceAngles2))
            if traceAngles2(i) < 0 
                traceAngles2(i) = traceAngles2(i) + 360 ; 
            end ;
        end ; 
    end ; 

    nRoseBins = 10 ; 
%   rose plot of segment angles colour-coded by Td 
    f = figure ; 
    roseEqualAreaColourTendency(traceAngles2, nRoseBins, 0, 0, nSigma1, nSigma2, nThetaSigma1, 0) ; 
    title({['Segment angles (equal area), colour-coded by T_d'];''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_dilationtendencyrose') ; 

end ; 

end 