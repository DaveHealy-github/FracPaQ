function [F4, F4pol] = getF4tensor(lengths, angles, area) 
%   F4 is the (2,2,2,2) fabric tensor of Oda
%   F4pol is the polar form of F4 ready for plotting over 0-360 deg

%   2D, 4th rank crack tensor
F4 = zeros(2,2,2,2) ; 
for i = 1:2
    for j = 1:2 
        for k = 1:2 
            for l = 1:2 
                for p = 1:max(size(lengths)) 
                    n(1) = cosd(angles(p)) ; 
                    n(2) = sind(angles(p)) ; 
                    F4(i,j,k,l) = F4(i,j,k,l) + ( 1 / area ) * lengths(p)^2 * n(i) * n(j) * n(k) * n(l) ; 
                end 
            end
        end
    end
end

ia = 0 ; 
ninc = 360 ; 
F4pol = zeros(1,ninc+1) ; 
for alpha = 0:(2*pi/ninc):2*pi
    v(1) = cos(alpha) ; 
    v(2) = sin(alpha) ; 
    ia = ia + 1 ; 
    for i = 1:2 
        for j = 1:2 
            for k = 1:2 
                for l = 1:2 
                    F4pol(ia) = F4pol(ia) + F4(i,j,k,l) * v(i) * v(j) * v(k) * v(l) ; 
                end 
            end 
        end 
    end 
end 