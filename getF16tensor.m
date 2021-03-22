function [F16, F16pol] = getF16tensor(lengths, angles, area) 
%   F16 is the (2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2) fabric tensor of Oda
%   F16pol is the polar form of F16 ready for plotting over 0-360 deg

%   2D, 8th rank crack tensor
F16 = zeros(2,2,2,2,2,2,2,2,2,2,2,2,2,2,2,2) ; 
for i = 1:2
    for j = 1:2 
        for k = 1:2 
            for l = 1:2 
                for r = 1:2
                    for s = 1:2 
                        for t = 1:2 
                            for u = 1:2 
                                for a = 1:2
                                    for b = 1:2 
                                        for c = 1:2 
                                            for d = 1:2 
                                                for e = 1:2
                                                    for f = 1:2 
                                                        for g = 1:2 
                                                            for h = 1:2 
                                                                for p = 1:max(size(lengths)) 
                                                                    n(1) = cosd(angles(p)) ; 
                                                                    n(2) = sind(angles(p)) ; 
                                                                    F16(i,j,k,l,r,s,t,u,a,b,c,d,e,f,g,h) = F16(i,j,k,l,r,s,t,u,a,b,c,d,e,f,g,h) + ...
                                                                    ( 1 / area ) * lengths(p)^2 * ...
                                                                    n(i) * n(j) * n(k) * n(l) * ... 
                                                                    n(r) * n(s) * n(t) * n(u) * ... 
                                                                    n(a) * n(b) * n(c) * n(d) * ...  
                                                                    n(e) * n(f) * n(g) * n(h) ; 
                                                                end 
                                                            end 
                                                        end 
                                                    end 
                                                end 
                                            end 
                                        end 
                                    end 
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
F16pol = zeros(1,ninc+1) ; 
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
                                    for a = 1:2 
                                        for b = 1:2 
                                            for c = 1:2 
                                                for d = 1:2 
                                                    for e = 1:2
                                                        for f = 1:2 
                                                            for g = 1:2 
                                                                for h = 1:2 
                                                                    F16pol(ia) = F16pol(ia) + ...
                                                                        F16(i,j,k,l,r,s,t,u,a,b,c,d,e,f,g,h) * ... 
                                                                        v(i) * v(j) * v(k) * v(l) * ...
                                                                        v(r) * v(s) * v(t) * v(u) * ...
                                                                        v(a) * v(b) * v(c) * v(d) * ...
                                                                        v(e) * v(f) * v(g) * v(h) ;
                                                                end
                                                            end 
                                                        end 
                                                    end 
                                                end 
                                            end 
                                        end 
                                    end 
                                end 
                            end                       
                        end 
                    end 
                end 
            end 
        end 
    end 
end 