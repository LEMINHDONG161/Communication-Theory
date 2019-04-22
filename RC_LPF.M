function  [y] = RC_LPF(x, fc, fs, Rb)

% *****************************************************************************
% First-order RC analog lowpass filter
%
% y = RC_LPF(x, fc, fs, Rb) 
% x = input sequence
% fc = cutoff frequency [Hz]
% fs = sampling frequency
% Rb = data rate [bps]
% *****************************************************************************

if (fc > (fs/2))
   error('Cut-off frequency fc must be <= (fs/2)')
end

samples_per_bit = fs/Rb; 
fc_n = [fc/(fs/2)]; % Normalized cut-off frequency
[B, A]  = butter(1, fc_n);
[out1 out2]  = filter(B, A, x);
y = out1;
% Matlab function FILTER: 1-dimensional digital filter
% a(1)*y(n) = b(1)*x(n) + b(2)*x(n-1) + ... + b(nb+1)*x(n-nb)
%                          - a(2)*y(n-1) - ... - a(na+1)*y(n-na)
if (nargin == 4)
    out3 = filter(B, A, zeros(1,samples_per_bit),out2);
    y = [out1(:)' out3(:)'];
end
