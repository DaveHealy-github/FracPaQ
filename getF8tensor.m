function [F8, F8pol] = getF8tensor(lengths, angles, area) 
%   F8 is the (2,2,2,2,2,2,2,2) fabric tensor of Oda
%   F8pol is the polar form of F8 ready for plotting over 0-360 deg

%   2D, 8th rank crack tensor
F8 = zeros(2,2,2,2,2,2,2,2) ; 
for i = 1:2
    for j = 1:2 
        for k = 1:2 
            for l = 1:2 
                for r = 1:2
                    for s = 1:2 
                        for t = 1:2 
                            for u = 1:2 
                                for p = 1:max(size(lengths)) 
                                    n(1) = cosd(angles(p)) ; 
                                    n(2) = sind(angles(p)) ; 
                                    F8(i,j,k,l,r,s,t,u) = F8(i,j,k,l,r,s,t,u) + ...
                                        ( 1 / area ) * lengths(p)^2 * ...
                                        n(i) * n(j) * n(k) * n(l) * n(r) * n(s) * n(t) * n(u) ; 
                                end 
                            end 
                        end 
                    end 
                end 
            end
        end
    end
end

ia = 0 ; 
ninc = 360 ; 
F8pol = zeros(1,ninc+1) ; 
for alpha = 0:(2*pi/ninc):2*pi   
    v(1) = cos(alpha) ; 
    v(2) = sin(alpha) ; 
    ia = ia + 1 ; 
    for i = 1:2 
        for j = 1:2 
            for k = 1:2 
                for l = 1:2 
                    for r = 1:2
                        for s = 1:2 
                            for t = 1:2 
                                for u = 1:2 
                                    F8pol(ia) = F8pol(ia) + F8(i,j,k,l,r,s,t,u) * ... 
                                        v(i) * v(j) * v(k) * v(l) * v(r) * v(s) * v(t) * v(u) ;
                                end
                            end 
                        end 
                    end 
                end 
            end 
        end 
    end 
end 