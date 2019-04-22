function [y] = correlator(g, x, fs)

% CORRELATOR
% This function implements correlation receiver.
% Input arguments:
%      g: basic pulse shape of the line code
%      x: received signal which input to the correlator
%      fs: sampling rate
%

dt = 1/fs;

L = length(g);
for i = 1: length(x)
    k = mod(i-1, L)+1;
    if k==1
        sum = 0;
    end
    sum = sum + x(i)*g(k); 
    y(i) = sum;
end
y = y*dt;
y = [y(:)' 0];
