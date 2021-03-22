function rc = convertSVG2txt_colour(fName) 
%   convertSVG2txt.m 
%       reads in .SVG (version 1.1) file and writes out .txt file of (x,y) nodes  
%       
%   David Healy
%   February 2017 
%   d.healy@abdn.ac.uk 
%
%   Modified:
%   March 2021
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

disp('Converting .svg file to .txt file...(version 2)') ; 

%   read in the text file, splitting lines on SVG tag end tokens '>'
[sRawLines, result] = readtext(fName, '>', '', '', 'textual') ; 
sRawLines = char(sRawLines) ; 
nRawLines = result.rows ; 
sPathLines = cell(nRawLines,1) ;  
sPolyLines = cell(nRawLines,1) ;  
sLines = cell(nRawLines,1) ;  

iPoly = 0 ; 
iLine = 0 ; 
iPath = 0 ; 
fPoly = 0 ; 
fLine = 0 ; 
fPath = 0 ; 

%   loop through each line (svg tag)
for i = 1:nRawLines 
    
    sThisLine = sRawLines(i, :) ; 
    
    %   is this a <poly or <line tag? 
    if contains(sThisLine, '<poly')
        fPoly = 1 ; 
        fLine = 0 ;
        fPath = 0 ; 
        iPoly = iPoly + 1 ; 
%         disp('Starting a <polyline ...') ; 
    end 

    if contains(sThisLine, '<line')
        fLine = 1 ; 
        fPoly = 0 ; 
        fPath = 0 ; 
        iLine = iLine + 1 ; 
%         disp('Starting a <line ...') ; 
    end 
        
    if contains(sThisLine, '<path')
        fPath = 1 ;
        fPoly = 0 ; 
        fLine = 0 ; 
        iPath = iPath + 1 ; 
%         disp('Found a <path ...') ; 
    end
    
    if contains(sThisLine, '</g')
        fPoly = 0 ; 
        fLine = 0 ; 
        fPath = 0 ; 
%         disp('Found a </g ...') ; 
        continue ;
    end
    
    %   is this the end of a tag line?
    if strcmp(sThisLine(end), '/')
    
        %   if building a path, finish it 
        if fPath 
            sPathLines(iPath,1) = strcat(sPathLines(iPath,1), ',', cellstr(sThisLine)) ; 
        end 
        
        %   if building a polyline, finish it 
        if fPoly 
            sPolyLines(iPoly,1) = strcat(sPolyLines(iPoly,1), ',', cellstr(sThisLine)) ; 
        end 
        
        %   if building a line, finish it 
        if fLine  
            sLines(iLine,1) = strcat(sLines(iLine,1), ',', cellstr(sThisLine)) ; 
        end
        
        %   else reset & jog on 
        fPoly = 0 ; 
        fLine = 0 ; 
        fPath = 0 ; 
       
    else
        
        if contains(sThisLine, '</svg')
            continue ; 
        end 
        
        if contains(sThisLine, '</g')
            continue ; 
        end 
        
        %   if building a path, add to it 
        if fPath 
            sPathLines(iPath,1) = strcat(sPathLines(iPath,1), ',', cellstr(sThisLine)) ; 
        end 
        
        %   if building a polyline, add to it 
        if fPoly 
            sPolyLines(iPoly,1) = strcat(sPolyLines(iPoly,1), ',', cellstr(sThisLine)) ; 
        end 
        
        %   if building a line, add to it 
        if fLine  
            sLines(iLine,1) = strcat(sLines(iLine,1), ',', cellstr(sThisLine)) ; 
        end 
        
    end
    
end

disp(['Read ', num2str(nRawLines), ' lines']) ;
disp(['Built ', num2str(iPath), ' paths']) ;
disp(['Built ', num2str(iPoly), ' polylines']) ;
disp(['Built ', num2str(iLine), ' lines']) ;

sNewPathLines = sPathLines(1:iPath,1) ; 
sNewPolyLines = sPolyLines(1:iPoly,1) ; 
sNewLines = sLines(1:iLine, 1) ; 

%   find how many colours 
sAllLines = [ sNewPathLines ; sNewPolyLines ; sNewLines ] ;
iC = 0 ; 
sAllColours = cell(max(size(sAllLines)), 1) ; 
for i = 1:length(sAllLines)
    
    if iscellstr(sAllLines(i,:))
        sThisLine = char(sAllLines(i,:)) ; 
    else
        continue ; 
    end
    
    %   save the line colour 
    iC = iC + 1 ; 
    if contains(sThisLine, 'stroke=')
        iColour = strfind(sThisLine, 'stroke="#') + 9 ; 
    end 
    if contains(sThisLine, 'stroke:')
        iColour = strfind(sThisLine, 'stroke:#') + 8 ; 
    end 
    sAllColours(iC) = { sThisLine(iColour:iColour+5) } ; 
    
end

%   just get the unique colours 
sAllColours = upper(unique(sAllColours)) ; 
sAllColours(strcmp('',sAllColours)) = [] ;
if isempty(sAllColours) 
    nAllColours = 1 ; 
else 
    nAllColours = length(sAllColours) ; 
end 

if nAllColours < 2
    fNewName = [ fName(1:end-4), '_converted.txt' ] ; 
    fID(1) = fopen(fNewName, 'w') ; 
