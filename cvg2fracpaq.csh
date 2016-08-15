#!/bin/csh
#####################################################################################
# Shell script to convert a scalable vector graphics file into a text file
# suitable for input into Dave Healy's FracPaQ software
#
# On any Linux PC or Mac, copy this file then make executable by typing:
# chmod a+x cvg2fracpaq.csh at the command prompt
#
# then place the SVG file in the same folder as cvg2fracpaq.csh, change the filenames
# below and type cvg2fracpaq.csh at the command prompt and hit enter.
# 
# Written by: D. Cornwell 
# Date: 12/9/14
#####################################################################################
############### CHANGE THE FILENAMES BELOW ##########################################

set infile = 'ThinSection_H12Z.svg'
set outfile = 'ThinSection_H12Z.txt'

############### NO CHANGES BELOW THIS LINE ##########################################
echo "SVG file: "$infile" has been chosen"
# Create a new file with just the lines from the .svg with the string "line" in them
grep 'line' $infile >! lineinfo

# Search in <lineinfo> file for either polyline or line (can add more if necessary)
# then set quotes as the separator and output relevant fields
awk -F'"' '/<polyline/ {print $4} /<line / {print $4,$6,$8,$10}' lineinfo >! tmpfile

# Change spaces to commas
awk '{gsub(/ /,",");print}' tmpfile >! tmpfile2

# Remove last comma in some of the lines and create the output file
sed 's/,$//' tmpfile2 >! $outfile
echo "FracPaQ file: "$outfile" has been created"

# Clean up
\rm lineinfo tmpfile tmpfile2
