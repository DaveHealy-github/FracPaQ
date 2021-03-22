function [F2, F2pol] = getF2tensor(lengths, angles, area) 
%   F2 is the (2,2) fabric tensor of Oda
%   F2pol is the polar form of F2 ready for plotting over 0-360 deg

%   2D, 2nd rank crack tensor
F2 = zeros(2,2) ; 
for i = 1:2
        
    for j = 1:2 
        
        for p = 1:max(size(lengths)) 

            n(1) = cosd(angles(p)) ; 
            n(2) = sind(angles(p)) ; 
    
            F2(i,j) = F2(i,j) + ( 1 / area ) * lengths(p)^2 * n(i) * n(j) ; 

        end
        
    end
    
end

ia = 0 ; 
ninc = 360 ; 
F2pol = zeros(1,ninc+1) ; 
for alpha = 0:(2*pi/ninc):2*pi
    
    v(1) = cos(alpha) ; 
    v(2) = sin(alpha) ; 
    ia = ia + 1 ; 
    
    for i = 1:2 
        for j = 1:2 
            F2pol(ia) = F2pol(ia) + F2(i,j) * v(i) * v(j) ; 
        end 
    end 
    
end 