function rc = convertSVG2txt_colour(fName) 
%   convertSVG2txt.m 
%       reads in .SVG (version 1.1) file and writes out .txt file of (x,y) nodes  
%       
%   David Healy
%   February 2017 
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

rc = 0 ; 

disp('Converting .svg file to .txt file...') ; 

% fName = 'ThinSection_H12Z.svg' ; 
[sRawLines, result] = readtext(fName, '>', '', '', 'textual') ; 

sRawLines = char(sRawLines) ; 
nRawLines = result.rows ; 

sPolyLines = cell(nRawLines,1) ;  
sLines = cell(nRawLines,1) ;  

fVersion = 0 ; 
iPoly = 0 ; 
iLine = 0 ; 
fPoly = 0 ; 
fLine = 0 ; 
fPath = 0 ; 

for i = 1:nRawLines 
    
    sThisLine = sRawLines(i, :) ; 
    
    %   find the SVG version, and print it 
    if ~fVersion
        iVersion = strfind(sThisLine, '<svg version') ; 
        if iVersion > 0 
            disp(sThisLine(iVersion+1:19)) ; 
            fVersion = 1 ; 
        end ; 
    end ;        
    
    %   is this a <poly or <line tag? 
    if strfind(sThisLine, '<poly')
        fPoly = 1 ; 
        fLine = 0 ; 
        iPoly = iPoly + 1 ; 
%         disp('Starting a <polyline ...') ; 
    end ; 

    if strfind(sThisLine, '<line')
        fLine = 1 ; 
        fPoly = 0 ; 
        iLine = iLine + 1 ; 
%         disp('Starting a <line ...') ; 
    end ; 
        
    if strfind(sThisLine, '<path')
        fPath = 1 ;
        fPoly = 0 ; 
        fLine = 0 ; 
%         disp('Found a <path ...') ; 
        continue ;
    end ; 
    
    if strfind(sThisLine, '</g')
        fPoly = 0 ; 
        fLine = 0 ; 
%         disp('Found a </g ...') ; 
        continue ;
    end ; 
    
    %   is this the end of a line?
    if strcmp(sThisLine(end), '/')
    
        if fPath 
            fPath = 0 ; 
            continue ; 
        end ; 
        
        %   if building a polyline, finish it 
        if fPoly 
            sPolyLines(iPoly,1) = strcat(sPolyLines(iPoly,1), ',', cellstr(sThisLine)) ; 
        end ; 
        %   if building a line, finish it 
        if fLine  
            sLines(iLine,1) = strcat(sLines(iLine,1), ',', cellstr(sThisLine)) ; 
        end ; 
        
        %   else reset & jog on 
        fPoly = 0 ; 
        fLine = 0 ; 
       
    else
        
        if strfind(sThisLine, '</svg')
            continue ; 
        end ; 
        
        if strfind(sThisLine, '</g')
            continue ; 
        end ; 
        
        %   if building a polyline, add to it 
        if fPoly 
            sPolyLines(iPoly,1) = strcat(sPolyLines(iPoly,1), ',', cellstr(sThisLine)) ; 
        end ; 
        
        %   if building a line, add to it 
        if fLine  
            sLines(iLine,1) = strcat(sLines(iLine,1), ',', cellstr(sThisLine)) ; 
        end ; 
        
    end ; 
    
end ;

disp(['Read ', num2str(nRawLines), ' lines']) ;
disp(['Built ', num2str(iPoly), ' polylines']) ;
disp(['Built ', num2str(iLine), ' lines']) ;

sNewPolyLines = sPolyLines(1:iPoly,1) ; 
sNewLines = sLines(1:iLine, 1) ; 

%   find how many colours 
sAllLines = [ sNewPolyLines ; sNewLines ] ;
iC = 0 ; 
for i = 1:length(sAllLines)
    
    if iscellstr(sAllLines(i,:))
        sThisLine = char(sAllLines(i,:)) ; 
    else
        continue ; 
    end ; 
    
    %   find which colour file
    iC = iC + 1 ; 
    iColour = strfind(sThisLine, 'stroke="#') + 9 ; 
    sAllColours(iC) = { sThisLine(iColour:iColour+5) } ; 
    
end ; 

%   just get the unique colours 
sAllColours = unique(sAllColours) ; 
sAllColours(strcmp('',sAllColours)) = [] ;
if isempty(sAllColours) 
    nAllColours = 1 ; 
else 
    nAllColours = length(sAllColours) ; 
end ; 
% disp(sAllColours) ; 
% disp(nAllColours) ;

