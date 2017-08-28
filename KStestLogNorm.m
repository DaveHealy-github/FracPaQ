function [HpercentLN,PpercentLN]=KStestLogNorm(z4,n,mu,sigma)

%%
% Author: Roberto Emanuele Rizzo (rerizzo@abdn.ac.uk)
% Aberdeen April 2015
% [HpercentLN,PpercentLN]=KStestLogNorm(z4,n,mu,sigma)
% Generate a lognormal distrubution of random number, using the parameters
% 'mu' and 'sigma'. It then performs a K-S test to determine if the
% observed data (z2) fits with the generated data from the lognormal 
% distribution.

%--------input-----------
% n --> length of the empirical data set;
% z4 --> C.d.f. of the data with the new xmin value found after computing
%       the first KS stastic;
% mu --> the corresponding mu estimate;
% sigma --> the corresponding sigma estimate.
%
%-------output----------
% h --> indicates the result of the hypothesis test:
%       h = 0 => Do not reject the null hypothesis at the 5% significance
%       level. h = 1 => Reject the null hypothesis at the 5% significance
%       level;
% p --> asymptotic P-value;
%
% PpercentLN --> percentage of the p-value > 0.05 over the total
%              'n'-cycles
% HpercentLN --> percentage of the h=0 result over the total 'n'-cycles.

% 'kstest2' performs a Kolmogorov-Smirnov (K-S) test to determine if independent random samples, X1 and X2, are drawn from 
% the same underlying continuous population. Two-sample Kolmogorov-Smirnov goodness-of-fit hypothesis test.
% For more info about the test type "help kstest2" in the command window.

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

%%
rep=2500;
for i=1:rep
    LogNorm=lognrnd(mu,sigma,n,1);
    t= sort(LogNorm);

    [h(i),p(i)]=kstest2(z4,t,'alpha',0.05,'tail','unequal');
    
    if p(i)>0.05
        testresult(i)=1;
    else
        testresult(i)=0;
    end
end

PpercentLN = (sum(testresult)/rep)*100;

nym = find(h==0);
nym=numel(nym);

HpercentLN = (nym/rep)*100;

end 