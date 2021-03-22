function guiFracPaQ2Dtracemap(traces, nPixelsPerMetre, nNorth, ...
                flag_shownodes, flag_revY, flag_revX, sColour, ...
                fMulticolour, flag_tracemap, flag_sliptendency, flag_dilationtendency, ...
                    flag_tracesbylength, flag_segmentsbylength, flag_segmentsbystrike, ...
                    nSigma1, nSigma2, nThetaSigma1, flag_fracsuscep, flag_CSF, C0, pf, mu) 
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

[xMin, xMax, yMin, yMax] = getMapLimits(traces) ; 

if nPixelsPerMetre > 0 
    sUnits = ' metres' ; 
else 
    sUnits = ' pixels' ; 
end 

if flag_revX 
    sXDir = 'reverse' ; 
else 
    sXDir = 'normal' ; 
end 

if flag_revY 
    sYDir = 'reverse' ; 
else 
    sYDir = 'normal' ; 
end 

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
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    title({['Mapped traces (n=', num2str(nTraces), ...
           '), segments (n=', num2str(nSegments), ...
           ') & nodes (n=', num2str(nNodes), ')'];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_tracemap') ; 

end ; 

%   multi-colour tracemap, if necessary 
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
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    title({['Multicolour traces (n=', num2str(nTraces), ...
           '), segments (n=', num2str(nSegments), ...
           ') & nodes (n=', num2str(nNodes), ')'];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_tracemap_multicolour') ; 

end ; 

%   trace length by colour map 
if flag_tracesbylength 
    
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
    caxis([maxtraceLength/1e3 maxtraceLength]) ; 
    set(gca, 'ColorScale', 'log') ; 
    c = colorbar('southoutside', ... 
                 'Ticks', [maxtraceLength/1e3, maxtraceLength/12, maxtraceLength/3, maxtraceLength], ... 
                 'TickLabels', {num2str(round(maxtraceLength/1e3), '%d'), ...
                                num2str(round(maxtraceLength/12), '%d'), ...
                                num2str(round(maxtraceLength/3), '%d'), ...
                                num2str(round(maxtraceLength), '%d')}) ; 
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    c.Label.String = ['Trace length,', sUnits] ;   
    title({['Trace length map, n=', num2str(nTraces)];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_tracelengthmap') ; 
end ; 

%   segment length by colour map 
if flag_segmentsbylength 
    
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
    caxis([maxsegmentLength/1e3 maxsegmentLength]) ; 
    set(gca, 'ColorScale', 'log') ; 
    c = colorbar('southoutside', ... 
                 'Ticks', [maxsegmentLength/1e3, maxsegmentLength/12, maxsegmentLength/3, maxsegmentLength], ... 
                 'TickLabels', {num2str(round(maxsegmentLength/1e3), '%d'), ...
                                num2str(round(maxsegmentLength/12), '%d'), ...
                                num2str(round(maxsegmentLength/3), '%d'), ...
                                num2str(round(maxsegmentLength), '%d')}) ; 
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    c.Label.String = ['Segment length,', sUnits] ;   
    title({['Segment length map, n=', num2str(nSegments)];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_segmentlengthmap') ; 
end ; 

%   segment strike by colour map 
if flag_segmentsbystrike
    
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
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    title({['Segment strike map, n=', num2str(nSegments)];''}) ; 

    %   save to file 
    guiPrint(f, 'FracPaQ2D_segmentstrikemap') ; 
end ; 

%   maps for slip and dilation tendency in 2D
%   supplied principal stresses, and azimuth of s1 from North
nAlpha = [ traces.segmentAngle ]' + 90. ; 
tau = abs(-(nSigma1 - nSigma2) .* sind(2 * nAlpha) / 2.0) ; 
sigmaN = (nSigma1 + nSigma2) / 2.0  + (nSigma1 - nSigma2) .* cosd(2 * nAlpha) / 2.0 ; 
Tsmax = max(abs(tau ./ sigmaN)) ;  
Sfmax = max(sigmaN - (tau - C0) / mu) ; 
Sfmin = min(sigmaN - (tau - C0) / mu) ; 

if flag_sliptendency || flag_dilationtendency || flag_fracsuscep || flag_CSF 

    i = 0 ; 
    for k = 1:nTraces

        for l = 1:traces(k).nSegments

            if traces(k).segmentLength(l) > 0

                i = i + 1 ; 
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
                sn(i) = 0.5 * (nSigma1 + nSigma2) + 0.5 * (nSigma1 - nSigma2) * cosd(2 * iAlpha) ; 
                tau(i) = -0.5 * (nSigma1 - nSigma2) * sind(2 * iAlpha) ; 
                
                traces(k).Segment(l).sn = abs(sn(i)) ; 
                traces(k).Segment(l).tau = abs(tau(i)) ;

            else 
                
                traces(k).Segment(l).sn = 0 ; 
                traces(k).Segment(l).tau = 0 ;
                
            end 
            
        end 
    end
    
    f = figure ; 
    plotMohr2D(nSigma1, nSigma2, pf, C0, mu, sn, tau) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_Mohrplot') ; 
    
end 

if flag_sliptendency 
    
    %   1. slip tendency = shear stress/normal stress on the segment 
    f = figure ; 
    segmentColours = colormap(jet(100)) ; 
    hold on ; 
    for k = 1:nTraces

        for l = 1:traces(k).nSegments

            %   calculate slip tendency on this segment 
            traces(k).Segment(l).Ts = traces(k).Segment(l).tau / traces(k).Segment(l).sn ;
            traces(k).Segment(l).TsNorm = traces(k).Segment(l).Ts / Tsmax ; 
            iTs = round(traces(k).Segment(l).TsNorm*100) ; 
            if iTs < 1 
                iTs = 1 ; 
            end 
            if isnan(iTs) 
                iTs = 1 ; 
            end 
            plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
                  [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                        'LineWidth', 0.75, 'color', segmentColours(iTs,:) ) ;

        end

    end 
    hold off ;
    colormap(segmentColours) ; 
    caxis([0 1]) ; 
    c = colorbar('southoutside') ; 
    c.Label.String = 'Normalised slip tendency' ;  
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    title({['Normalised slip tendency for \sigma_1=', num2str(nSigma1), ...
            ' MPa, \sigma_2=', num2str(nSigma2), ' MPa, \theta=', num2str(nThetaSigma1), '\circ'];''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_sliptendencymap') ; 
    
    %   rose plots 
    traceAngles = [ traces.segmentAngle ]' ; 
    %   double the trace angle data over 360 degrees 
    traceAngles2 = doubleAngles(traceAngles, nNorth) ;  
    %   flip the angles if the axis is flipped 
    if flag_revX 
        traceAngles2 = reverseAxis(traceAngles2) ; 
    end ; 
    if flag_revY 
        traceAngles2 = reverseAxis(traceAngles2) ; 
    end ; 
    nRoseBins = 10 ; 
    %   rose plot of segment angles colour-coded by normalised Ts 
    f = figure ; 
    roseEqualAreaColourTendency(traceAngles2, nRoseBins, 0, 0, ...
                                    nSigma1, nSigma2, nThetaSigma1, 1, C0, mu, pf) ; 
    title({'Segment angles (equal area), colour-coded by T_s';''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_sliptendencyrose') ; 

end ; 

if flag_dilationtendency
    
    %   2. dilation tendency on the segment 
    f = figure ; 
    segmentColours = colormap(jet(100)) ; 
    hold on ; 
    for k = 1:nTraces

        for l = 1:traces(k).nSegments

            %   calculate slip and dilation tendency on this segment 
            traces(k).Segment(l).Td = (nSigma1 - traces(k).Segment(l).sn) / (nSigma1 - nSigma2) ; 
            iTd = round(traces(k).Segment(l).Td * 100) ; 
            if iTd < 1 
                iTd = 1 ; 
            end 
            plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
                  [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                        'LineWidth', 0.75, 'color', segmentColours(iTd,:) ) ;

        end

    end
    hold off ;
    colormap(segmentColours) ; 
    caxis([0 1]) ; 
    c = colorbar('southoutside') ; 
    c.Label.String = 'Dilation tendency' ;  
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    title({['Dilation tendency for \sigma_1=', num2str(nSigma1), ...
            ' MPa, \sigma_2=', num2str(nSigma2), ' MPa, \theta=', num2str(nThetaSigma1), '\circ'];''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_dilationtendencymap') ; 
    
    %   rose plots 
    traceAngles = [ traces.segmentAngle ]' ; 
    %   double the trace angle data over 360 degrees 
    traceAngles2 = doubleAngles(traceAngles, nNorth) ;  
    %   flip angles if user has flipped axis
    if flag_revX 
        traceAngles2 = reverseAxis(traceAngles2) ; 
    end 
    if flag_revY 
        traceAngles2 = reverseAxis(traceAngles2) ; 
    end 
    nRoseBins = 10 ; 
%   rose plot of segment angles colour-coded by Td 
    f = figure ; 
    roseEqualAreaColourTendency(traceAngles2, nRoseBins, 0, 0, ...
                                    nSigma1, nSigma2, nThetaSigma1, 0, C0, mu, pf) ; 
    title({'Segment angles (equal area), colour-coded by T_d';''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_dilationtendencyrose') ; 

end 

if flag_fracsuscep

    f = figure ; 
    segmentColours = colormap(flipud(jet(100))) ; 
    hold on ; 
    for k = 1:nTraces

        for l = 1:traces(k).nSegments

            %   calculate fracture susceptibility on this segment 
            traces(k).Segment(l).Sf = traces(k).Segment(l).sn - (traces(k).Segment(l).tau - C0) / mu ;                
            iSf = abs(round(((traces(k).Segment(l).Sf-Sfmin)/(Sfmax-Sfmin))*100)) ; 
            if iSf < 1 
                iSf = 1 ; 
            end

            %   draw the segment, colour-coded 
            plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
                  [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                        'LineWidth', 0.75, 'color', segmentColours(iSf, :) ) ;

        end

    end 
    hold off ;
    colormap(segmentColours) ; 
    caxis([Sfmin Sfmax]) ; 
    c = colorbar('southoutside') ; 
    c.Label.String = 'Fracture susceptibility (\DeltaP_f), MPa' ;  
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    title({['Fracture susceptibility \sigma_1=', num2str(nSigma1), ...
            ' MPa, \sigma_2=', num2str(nSigma2), ' MPa, \theta=', num2str(nThetaSigma1), '\circ'];''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_fracsuscepmap') ; 
    
    %   rose plots 
    traceAngles = [ traces.segmentAngle ]' ; 
    %   double the trace angle data over 360 degrees 
    traceAngles2 = doubleAngles(traceAngles, nNorth) ; 
    %   flip angles if user flipped axis
    if flag_revX 
        traceAngles2 = reverseAxis(traceAngles2) ; 
    end 
    if flag_revY 
        traceAngles2 = reverseAxis(traceAngles2) ; 
    end 
    nRoseBins = 10 ; 
    %   rose plot of segment angles colour-coded by normalised Sf 
    f = figure ; 
    roseEqualAreaColourTendency(traceAngles2, nRoseBins, 0, 0, ...
                                nSigma1, nSigma2, nThetaSigma1, 2, C0, mu, pf) ; 
    title({'Segment angles (equal area), colour-coded by S_f';''}) ; 
    caxis([Sfmin Sfmax]) ; 
    
    %   save to file 
    guiPrint(f, 'FracPaQ2D_fracsusceprose') ; 
    
end 

if flag_CSF 

    f = figure ; 
    segmentColours = colormap(jet(100)) ; 
    hold on ; 
    for k = 1:nTraces
        for l = 1:traces(k).nSegments
            if traces(k).Segment(l).tau >= mu * (traces(k).Segment(l).sn - pf) + C0
                iCSF = 90 ; 
            else 
                iCSF = 10 ; 
            end 
            %   draw the segment, colour-coded 
            plot( [ traces(k).Segment(l).Point1(1), traces(k).Segment(l).Point2(1) ]', ...
                  [ traces(k).Segment(l).Point1(2), traces(k).Segment(l).Point2(2) ]', ...
                        'LineWidth', 0.75, 'color', segmentColours(iCSF, :) ) ;
        end 
    end
    hold off ;
    colormap(segmentColours) ; 
%    caxis([1 3]) ; 
    c = colorbar('southoutside') ; 
    c.Label.String = ['Critically Stressed Fractures, \itP\rm_f=', num2str(pf), ' MPa'] ;  
    c.Ticks = [0, 1] ;
    c.TickLabels = {'Non-CSF', 'CSF'} ; 
    axis on equal ; 
    box on ; 
    xlim([xMin xMax]) ; 
    ylim([yMin yMax]) ; 
    set(gca, 'XDir', sXDir) ; 
    set(gca, 'YDir', sYDir) ; 
    xlabel(['X,', sUnits]) ; 
    ylabel(['Y,', sUnits]) ; 
    title({['Critically stressed fractures \sigma_1''=', num2str(nSigma1-pf), ...
            ' MPa, \sigma_2''=', num2str(nSigma2-pf), ' MPa, \theta=', num2str(nThetaSigma1), '\circ'];''}) ; 
    %   save to file 
    guiPrint(f, 'FracPaQ2D_CSFmap') ; 

    %   rose plot 
    traceAngles = [ traces.segmentAngle ]' ; 
    %   double the trace angle data over 360 degrees 
    traceAngles2 = doubleAngles(traceAngles, nNorth) ; 
    %   flip angles if user flipped axis
    if flag_revX 
        traceAngles2 = reverseAxis(traceAngles2) ; 
    end 
    if flag_revY 
        traceAngles2 = reverseAxis(traceAngles2) ; 
    end 
    nRoseBins = 10 ; 
    %   rose plot of segment angles colour-coded by normalised Sf 
    f = figure ; 
    roseEqualAreaColourTendency(traceAngles2, nRoseBins, 0, 0, ...
                            nSigma1, nSigma2, nThetaSigma1, 3, C0, mu, pf) ; 
    title({'Segment angles (equal area), colour-coded by CSF';''}) ; 
    c = colorbar('southoutside') ; 
    c.Label.String = ['Critically Stressed Fractures, \itP\rm_f=', num2str(pf), ' MPa'] ;  
    c.Ticks = [0, 1] ;
    c.TickLabels = {'Non-CSF', 'CSF'} ; 
    
    %   save to file 
    guiPrint(f, 'FracPaQ2D_CSFrose') ; 
    
end 

end 