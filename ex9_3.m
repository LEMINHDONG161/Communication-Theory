close all; clear;
Rb = 1000;
fs = 10*Rb;
Tb = 1/Rb;
Ts = 1/fs;
B = fs/2; % System bandwidth
f_cutoff = 3000; % Cut-off frequency for RC filter

nBits = 1 * 10^6; % Total number of bits : nBits
M = fs/Rb; % Number of samples per bit duration

% Signal generation
linecode = 'polar_nrz';
b = random_seq(nBits);
[x, t, pulse_shape] = linecode_gen(b, linecode, 1000, fs);
% Determine signal amplitude assuming unit bit energy
% Bit energy Eb is assumed to be 1
Eb = 1;
if strcmp(linecode, 'polar_nrz')
    A = sqrt(Eb/Tb); % polar_nrz
    threshold_A = 0;
    threshold_B = 0;
    k = 2; % For theoretical BER
    str = 'Polar NRZ Signaling';
else if strcmp(linecode, 'unipolar_nrz')
        A = sqrt(2*Eb/Tb); % unipolar_nrz
        threshold_A = A/2;
        threshold_B = A*Tb/2;
        k = 1; % For theoretical BER
        str = 'Unipolar NRZ Signaling';
    end
end

x = A*x;  x=x(:); % Make x be column vector

EbNo_dB = 0:2:20;
for n = 1:length(EbNo_dB)
   EbNo = 10^(EbNo_dB(n)/10);
   % Theoretical BER
   Pe_theory(n) = Q_funct(sqrt(k*EbNo));
   % AWGN channel 
   noise_var = B/EbNo; 
   noise = awgn(0, noise_var, length(x));
   noise = noise(:); % Make n be column vector
   r = x + noise; 
   % ------------------------------------------------------------------
   % 1. Simple sampling receiver
   % Bit decision
   index = 1:nBits;
   b_hat = r(M*index-M/2); % Genarate decision variable by sampling received signal
   b_hat( find( b_hat < threshold_A ) ) = 0;
   b_hat( find( b_hat > threshold_A ) ) = 1;
   b = b(:); b_hat = b_hat(:);
   % Check error
   num_error1 = 0;
   err_bit1 = find( (b - b_hat) ~= 0);
   num_error1 = num_error1 + length(err_bit1);
   Pe_simple(n) = num_error1/nBits;
   % ------------------------------------------------------------------
   % 2. RC LPF receiver
   % Simple RC filter is used
   y = rc_lpf(r, f_cutoff, fs, Rb);
   % Bit decision
   index = 1:nBits;
   b_hat = y(M*index-M/2); % Genarate decision variable by sampling RC filter output
   b_hat( find( b_hat < threshold_A ) ) = 0;
   b_hat( find( b_hat > threshold_A ) ) = 1;
   b = b(:); b_hat = b_hat(:);
   % Check error
   num_error2 = 0;
   err_bit2 = find( (b - b_hat) ~= 0);
   num_error2 = num_error2 + length(err_bit2);
   Pe_lpf(n) = num_error2/nBits;
   % ------------------------------------------------------------------
   % 3. Matched filter receiver
   z = matched_filter(pulse_shape, r, fs);
   index = 1:nBits;
   b_hat = z(M*index); % Genarate decision variable by sampling matched filter output
   b_hat( find( b_hat < threshold_B ) ) = 0;
   b_hat( find( b_hat > threshold_B ) ) = 1;
   b = b(:); b_hat = b_hat(:);
   % Check error
   num_error3 = 0;
   err_bit3 = find( (b - b_hat) ~= 0);
   num_error3 = num_error3 + length(err_bit3);
   Pe_opt(n) = num_error3/nBits;
   % ------------------------------------------------------------------
  end

% Plot simulation results
semilogy(EbNo_dB, Pe_simple, 'ob-'), hold on;
semilogy(EbNo_dB, Pe_lpf, 'xk-'), hold on;
semilogy(EbNo_dB, Pe_opt, 'dr-'), hold on;
semilogy(EbNo_dB, Pe_theory, 'k:'), hold off;
axis([-inf inf 10^(-5)  1]), grid;
xlabel('Eb/No [dB]');
legend('Simple Sampling Receiver', 'RC LPF Receiver', ...
       'Matched Filter Receiver', 'Theoretical Pb');
ylabel('Probability of bit error');
title(str)
