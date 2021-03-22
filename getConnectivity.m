function [ nY, nX, nI ] = getConnectivity(traces, segments, xMin, yMin, xMax, yMax, ...
                                       nBlocks, flag_revX, flag_revY, ...
                                       numPixelsPerMetre, nPixelsItoY) 

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
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF COnTracesACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.
%
%   Modified by Nikolai Andrianov (DTU, Denmark) - January 2019 
%   Modified by Dave Healy (Aberdeen) - January 2019 
%   Modified by Dave Healy (Aberdeen) - November 2019 

hWait = waitbar(0.2, 'Calculating connectivity nodes...', 'Name', 'I-Y-X connectivity') ;

% Keep a reference to the corresponding trace in segments 
k = 0 ;
for i = 1:length(traces)
    for j = 1:traces(i).nSegments
        k = k + 1 ;
        segmentTrace(k) = i ;
    end
end

% connectivityTraces = true ; 

nY = 0 ; 
nX = 0 ; 
nI = size(traces,2) * 2 ; 

segments = segments(~any(isnan(segments),2),:) ; 

nInt = 0 ; 
epsYnode = nPixelsItoY ; 
disp(['Tolerance for accepting I node = Y node: ', num2str(epsYnode), ' units']) ; 

for i = 1:size(segments,1) 
    
    scanXY = [ segments(i, 1), segments(i, 2), ...
              segments(i, 3), segments(i, 4) ] ; 
    
    if any(isnan(scanXY))
        
        disp('Bad data in segments') ; 
        
    else
        
        intScan = lineSegmentIntersect(scanXY, segments) ; 

        for j = i+1:size(segments,1) 

%             waitbar((i*j)/(size(segments,1)^2), hWait, 'Calculating node coordinates...') ;
            
            % Account for trace intersections only if the segments belong
            % to different traces, and account for all segment intersections
%             if ((connectivityTraces && (segmentTrace(i) ~= segmentTrace(j))) || ~connectivityTraces)
            if segmentTrace(i) ~= segmentTrace(j)
            
                %   check that the scan line is not the same as the matched line 
                if intScan.coincAdjacencyMatrix(1, j) < 1 

                    %   is there an intersection? 
                    if intScan.intAdjacencyMatrix(1, j) > 0

                        nInt = nInt + 1 ; 

                        %   get coords of intersection 
                        xint(nInt) = intScan.intMatrixX(1, j) ; 
                        yint(nInt) = intScan.intMatrixY(1, j) ; 

                        %   if this intersection point is also the end of either line  
                        if ( abs(xint(nInt) - scanXY(1)) < epsYnode && ...
                             abs(yint(nInt) - scanXY(2)) < epsYnode ) 
                            nY = nY + 1 ; 
                            fint(nInt) = 'Y' ;
                        elseif ( abs(xint(nInt) - scanXY(3)) < epsYnode && ...
                                 abs(yint(nInt) - scanXY(4)) < epsYnode )
                            nY = nY + 1 ; 
                            fint(nInt) = 'Y' ; 
                        elseif ( abs(xint(nInt) - segments(j, 1)) < epsYnode && ...
                                 abs(yint(nInt) - segments(j, 2)) < epsYnode )
                            nY = nY + 1 ; 
                            fint(nInt) = 'Y' ; 
                        elseif ( abs(xint(nInt) - segments(j, 3)) < epsYnode && ...
                                 abs(yint(nInt) - segments(j, 4)) < epsYnode )
                            nY = nY + 1 ; 
                            fint(nInt) = 'Y' ; 
                        else 
                            nX = nX + 1 ; 
                            fint(nInt) = 'X' ; 
                        end ; 

                    end ; 

                end ;
            
            end

        end ; 

    end ; 
    
end ; 

