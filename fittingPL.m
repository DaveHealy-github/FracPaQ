function [alpha,xmin,y,z,HpercentPL,PpercentPL]=fittingPL(x,uc,lc,sCol,finite)

%% [alpha,xmin,z,HpercentPL,PpercentPL]=fittingPL(x)
% Author: Roberto Emanuele Rizzo (rerizzo@abdn.ac.uk)
% Aberdeen April-May 2015
% This function uses a Maximum Likelihood Estimator (MLE) in order to fit a
% Power Law distribution for a discrete set of empirical data. Through the
% MLE method, the function estimates the scaling parameters 'alpha' based on
% the finding of a value for the lower bound (xmin) of a power law
% behaviour in the data.
% References from: M.E.J. Newman, "Power Law, Pareto distributions and 
% Zip's law", 2006; A. Clauset et al., "Power Law distribution of Empirical
% data", 2007.

%% Notes
% fittingPL(x) estimates xmin and alpha according to the formulas described
% in Newman(2006).
% 'x' is a vector of empirical data which is supposed to follow a power law
% distribution like p(x)~x^-alpha for x>=xmin.
% The fitting is done as follwos:
% (1) For each possible choice of xmin, the alpha value is estimanted via
% the MLE, and the goodness-of-fit is calculated (as D);
% (2) The value that minimises D is then choosen as the best estimate for
% xmin.

% The function 'fittingPL' uses two other functions: 
% (1) KStestPower --> which performs a K-S test between the empirical
% distrubution and the theoretical distrution obtained using the estimated 
% 'xmin' and 'alpha';
% (2) PlotPowerLaw --> which plots on a loglog axes both the curve for the
% empirical data and the estimanted distrution.

%% Inputs
% 'x'---> data set
% 'uc'and 'lc'---> Cut off a cenrtain percentage from the beginnig ('uc') 
% or the end ('lc') of the data set. Default values are 0% cut-off.
% 'finite'---> If the input data size is small (<100), the estimator can
% be biased (toward larger vuales of alpha). To correct this issue, call
% the fuction as [alpha,xmin,z,n]=fittingPL(x,'finite'), which does a 
% 'small-size' correction for alpha

%% Outputs
% 'alpha'---> as MLE of the scaling parameter
% 'xmin'---> the estimate of the lower bound of the power law behaviour

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

%% Command Line Parameters

if exist('finite','var')==0
    finite=false;
else
    finite=true;
end


if exist('uc','var')==0 || uc==0
    uppercut=1;
else uppercut=ceil(uc*length(x)/100);
end

if exist('lc','var')==0 || lc==0
    lowercut=0;
else lowercut=ceil(lc*length(x)/100);
end

%% Estimante 'xmin' and 'alpha'
% Reshape the input vector, making sure that 'x' is a one column vector
x = reshape(x,numel(x),1);
x=sort(x);

y=x(uppercut:(end-lowercut));
% Avoid repetitions searching all over unique values of the data set
xmins = unique(y);

% Create an array of zeros
dat = zeros(size(xmins));

% Sort the data set in ascending order
%z=sort(x);

% Estimate alpha using directly the MLE

for i=1:length(xmins)
    xmin = xmins(i); % choose the next xmin candidate
    
    y=y(y>=xmin);   % truncate the data below this xmin
    
    n = length(y);
    
    a = 1+n.*(sum(log(y./xmin)))^-1; %estimate apha using the MLE
    
    cx = (n:-1:1)'./n;  % Construct the empirical CDF
    
    cf = (y/xmin).^(-a+1); % Construct the theoretical CDF

    dat(i)=max( abs(cf-cx) ); % Compute the KS statistic
    
end

% Find the smallest D value
D = min(dat(dat>0));

% Find the corrisponding xmin value
xmin = xmins(find(dat==D,1,'first'));

z = x (x>=xmin);
n = length(z);

% Get corresponding alpha estimate
alpha = 1+n*(sum(log(z/xmin)))^-1;

% Finite-size correction
if finite
    alpha=alpha*(n-1)/n+1/n;
end

% Call the fuction KStestPower
[HpercentPL,PpercentPL]=KStestPower(z,n,xmin,alpha);

disp(' ') ; 
disp('Probability of Power law distributed lengths...') ; 
disp(['Power law Null hypothesis percentage: ', num2str(HpercentPL), '%']) ; 
disp(['Probability of lengths being Power law distributed: ', num2str(PpercentPL), '%']) ; 

% Call the function which plots the sorted empirical data and the
% theoretical curve obtained using the MLE for 'alpha' and 'xmin'

[c,cn]=PlotPowerLaw(x,y,z,xmin,alpha,sCol);

disp(' ') ; 
disp('Power law statistical parameters...') ;
disp(['alpha: ', num2str(alpha)]) ; 
disp(['x_min: ', num2str(xmin)]) ;

end 