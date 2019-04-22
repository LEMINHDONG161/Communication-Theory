% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   Bandpass Simulation  - QPSK -
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear; close all;
OVERSAMPLE_FACTOR = 10;          % Oversample factor
Rb = 1000;  Tb = 1/Rb;           % Bit rate
fs = 2*Rb*OVERSAMPLE_FACTOR;     % Sampling frequency
Ts = 1/fs;                       % Sampling interval
B = fs/2;                        % System bandwidth 
Ns = fs/Rb;                      % Number of samples per bit duration
nSymbol = 10^5;         % Total number of symbols 
% -------------------------------------------
% PSK Modulation
% -------------------------------------------
linecode = 'polar_nrz';
b = random_seq(nSymbol*2);
bi = b(1:2:length(b));
bq = b(2:2:length(b));
[xi, t, pulse_shape_i] = linecode_gen(bi, linecode, Rb, fs);
[xq, t, pulse_shape_q] = linecode_gen(bq, linecode, Rb, fs);
xi=xi(:)'; xq=xq(:)';
fc = 5000; N = length(xi);                  % Carrier frequency
carrier_cos = carrier_gen(fc, fs, N);       % I-ch carrier
carrier_sin = carrier_gen(fc, fs, N, -90);  % Q-ch carrier
carrier_cos = carrier_cos(:)';
carrier_sin = carrier_sin(:)';
xmi = carrier_cos.*xi;
xmq = carrier_sin.*xq;
xm = xmi + xmq;
% Determine signal amplitude assuming unit bit energy
% Assume Eb = 1
A = sqrt(2*Rb); % for PSK
str = 'QPSK';
xm = A*xm;  
xm = xm(:)'; 

% Detection Threshold
threshold = 0;

EbNodB = 0:2:12;
b_hat_i=[];
b_hat_q=[];
for n = 1:length(EbNodB)
   n 
   EbNo = 10^(EbNodB(n)/10);
   % Theoretical BER
   Pe_theory(n) = Q_funct(sqrt(2*EbNo))
   % AWGN channel 
   noise_var = B/EbNo; 
   noise = gaussian_noise(0, noise_var, length(xm));
   r = xm + noise;  
   r = r(:)';
   % -------------------------------------------
   % PSK Demodulation with matched filter
   % Assume perfect carrier recovery
   % -------------------------------------------
   yi = carrier_cos.*r;
   yq = carrier_sin.*r;
   z_ich = matched_filter(pulse_shape_i, yi, fs);
   z_qch = matched_filter(pulse_shape_q, yq, fs);
   % Bit decision 
   index = 1:nSymbol;
   b_hat_i = z_ich(Ns*index); % Sample the matched filter output to get decision variable
   b_hat_q = z_qch(Ns*index);
   
   b_hat_i( find( b_hat_i < threshold ) ) = 0;
   b_hat_i( find( b_hat_i > threshold ) ) = 1;
   b_hat_q( find( b_hat_q < threshold ) ) = 0;
   b_hat_q( find( b_hat_q > threshold ) ) = 1;
   
   b_hat = zeros(1,length(b_hat_i)*2);
   b_hat(1:2:length(b_hat))=b_hat_i(1:length(b_hat_i));
   b_hat(2:2:length(b_hat))=b_hat_q(1:length(b_hat_q));
   % Check error
   num_error = 0;
   err_bit = find( (b - b_hat) ~= 0);
   num_error = num_error + length(err_bit);
   Pe(n) = num_error/(nSymbol*2)
end

% Plot simulation results
semilogy(EbNodB, Pe_theory, 'ro-'), hold on;
semilogy(EbNodB, Pe, 'b-square'), hold off;
axis([-inf inf 10^(-5)  1]), grid;
xlabel('Eb/No [dB]');
legend('Theoretical Pb', 'Simulation result');
ylabel('Probability of bit error');
title(str)
