function arc(r, az1, az2)
% arc(r,az1, az2)
% This function draws an arc of a circle
% at a radius r from the origin, from
% az1 to az2 where these are azimuths in
% degrees measured from north
% Written by Gerry Middleton, December 1996
%
%   Modified by Dave Healy
%       February 2017

azinc = 5 ;
az = az1:azinc:az2 ;
rs = r*sin(pi*az/180) ;
rc = r*cos(pi*az/180) ;
plot(rs, rc,'b','LineWidth',2) ;