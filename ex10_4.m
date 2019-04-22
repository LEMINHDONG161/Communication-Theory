% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Bandpass Simulation of ASK
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear; close all;
Rb = 1000;   Tb = 1/Rb;
fs = 20*Rb;  Ts=1/fs;
B = fs/2; % System bandwidth
% Total number of bits : nBits
nBits = 1 * 10^5;
M = fs/Rb; % Number of samples per bit duration
% -------------------------------------------
% ASK Modulation
% -------------------------------------------
b = random_seq(nBits);
[x, t, pulse_shape] = linecode_gen(b, 'unipolar_nrz', Rb, fs);
fc = 5000; N = length(x);
carrier = carrier_gen(fc, fs, N);
x = x(:)'; carrier = carrier(:)';
xm = carrier.*x;
% Determine signal amplitude assuming unit bit energy
% Assume Eb = 1
A = sqrt(4*Rb); % for ASK
str = 'ASK';
% Detection Threshold
threshold = A*Tb/4;
xm = A*xm;  xm=xm(:)'; % Make x be column vector

EbNodB = 0:2:12;
for n = 1:length(EbNodB)
   n 
   EbNo = 10^(EbNodB(n)/10);
   % Theoretical BER
   Pe_theory(n) = Q_funct(sqrt(EbNo));
   % AWGN channel 
   noise_var = B/EbNo; 
   noise = gaussian_noise(0, noise_var, length(x));
   noise = noise(:)'; % Make n be column vector
   r = xm + noise; r = r(:)';
   % ASK Demodulation with matched filter
   y = carrier.*r;
   z = matched_filter(pulse_shape, y, fs);
   % Bit decision
   index = 1:nBits;
   b_hat = z(M*index); % Genarate decision variable by sampling matched filter output
   b_hat( find( b_hat < threshold ) ) = 0;
   b_hat( find( b_hat > threshold ) ) = 1;
   % Check error
   num_error = 0;
   err_bit = find( (b - b_hat) ~= 0);
   num_error = num_error + length(err_bit);
   Pe(n) = num_error/nBits;
end
% Plot simulation results
semilogy(EbNodB, Pe_theory, 'b'), hold on;
semilogy(EbNodB, Pe, 'xr--'), hold off;
axis([-inf inf 10^(-5)  1]), grid;
xlabel('Eb/No [dB]');
legend('Theoretical Pb', 'Simulation result');
ylabel('Probability of bit error');
title(str)
