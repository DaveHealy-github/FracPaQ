function [newMap] = newCM(minC, maxC) 

cMap = cmocean('haline', maxC) ;

dataMax = maxC ;
dataMin = minC ;
centerPoint = 1 ;
scalingIntensity = 4 ;

x = 1:length(cMap); 
x = x - (centerPoint-dataMin)*length(x)/(dataMax-dataMin);
x = scalingIntensity * x/max(abs(x));
x = sign(x).* exp(abs(x));
x = x - min(x); x = x*(maxC-1)/max(x)+1; 

newMap = interp1(x, cMap, 1:maxC);

end 