if nAllColours < 2

    fNewName = [ fName(1:end-4), '_converted.txt' ] ; 
    fID(1) = fopen(fNewName, 'w') ; 
%     disp(fNewName) ; 
%     disp(fID(1)) ; 
    
else
    
    %   open one file per colour
    for i = 1:nAllColours
        fNewName = [ fName(1:end-4), '_colour', char(sAllColours(i)), '_converted.txt' ] ; 
        fID(i) = fopen(fNewName, 'w') ; 
%         disp(fNewName) ; 
%         disp(fID(i)) ; 
    end ; 
    
end ; 

%   loop through polylines extracting (x,y) coordinate pairs 
for i = 1:iPoly 
    
    if iscellstr(sNewPolyLines(i,:))
        sThisLine = char(sNewPolyLines(i,:)) ; 
    else
%         disp(sNewPolyLines(i,:)) ;
        continue ; 
    end ; 
    lThisLine = length(sThisLine) ; 
    
    if lThisLine > 20 
        %   find which colour file 
        iColour = strfind(sThisLine, 'stroke="#') + 9 ; 
        if isempty(iColour)
            sColour = '000000' ; 
            iColourFile = 1 ; 
        else 
            sColour = sThisLine(iColour:iColour+5) ; 
    %     disp(sThisLine) ; 
    %     disp(sColour) ; 
            iColourFile = find(~cellfun('isempty', strfind(sAllColours, sColour))) ; 
        end ; 

        %   find points 
        iS = strfind(sThisLine, 'points="') ; 
        iStartPoints = iS(1) + length('points="') ; 
        iEndPoints = lThisLine - 2 ; 
        sPoints = sThisLine(iStartPoints:iEndPoints) ; 

        %   strip out (x,y) pairs 
        nPolyPoints = str2num(sPoints) ;
        for j = 1:length(nPolyPoints)
            %   write to the colour file 
            fprintf(fID(iColourFile), '%12.8f\t', nPolyPoints(j)) ; 
        end ; 
        if i <= iPoly && ~isempty(nPolyPoints)  
            fprintf(fID(iColourFile), '\r\n') ; 
        end ; 
    end ; 
    
end ; 

%   loop through lines extracting (x,y) coordinate pairs 
for i = 1:iLine 
    
    if iscellstr(sNewLines(i,:)) 
        sThisLine = char(sNewLines(i,:)) ; 
    else
        continue ; 
    end ; 
    
    lThisLine = length(sThisLine) ; 

    if lThisLine > 20 
        %   find which colour file 
        iColour = strfind(sThisLine, 'stroke="#') + 9 ; 
        if isempty(iColour)
            sColour = '000000' ; 
            iColourFile = 1 ; 
        else 
            sColour = sThisLine(iColour:iColour+5) ; 
            iColourFile = find(~cellfun('isempty', strfind(sAllColours, sColour))) ; 
        end ; 
%         disp(sThisLine) ; 
%         disp(sColour) ; 
%         disp(iColourFile) ; 
%         disp(fID(iColourFile)) ; 

        %   find points 
        ix1 = strfind(sThisLine, 'x1="') + 4 ; 
        iy1 = strfind(sThisLine, 'y1="') + 4 ; 
        ix2 = strfind(sThisLine, 'x2="') + 4 ; 
        iy2 = strfind(sThisLine, 'y2="') + 4 ;
        fy2 = 1 ; 
        if isempty(iy2)
            iy2 = strfind(sThisLine, 'y2= "') + 5 ;
            fy2 = 0 ; 
        end ; 

        x1 = str2double(sThisLine(ix1:iy1-7)) ; 
        y1 = str2double(sThisLine(iy1:ix2-7)) ; 
        if fy2 
            x2 = str2double(sThisLine(ix2:iy2-7)) ; 
        else 
            x2 = str2double(sThisLine(ix2:iy2-8)) ; 
        end ; 
        y2 = str2double(deblank(sThisLine(iy2:max(strfind(sThisLine, '"'))-1))) ; 

        %   write to the colour file 
        if i < iLine
            fprintf(fID(iColourFile), '%12.8f\t%12.8f\t%12.8f\t%12.8f\r\n', x1, y1, x2, y2) ; 
        else
            fprintf(fID(iColourFile), '%12.8f\t%12.8f\t%12.8f\t%12.8f', x1, y1, x2, y2) ; 
        end ; 
    end ; 

end ;  

for i = 1:nAllColours
    fclose(fID(i)) ;
end ; 

if iPoly + iLine > 0 
    rc = nAllColours ;
else
    rc = 0 ; 
end ; 

end