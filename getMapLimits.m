function [xMin, xMax, yMin, yMax] = getMapLimits(traces)

xMin = 9e32 ; 
yMin = 9e32 ; 
xMax = 0 ; 
yMax = 0 ; 

for i = 1:length(traces)
    
    for j = 1:traces(i).nNodes
        
        if traces(i).Node(j).x < xMin 
            xMin = traces(i).Node(j).x ; 
        end 

        if traces(i).Node(j).x > xMax 
            xMax = traces(i).Node(j).x ; 
        end 

        if traces(i).Node(j).y < yMin 
            yMin = traces(i).Node(j).y ; 
        end 

        if traces(i).Node(j).y > yMax 
            yMax = traces(i).Node(j).y ; 
        end 

    end 
    
end 