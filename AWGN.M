function [y, seed] = awgn(mean, var, N, seed)

% *******************************************************
% Generates N Gaussian distributed random variables
% *******************************************************

if (nargin == 4)
   randn('seed',seed);
end

%-------------------------------------------------------------------------
% Step 1: Generate Gaussian random variables x with mean=0, var=1
% Step 2: Transform to other Gaussian random variables y with specified 
%         mean and variance using
%              y = (sqrt(var)*x) + mean)
%-------------------------------------------------------------------------

y = sqrt(var)*randn(1,N) + mean;
if (nargout == 2), seed = randn('seed'); end