nTraces = size(traces,2);
nodeI = zeros(nTraces*2, 2);
nI = size(nodeI, 1) ;
for i = 1:nTraces
    
    % Get the coordinates of I nodes; each end of the trace 
    nNodesTrace = length(traces(i).Node) ; % Number of nodes in this trace
    indI1 = 2 * i - 1 ;
    indI2 = 2 * i ; 
    nodeI(indI1, 1) = traces(i).Node(1).x ;
    nodeI(indI1, 2) = traces(i).Node(1).y ;
    nodeI(indI2, 1) = traces(i).Node(nNodesTrace).x ;
    nodeI(indI2, 2) = traces(i).Node(nNodesTrace).y ;    
    
    %   one end of the trace... 
    dist1 = distancePointEdge([nodeI(indI1,1), nodeI(indI1,2)], segments) ;
    if sum(find(dist1(dist1>0) < epsYnode)) > 0 
        
        distY = distancePoints([nodeI(indI1,1), nodeI(indI1,2)], [xint', yint']) ; 
        if sum(distY(distY<epsYnode)) > 0 
%             nInt = nInt + 1 ; 
%             nY = nY + 1 ; 
%             %   get coords of this I, now a Y 
%             xint(nInt) = nodeI(indI1,1) ; 
%             yint(nInt) = nodeI(indI1,2) ; 
%             fint(nInt) = 'Y' ;
            %   remove this I node from the I list 
            nI = nI - 1 ; 
            nodeI(indI1,1:2) = NaN ; 
        else 
            continue ; 
        end 
        
    end 
    
    %   and the other end of the trace... 
    dist2 = distancePointEdge([nodeI(indI2,1), nodeI(indI2,2)], segments) ;
    if sum(find(dist2(dist2>0) < epsYnode)) > 0 
        
        distY = distancePoints([nodeI(indI2,1), nodeI(indI2,2)], [xint', yint']) ; 
        if sum(distY(distY<epsYnode)) > 0 
%             nInt = nInt + 1 ; 
%             nY = nY + 1 ; 
%             %   get coords of this I, now a Y 
%             xint(nInt) = nodeI(indI2,1) ; 
%             yint(nInt) = nodeI(indI2,2) ; 
%             fint(nInt) = 'Y' ;
            %   remove this I node from the I list 
            nI = nI - 1 ; 
            nodeI(indI2,1:2) = NaN ; 
        else 
            continue ; 
        end 
        
    end 
    
end

disp('Initial I-Y-X node count, after I-node check:') ; 
disp(['I: ', num2str(nI)]) ; 
disp(['Y: ', num2str(nY)]) ; 
disp(['X: ', num2str(nX)]) ; 

%   ONLY run this for when the number of traces < number segments 
%   - i.e. NOT for maps generated by image analysis/Hough transform  
%   correct for extra 'Y' nodes when a trace 'kinks' on intersecting another
%   segment; this is currently 3 'Y' nodes, but should be 1 'X' node
indY = 0 ; 
indX = 0 ; 
if max(size(traces)) <= max(size(segments)) && nInt > 0 

    % Get to the columnwise coordinates
    xint = xint';
    yint = yint';
    Xc = [xint, yint] ;
    
    % Intersection coordinates without duplicates
    [XU, iu, tmp] = unique(Xc, 'stable', 'rows');
    Np = size(XU, 1);
    XU = reshape(XU, Np, 2);

    % Get the number and coordinates of unique X and Y nodes
    nodeType = fint(iu)';
    indX = find(nodeType == 'X') ;
    indY = find(nodeType == 'Y') ;
    nX = length(indX);
    nY = length(indY);
    
end ;

% disp('After removing duplicates and adjusting Y->X:') ; 
% disp(['I: ', num2str(nI)]) ; 
% disp(['Y: ', num2str(nY)]) ; 
% disp(['X: ', num2str(nX)]) ; 