else
    %   open one file per colour
    fID = zeros(nAllColours,1) ; 
    for i = 1:nAllColours
        fNewName = [ fName(1:end-4), '_colour', char(sAllColours(i)), '_converted.txt' ] ; 
        fID(i) = fopen(fNewName, 'w') ; 
    end
end

%   loop through pathlines extracting (x,y) coordinate pairs 
for i = 1:iPath 
    
    if iscellstr(sNewPathLines(i,:))
        sThisLine = char(sNewPathLines(i,:)) ; 
    else
        continue ; 
    end 
    lThisLine = length(sThisLine) ; 
    
    %   check we have the ONLY valid format:
    %       d="M x1,y1 x2,y2 x3,y3 ...xn,yn"
    %   1. must be upper case M - i.e., absolute position coords, not
    %   relative 
    %   2. no other alphabetic characters (i.e. SVG commands) allowed 
    %   inside the double quotes
    if contains(sThisLine, 'M') 
        
        %   find which colour file 
        if contains(sThisLine, 'stroke=')
            iColour = strfind(sThisLine, 'stroke="#') + 9 ; 
        end 
        if contains(sThisLine, 'stroke:')
            iColour = strfind(sThisLine, 'stroke:#') + 8 ; 
        end 
        if isempty(iColour)
            sColour = '000000' ; 
            iColourFile = 1 ; 
        else 
            sColour = upper(sThisLine(iColour:iColour+5)) ; 
            iColourFile = find(~cellfun('isempty', strfind(sAllColours, sColour))) ; 
        end 
        
        %   find points 
        iS = strfind(sThisLine, 'd="M') ; 
        iStartPoints = iS(1) + length('d="M') ; 
        iEndPoints = max(strfind(sThisLine, 'id')) - 3 ; 
        sPoints = sThisLine(iStartPoints:iEndPoints) ; 

        %   can only handle <path tags with M(ove) command; filter out any
        %   lines with other commands, e.g., Bezier curves etc. 
        SVG_cmd_pattern = ["A", "C", "H", "L", "Q", "V", "S", "T" "Z"] ; 
        if contains(upper(sPoints), SVG_cmd_pattern) 
            disp('***Error: SVG <path has non-M command. FracPaQ cannot read this line, skipping') ; 
            disp(sPoints) ; 
            continue ; 
        else 
            %   strip out (x,y) pairs 
            nPathPoints = str2num(sPoints) ;
            for j = 1:length(nPathPoints)
                %   write to the colour file 
                fprintf(fID(iColourFile), '%12.8f\t', nPathPoints(j)) ; 
            end  
            if i <= iPath && ~isempty(nPathPoints)  
                fprintf(fID(iColourFile), '\r\n') ; 
            end  
        end 
        
    else
        continue ; 
    end
    
end 

%   loop through polylines extracting (x,y) coordinate pairs 
for i = 1:iPoly 
    
    if iscellstr(sNewPolyLines(i,:))
        sThisLine = char(sNewPolyLines(i,:)) ; 
    else
        continue ; 
    end 
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
        end 

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
        end  
        if i <= iPoly && ~isempty(nPolyPoints)  
            fprintf(fID(iColourFile), '\r\n') ; 
        end  
    end 
    
end 

%   loop through lines extracting (x,y) coordinate pairs 
for i = 1:iLine 
    
    if iscellstr(sNewLines(i,:)) 
        sThisLine = char(sNewLines(i,:)) ; 
    else
        continue ; 
    end 
    
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
        end 

        %   find points 
        ix1 = strfind(sThisLine, 'x1="') + 4 ; 
        iy1 = strfind(sThisLine, 'y1="') + 4 ; 
        ix2 = strfind(sThisLine, 'x2="') + 4 ; 
        iy2 = strfind(sThisLine, 'y2="') + 4 ;
        fy2 = 1 ; 
        if isempty(iy2)
            iy2 = strfind(sThisLine, 'y2= "') + 5 ;
            fy2 = 0 ; 
        end 

        x1 = str2double(sThisLine(ix1:iy1-7)) ; 
        y1 = str2double(sThisLine(iy1:ix2-7)) ; 
        if fy2 
            x2 = str2double(sThisLine(ix2:iy2-7)) ; 
        else 
            x2 = str2double(sThisLine(ix2:iy2-8)) ; 
        end 
        y2 = str2double(deblank(sThisLine(iy2:max(strfind(sThisLine, '"'))-1))) ; 

        %   write to the colour file 
        if i < iLine
            fprintf(fID(iColourFile), '%12.8f\t%12.8f\t%12.8f\t%12.8f\r\n', x1, y1, x2, y2) ; 
        else
            fprintf(fID(iColourFile), '%12.8f\t%12.8f\t%12.8f\t%12.8f', x1, y1, x2, y2) ; 
        end 
    end 

end  

%   clean up and quit 
for i = 1:nAllColours
    fclose(fID(i)) ;
end 
infColourFiles = dir('*_converted.txt') ; 
nDel = 0 ; 
for i = 1:max(size(infColourFiles))
    if infColourFiles(i).bytes == 0 
        sFilename = char(infColourFiles(i).name) ; 
        delete(sFilename) ; 
        nDel = nDel + 1 ; 
    end 
end 

if iPath + iPoly + iLine > 0 
    rc = nAllColours - nDel ;
else
    rc = 0 ; 
end 

end