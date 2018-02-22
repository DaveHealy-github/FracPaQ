% X. Ogaya & J. Alcalde, Barcelona Feb 2017.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Move 2 FraqPaQ
% Script to convert sets of fractures exported from Move into FraqPac format.

%Instructions:

% In Move:
% -Select target objects -> right click -> "export as ascii"
% -Select the three attributes (X, Y and Z column); use Tab as separator -> click "Next"
% -Select the appropriate coordinate options (e.g. metres, Z=elevation or depth etc).
% -Select "Insert line break between objects".
% -Don't select "write headers", or delete them manually.
% -Select name and file location.

% In Matlab (this script):
% Modify ONLY -> INPUT and OUTPUT files & Column location
% -Define the position of columns X, Y, Z (i.e. column 1, 2 or 3).
% -Select the path to the INPUT file in "name".
% -Select the location and name of the OUTPUT in "outname".

% The output file should be ready to be input into FracPaQ

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;
close all;
%=====================================================================
% MODIFY THESE ACCORDINGLY
% INPUT and OUTPUT files:
name='DAT/S2.dat';
outname='S2_out.txt';
% Column location
Xcolumn=1;
Ycolumn=3;
%=====================================================================
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Reading:
fid = fopen(name,'r');
count = 0;
while ~feof(fid)
    line = fgetl(fid);
    count = count + 1;
end
fclose(fid);

num=count-1;
fault=1;
p=1;

    fid=fopen(name);
    line=fgetl(fid); % header
   
    for m=1:num
          line=fgetl(fid);
          kk1=sscanf(line,'%lf %lf %lf');
   if numel(kk1)==0
       fault=fault+1;
       num_coord(fault-1)=p-1;
       p=1;
   else 
   X(fault,p)=kk1(Xcolumn);
   Y(fault,p)=kk1(Ycolumn);
   p=p+1;
    end
    end
num_coord(fault)=p-1;
fault=fault-1;

% Fault X: x1 y1 x2 y2 x3 y3 [...]
for F=1:fault;
          pX=1;
    for i=1:2:2*num_coord(F)
          pY=1;
        for j=2:2:2*num_coord(F)
    coord(F,i)=X(F,pX);
    coord(F,j)=Y(F,pY);
    pY=pY+1;
        end
            pX=pX+1;
    end
end

    
% Writing output file: Exporting new data file
outf=fopen(outname, 'w');

for F=1:fault;
          pX=1;
    for i=1:2:2*num_coord(F)
          pY=1;
        for j=2:2:2*num_coord(F)
    coord(F,i)=X(F,pX);
    coord(F,j)=Y(F,pY);
    pY=pY+1;
        end
            pX=pX+1;
    end
    fprintf(outf, '%1.4f\t', coord(F,1:2*num_coord(F)));
    fprintf(outf, '\n');
end
