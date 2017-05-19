function [parmhat] = nbinfit_custom(x,options)
%#codegen
coder.inline('never'); 

%NBINFIT Parameter estimates for negative binomial data.
%   NBINFIT(X) Returns the maximum likelihood estimates of the
%   parameters of the negative binomial distribution given the data in
%   the vector, X.
%
%   [PARMHAT, PARMCI] = NBINFIT(X,ALPHA) returns MLEs and 100(1-ALPHA)
%   percent confidence intervals given the data.  By default, the
%   optional parameter ALPHA = 0.05 corresponding to 95% conf. intervals.
%
%   [ ... ] = NBINFIT( ..., OPTIONS) specifies control parameters for the
%   numerical optimization used to compute ML estimates.  This argument can
%   be created by a call to STATSET.  See STATSET('nbinfit') for parameter
%   names and default values.
%
%   See also NBINCDF, NBININV, NBINLIKE, NBINPDF, NBINRND, NBINSTAT, MLE,
%            STATSET.

%   Copyright 1993-2011 The MathWorks, Inc.


% The default options include turning fminsearch's display off.  This
% function gives its own warning/error messages, and the caller can turn
% display on to get the text output from fminsearch if desired.
options = statset(statset('nbinfit'),options);


if ~isfloat(x)
    x = double(x);
end

xbar = mean(x);
s2   = var(x);

% Ensure that a NB fit is appropriate.
if s2 <= xbar
    parmhat = cast([Inf 1.0],class(x));
    return
end

% Use Method of Moments estimates as starting point for MLEs.
rhat = (xbar.*xbar) ./ (s2-xbar);

% Parameterizing with mu=r(1-p)/p makes this a 1-D search for rhat.
muhat = xbar;
[rhat,~,err,output] = ...
    fminsearch(@negloglike, rhat, options, length(x), x, sum(x), options.TolBnd);
if (err <= 0)
    % fminsearch may print its own output text; in any case give something
    % more statistical here, controllable via warning IDs.
err

end

phat = rhat ./ (muhat + rhat);
parmhat = [rhat phat];


%-------------------------------------------------------------------------

function nll = negloglike(r, n, x, sumx, tolBnd)
% Objective function for fminsearch().  Returns the negative of the
% (profile) log-likelihood for the negative binomial, evaluated at
% r.  From the likelihood equations, phat = rhat/(xbar+rhat), and so the
% 2-D search for [rhat phat] reduces to a 1-D search for rhat -- also
% equivalent to reparametrizing in terms of mu=r(1-p)/p, where muhat=xbar
% can be found explicitly.

% Restrict r to the open interval (0, Inf).
if r < tolBnd
    nll = Inf;

else
    xbar = sumx / n;
    nll = -sum(gammaln(r+x)) + n*gammaln(r) ...
                - n*r*log(r/(xbar+r)) - sumx*log(xbar/(xbar+r));
end
