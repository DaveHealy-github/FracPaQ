function newCM(minC, maxC) 

close all ; 

cMap = parula(256) ;
dataMax = 192 ;
dataMin = 1 ;
centerPoint = 1 ;
scalingIntensity = 5 ;
x = 1:length(cMap); 
x = x - (centerPoint-dataMin)*length(x)/(dataMax-dataMin);
x = scalingIntensity * x/max(abs(x));
x = sign(x).* exp(abs(x));
x = x - min(x); x = x*511/max(x)+1; 
newMap = interp1(x, cMap, 1:512);

load cape;

figure; 
imagesc(X);
colorbar ; 

figure ; 
imagesc(X); 
colormap(newMap);
colorbar ; 

figure ; 
hist(x) ; 

end 