% Replace the original implementation with the one below
% %   also remove any I points that lie on the edge of the area; censoring 
% xMaxr = round(xMax) ; 
% yMaxr = round(yMax) ; 
% for i = 1:size(traces,2) 
% 
%     maxNode = traces(i).nNodes ; 
%     
%     if round(traces(i).Node(1).x) == xMin || round(traces(i).Node(1).x) == xMaxr
%         I = I - 1 ; 
%     elseif round(traces(i).Node(1).y) == yMin || round(traces(i).Node(1).y) == yMaxr
%         I = I - 1 ; 
%     elseif round(traces(i).Node(maxNode).x) == xMin || round(traces(i).Node(maxNode).x) == xMaxr
%         I = I - 1 ; 
%     elseif round(traces(i).Node(maxNode).y) == xMax || round(traces(i).Node(maxNode).y) == yMaxr
%         I = I - 1 ; 
%     else 
%         continue ; 
%     end ; 
%         
% end ; 

% Excluding the I nodes lying on boundaries
ib = find( (nodeI(:,1) == xMin) | (nodeI(:,1) == xMax) | (nodeI(:,2) == yMin) | (nodeI(:,2) == yMax)) ;
Nip = size(nodeI, 1) ;
indI = setdiff( [1:Nip]', ib);
nodeI = [nodeI(indI, 1), nodeI(indI, 2)] ; 

%   remove I nodes that coincide with Y nodes; no double counting 
if sum(indY) > 0
    nodeI = setdiff(nodeI, [XU(indY,1), XU(indY,2)], 'stable', 'rows') ; 
end 
%   remove I nodes that coincide with X nodes; no double counting 
if sum(indX) > 0
    nodeI = setdiff(nodeI, [XU(indX,1), XU(indX,2)], 'stable', 'rows') ; 
end 
nodeIx = nodeI(~isnan(nodeI(:,1)),1) ;
nodeIy = nodeI(~isnan(nodeI(:,2)),2) ;
nodeI = [nodeIx, nodeIy] ; 
nI = size(nodeI,1) ; 

% %   remove Y nodes that coincide with X nodes; no double counting 
% XY = setdiff([XU(indY,1), XU(indY,2)], [XU(indX,1), XU(indX,2)], 'stable', 'rows') ; 
% Y = size(XY,1) ; 
% 
% % %   remove X nodes that coincide with Y nodes; no double counting 
% % XX = setdiff([XU(indX,1), XU(indX,2)], [XU(indY,1), XU(indY,2)], 'stable', 'rows') ; 
% XX = [XU(indX,1), XU(indX,2)] ; 
% X = size(XX,1) ; 
% 
%   remove X nodes that coincide with Y nodes; no double counting 
if sum(indX) > 0 && sum(indY) > 0 
    XY = setdiff([XU(indY,1), XU(indY,2)], [XU(indX,1), XU(indX,2)], 'stable', 'rows') ; 
else 
    XY = [XU(indY,1), XU(indY,2)] ; 
end
nY = size(XY,1) ; 

%   remove Y nodes that coincide with X nodes; no double counting 
if sum(indX) > 0 && sum(indY) > 0 
    XX = setdiff([XU(indX,1), XU(indX,2)], [XU(indY,1), XU(indY,2)], 'stable', 'rows') ; 
else 
    XX = [XU(indX,1), XU(indX,2)] ; 
end 
nX = size(XX,1) ; 

waitbar(0.75, hWait, 'Building maps...') ;

%   node marker map 
f = figure ;
ms = 3 ;   
dx = 5 ; 
hold on ;         
for k = 1:length(traces)

    plot( [ traces(k).Node.x ]', [ traces(k).Node.y ]', 'LineWidth', 0.5, 'Color', 'k') ;

end ; 

if max(size(traces)) <= max(size(segments)) && nInt > 0 
    hi = plot(nodeI(:,1), nodeI(:,2), 'o', 'Color', ...
                                      'b', 'MarkerFaceColor', ...
                                      'b', 'MarkerSize', ms, ...
                                      'DisplayName', 'I') ; 
    hLegend = hi ; 
    if ~isempty(XX)                             
        hx = plot(XX(:,1), XX(:,2), 'o', 'Color', ...
                                    'r', 'MarkerFaceColor', ...
                                    'r', 'MarkerSize', ms, ...
                                    'DisplayName', 'X') ; 
        hLegend = [ hLegend, hx ] ; 
    end 
    %         tind = [1:length(indX)];
    %         text(XU(indX,1)+dx, XU(indX,2), num2str(tind(:)), 'Color', 'r');    
    if ~isempty(XY)
        hy = plot(XY(:,1), XY(:,2), 'o', 'Color', ...
                                    'g', 'MarkerFaceColor', ...
                                    'g', 'MarkerSize', ms, ...
                                    'DisplayName', 'Y') ;
        hLegend = [ hLegend, hy ] ; 
    end 
%             tind = [1:length(indY)];
%             text(XU(indY,1)+dx, XU(indY,2), num2str(tind(:)), 'Color', 'g'); 
    hold off ; 
    %     tind = [1:length(nodeI(:,1))] ;
    %     text(nodeI(:,1)+dx, nodeI(:,2), num2str(tind(:)), 'Color', 'b') ;        
    legend(hLegend, 'Location', 'southoutside', 'Orientation', 'horizontal') ; 
else 
    hi = plot(nodeI(:,1), nodeI(:,2), 'o', 'Color', 'b', 'MarkerFaceColor', 'b', 'MarkerSize', ms, 'DisplayName', 'I') ; 
    hold off ; 
    %     tind = [1:length(nodeI(:,1))] ;
    %     text(nodeI(:,1)+dx, nodeI(:,2), num2str(tind(:)), 'Color', 'b') ;        
    legend([hi], 'Location', 'southoutside', 'Orientation', 'horizontal') ; 
end ; 
grid on ; 
box on ; 
axis equal ; 
xlim([xMin xMax]) ;
ylim([yMin yMax]) ;
if flag_revX
    set(gca, 'XDir', 'reverse') ;
end ;
if flag_revY
    set(gca, 'YDir', 'reverse') ;
end ;
if numPixelsPerMetre > 0
    xlabel('X, metres') ;
    ylabel('Y, metres') ;
else
    xlabel('X, pixels') ;
    ylabel('Y, pixels') ;
end ;
title({'Connectivity node types';['n_I=', num2str(nI), ', n_Y=', num2str(nY), ', n_X=', num2str(nX)]}) ;

%   save to file
guiPrint(f, 'FracPaQ2D_IYXnodes_traces') ;

close(hWait) ;

%   heatmaps of node types 
if xMax-xMin > yMax-yMin
    nyBlocks = nBlocks ; 
    nxBlocks = round( ((xMax-xMin)/(yMax-yMin)) * nBlocks ) ; 
elseif yMax-yMin > xMax-xMin
    nxBlocks = nBlocks ; 
    nyBlocks = round( ((yMax-yMin)/(xMax-xMin)) * nBlocks ) ; 
else
    nxBlocks = nBlocks ; 
    nyBlocks = nBlocks ; 
end ; 
Nxbins = nxBlocks ; 
Nybins = nyBlocks ; 
% [NX, CX] = hist3([XU(indX,1), XU(indX,2)], [Nxbins,Nybins]) ; 
% [NY, CY] = hist3([XU(indY,1), XU(indY,2)], [Nxbins,Nybins]) ; 
if max(size(traces)) <= max(size(segments)) && nInt > 0 
    [NXY, CXY] = hist3([[XU(indX,1); XU(indY,1)], [XU(indX,2); XU(indY,2)]], [Nxbins, Nybins]) ; 
else 
    NXY = 0 ; 
    CXY = 0 ; 
end ; 
[NI, CI] = hist3([nodeI(:,1), nodeI(:,2)], [Nxbins, Nybins]) ; 
maxBar = max([max(max(NXY)), max(max(NI))]) ; 

if max(size(traces)) <= max(size(segments)) && nInt > 0 
    f = figure ;
%     set(gcf, 'PaperPositionMode', 'manual') ;
%     set(gcf, 'PaperUnits', 'centimeters') ;
%     set(gcf, 'PaperPosition', [ 2 2 21 29.7 ]) ;

    imagesc(cell2mat(CXY(1,1)), cell2mat(CXY(1,2)), NXY') ; 
    box on ; 
    axis equal ; 
    ax = gca ; 
    ax.YDir = 'normal' ;
    xlim([xMin xMax]) ;
    ylim([yMin yMax]) ;
    if flag_revX
        set(gca, 'XDir', 'reverse') ;
    end ;
    if flag_revY
        set(gca, 'YDir', 'reverse') ;
    end ;
    if numPixelsPerMetre > 0
        xlabel('X, metres') ;
        ylabel('Y, metres') ;
    else
        xlabel('X, pixels') ;
        ylabel('Y, pixels') ;
    end ;
    c = colorbar('southoutside') ; 
    c.Label.String = 'Number of (X+Y)-nodes' ; 
    title({['(X+Y)-nodes, n_X+n_Y=', num2str(nX+nY)];''}) ;
    cmap = colormap('hot') ; 
    cmap = flipud(cmap) ; 
    colormap(cmap) ; 
    caxis([0 maxBar]) ; 

    %   save to file
    guiPrint(f, 'FracPaQ2D_XYnodes_traces_heat') ;
end ; 

if min(size(NI)) > 1 
    f = figure ;
%     set(gcf, 'PaperPositionMode', 'manual') ;
%     set(gcf, 'PaperUnits', 'centimeters') ;
%     set(gcf, 'PaperPosition', [ 2 2 21 29.7 ]) ;
    
%     [xg, yg] = meshgrid(cell2mat(CI(1,1)), cell2mat(CI(1,2))) ; 
%     [xq, yq] = meshgrid(linspace(min(min(cell2mat(CI(1,1)))), max(max(cell2mat(CI(1,1)))), newpoints), ...  
%                         linspace(min(min(cell2mat(CI(1,2)))), max(max(cell2mat(CI(1,2)))), newpoints)) ; 
%     NIinterp = interp2(xg, yg, NI', xq, yq, 'cubic') ; 
%     contourf(xq, yq, NIinterp, nLevels) ; 
    imagesc(cell2mat(CI(1,1)), cell2mat(CI(1,2)), NI') ; 
    box on ; 
    axis equal ; 
    ax = gca ; 
    ax.YDir = 'normal' ;
    xlim([xMin xMax]) ;
    ylim([yMin yMax]) ;
    if flag_revX
        set(gca, 'XDir', 'reverse') ;
    end ;
    if flag_revY
        set(gca, 'YDir', 'reverse') ;
    end ;
    if numPixelsPerMetre > 0
        xlabel('X, metres') ;
        ylabel('Y, metres') ;
    else
        xlabel('X, pixels') ;
        ylabel('Y, pixels') ;
    end ;
    c = colorbar('southoutside') ; 
    c.Label.String = 'Number of I-nodes' ; 
    title({['I-nodes, n_I=', num2str(nI)];''}) ;
    cmap = colormap('hot') ; 
    cmap = flipud(cmap) ; 
    colormap(cmap) ; 
    caxis([0 maxBar]) ; 

    %   save to file
    guiPrint(f, 'FracPaQ2D_Inodes_traces_heat') ;
end ; 

disp('After removing boundary I nodes, duplicate X and Y nodes:') ; 
disp(['I: ', num2str(nI)]) ; 
disp(['Y: ', num2str(nY)]) ; 
disp(['X: ', num2str(nX)]) ; 

end 