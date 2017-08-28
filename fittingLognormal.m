function [mu,sigma,xmin3,y,z4,HpercentLN,PpercentLN]=fittingLognormal(x,uc,lc,sCol)

%% [mu,sigma,xmin3,HpercentLN,PpercentLN]=fittingLognormal(x)
% Author: Roberto Emanuele Rizzo (rerizzo@abdn.ac.uk)
% Aberdeen April-May 2015
% This function uses a Maximum Likelihood Estimator (MLE) in order to fit a
% Lognormal distribution for a discrete set of empirical data. Through the
% MLE method, the function estimates the  parameters 'mu' and 'sigma' based on
% the finding of a value for the lower bound (xmin) of an lognormal
% behaviour in the data.

%% Notes
% fittingLognormal(x) estimates 'mu' and 'sigma' according to the formulations of
% the Maximum Likelihood as: µ= ?log(x)/n and sigma=?(?(log(x)-µ)/n),
% respectively.
% 'x' is a vector of empirical data which is supposed to follow a power law
% distribution like p(x)= 1/(sigma?2?x)e^-(ln(x)-µ)^2/(2sigma^2)
% The fitting is done as follwos:
% (1) For each possible choice of xmin, the lambda value is estimanted via
% the MLE, and the goodness-of-fit is calculated (as D);
% (2) The value that minimises D is then choosen as the best estimate for
% xmin.

% The function 'fittingLognormal' uses two other functions: 
% (1) KStestLogNorm --> which performs a K-S test between the empirical
% distrubution and the theoretical distrution obtained using the estimated 
% 'xmin', 'mu', and 'sigma';
% (2) PlotLogNorm --> which plots on a log-linear axes both the curve for the
% empirical data and the estimanted distrution.

%% Inputs
% 'x'---> data set
% 'uc'and 'lc'---> Cut off a cenrtain percentage from the beginnig ('uc') 
% or the end ('lc') of the data set. Default values are 0% cut-off.
%% Outputs
% 'mu'---> as MLE of the scaling parameter
% 'sigma'---> as MLE of the scaling parameter
% 'xmin3'---> the estimate of the lower bound of the exponential behaviour.

%% Copyright
% Permission is hereby granted, free of charge, to any person obtaining a
% copy of this software and associated documentation files (the
% "Software"), to deal in the Software without restriction, including
% without limitation the rights to use, copy, modify, merge, publish,
% distribute, sublicense, and/or sell copies of the Software, and to permit
% persons to whom the Software is furnished to do so, subject to the
% following conditions:
% 
% The above copyright notice and this permission notice shall be included
% in all copies or substantial portions of the Software.
% 
% THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
% OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
% MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN
% NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
% DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
% OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
% USE OR OTHER DEALINGS IN THE SOFTWARE.

%% Command line parameters

if exist('uc','var')==0 || uc==0
    uppercut=1;
else
    uppercut=ceil(uc*length(x)/100);
end ; 

if exist('lc','var')==0 || lc==0
    lowercut=0;
else
    lowercut=ceil(lc*length(x)/100);
end ; 


%% Estimate 'xmin', 'mu', 'sigma'

% Reshape the input vector, making sure that 'x' is a one column vector
x = reshape(x,numel(x),1);
x=sort(x);
y=x(uppercut:(end-lowercut));

% Avoid repetitions searching all over unique values of the data set
xmins=unique(y);

dat3=zeros(size(xmins));

% Sort the data in ascending order
z4=sort(x);

% Estimate 'mu' and 'sigma^2' using directly the MLE
for i=1:length(xmins)
    xmin3=xmins(i); % choose the next xmin candidate
   % z5=z4(z4>=xmin3);  % truncate the data below this xmin
    
    n=length(z4);
 
    mu = sum(log(z4))/length(z4);
    
    sigma2 = sum((log(z4)-mu).^2)/length(z4);
    
    cx3 = (n:-1:1)'./n; %Construct the empirical C.d.f.
    
    cf3 = (1/2).*erfc(-(log(z4)-mu)/(sqrt(sigma2)*sqrt(2))); % construct the theoretical C.d.f.
    
    dat3(i) = max(abs(cf3-cx3));
   
end

% Find the smallest D value
D3 = min(dat3(dat3>0));

% Find the corrisponding xmin value
xmin3=xmins(find(dat3==D3,1,'first'));

z4=x(x>=xmin3);
z4=sort(z4);
n=length(z4);

% Get the corrisponding mu and sigma estimates
mu = sum(log(z4))/length(z4);

sigma2 = sum((log(z4)-mu).^2)/length(z4);

sigma = sqrt(sigma2);

% Call the function KStestLogNorm
[HpercentLN,PpercentLN]=KStestLogNorm(z4,n,mu,sigma);
disp(' ') ; 
disp('Probability of Log-Normal distributed lengths...') ; 
disp(['Log-Normal Null hypothesis percentage: ', num2str(HpercentLN), '%']) ; 
disp(['Probability of lengths being Log-Normal distributed: ', num2str(PpercentLN), '%']) ;

% Call the function which plots the sorted empirical data and the
% theoretical curve obtained using the MLE for 'xmin', 'mu', 'sigma'
[c3,cn3]=PlotLogNorm(x,y,z4,mu,sigma,xmin3,sCol);

disp(' ') ; 
disp('Log-Normal statistical parameters...') ;
disp(['mu: ', num2str(mu)]) ; 
disp(['sigma: ', num2str(sigma)]) ;

end 