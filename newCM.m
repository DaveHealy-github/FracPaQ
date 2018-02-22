function [newMap] = newCM(minC, maxC) 

dataMax = maxC ;
dataMin = minC ;
centerPoint = ( maxC - minC ) / 2 ;
scalingIntensity = 4 ;

if maxC > 10 
    cMap = cmocean('haline', maxC) ;
    x = minC:size(cMap,1) ; 
    x = x - (centerPoint-dataMin) * length(x) / (dataMax-dataMin) ;
    x = scalingIntensity * x / max(abs(x)) ;
    x = sign(x).* exp(abs(x)) ;
    x = x - min(x) ; 
    x = x * (maxC-1) / max(x) + 1 ; 
    newMap = interp1(x, cMap, 1:maxC);
else 
    cMap = cmocean('haline', maxC*10) ;
    x = minC:size(cMap,1) ; 
    x = x - (centerPoint-dataMin) * length(x) / (dataMax-dataMin) ;
    x = scalingIntensity * x / max(abs(x)) ;
    x = sign(x).* exp(abs(x)) ;
    x = x - min(x) ; 
    x = ( x * (maxC-1) / max(x) + 1 ) ;  
    newMap = interp1(x, cMap, minC:0.1:maxC);
end ; 

end 