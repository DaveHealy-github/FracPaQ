function [lambda,xmin2,y,z2,Hpercentexp,Ppercentexp]=fittingExponential(x,uc,lc,sCol)

%% [lambda,xmin2,HpercentExp,PpercentExp]=fittingExponential(x)

% This function uses a Maximum Likelihood Estimator (MLE) in order to fit a
% Exponential distribution for a discrete set of empirical data. Through the
% MLE method, the function estimates the  parameter 'lambda' based on
% the finding of a value for the lower bound (xmin) of an exponential
% behaviour in the data.
%
% Author: Roberto Emanuele Rizzo (rerizzo@abdn.ac.uk)
% Aberdeen April-May 2015
%% Notes
% fittingExponential(x) estimates lambda according to the formulation of
% the Maximum Likelihood as lambda = 1/mean(x).
% 'x' is a vector of empirical data which is supposed to follow a power law
% distribution like p(x)= lambda*exp^-(lambda*x)
% The fitting is done as follwos:
% (1) For each possible choice of xmin, the lambda value is estimanted via
% the MLE, and the goodness-of-fit is calculated (as D);
% (2) The value that minimises D is then choosen as the best estimate for
% xmin.

% The function 'fittingExponential' uses two other functions: 
% (1) KStestexp --> which performs a K-S test between the empirical
% distrubution and the theoretical distrution obtained using the estimated 
% 'xmin' and 'lamba';
% (2) PlotExp --> which plots on a linear-log axes both the curve for the
% empirical data and the estimanted distrution.

%% Inputs
% 'x'---> data set
% 'uc'and 'lc'---> Cut off a cenrtain percentage from the beginnig ('uc') 
% or the end ('lc') of the data set. Default values are 0% cut-off.
%% Outputs
% 'lambda'---> as MLE of the scaling parameter
% 'xmin'---> the estimate of the lower bound of the exponential behaviour

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
end

if exist('lc','var')==0 || lc==0
    lowercut=0;
else
    lowercut=ceil(lc*length(x)/100);
end
%% Estimate xmin and lambda

% Reshape the input vector, making sure that 'x' is a one column vector
x = reshape(x,numel(x),1);
x=sort(x);
y=x(uppercut:(end-lowercut));
% Avoid repetitions searching all over unique values of the data set
xmins=unique(y);

dat2=zeros(size(xmins));

% Sort the data in ascending order
%z2 = sort(x);

% Estimate 'lambda' using directly the MLE

for i=1:length(xmins)
    xmin2 = xmins(i);   % choose the next xmin candidate
    %z3 = z2(z2>=xmin2); % truncate the data below this xmin
    n = length(y);
    
    lambda = 1/(mean(y));
    
    cx2 = (n:-1:1)'./n; % Construct the empirical CDF
    
    cf2 = exp((lambda).*(xmin2-y)); % Construct the theoritical CDF
    
    dat2(i)=max(abs(cf2-cx2)); % Compute the KS statistic
    
end

% Find the smallest D value
D2 = min(dat2(dat2>0));

% Find the corrisponding xmin value
xmin2 = xmins(find (dat2==D2,1,'first'));

z2 = x(x>=xmin2);
z2=sort(z2);
n=length(z2);

% Get the corrisponding lambda estimate
lambda=1/(mean(z2)-xmin2);

% Call the function KStestexp
[Hpercentexp,Ppercentexp]=KStestexp(z2,n,lambda);
disp(' ') ; 
disp('Probability of Exponentially distributed lengths...') ; 
disp(['Exponential Null hypothesis percentage: ', num2str(Hpercentexp), '%']) ; 
disp(['Probability of lengths being Exponentially distributed: ', num2str(Ppercentexp), '%']) ;

% Call the function which plots the sorted empirical data and the
% theoretical curve obtained using the MLE for 'lambda' and 'xmin'
[c2,cn2]=PlotExp(x,y,z2,lambda,xmin2,sCol);

disp(' ') ; 
disp('Exponential statistical parameters...') ;
disp(['lambda: ', num2str(lambda)]) ; 

end 