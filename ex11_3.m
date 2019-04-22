% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%   Bandpass Simulation - MPSK -
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear; close all;
OVERSAMPLE_FACTOR = 10;          % Oversample factor
Rb = 1000;  Tb = 1/Rb;           % Bit rate
fs = 2*Rb*OVERSAMPLE_FACTOR;     % Sampling frequency
Ts = 1/fs;                       % Sampling interval
Ns = fs/Rb;                      % Number of samples per bit duration
M_set = [4 8 16 32 64];
max_EbN0 = [12 16 20 24 30];
nSymbol = 10^4;         % Total number of symbols => nBits = nSymbol * k
for M_len = 1:length(M_set)
    M = M_set(M_len);                % M = 2^k
    k = log2(M);                     % Number of bits per symbol
    B = fs/(2*k);                    % System bandwidth 
    % -------------------------------------------
    % MPSK Modulation
    % -------------------------------------------
    graycode = graycode_gen(k);       % Generate Gray code
    b = random_seq(nSymbol * k);
    [bi bq phase] = symbol2phase(k,b,graycode); % Symbol to phase mapping

    xi = zeros(1,Ns*length(bi));
    xq = zeros(1,Ns*length(bq));
    for ii=1:length(bi)
        for jj=1:Ns
            xi((ii-1)*Ns+jj)=bi(ii);
            xq((ii-1)*Ns+jj)=bq(ii);
        end
    end
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
    A = sqrt(2*Rb); % for MPSK
    xm = A*xm;  
    xm=xm(:)'; 
    
    EbNodB = 0:2:max_EbN0(M_len);
    b_hat_i=[];
    b_hat_q=[];
    for n = 1:length(EbNodB)
       n 
       EbNo = 10^(EbNodB(n)/10);
       % Theoretical BER
       Pe_theory(M_len,n) = (2/k)*Q_funct(sqrt(2*k*EbNo)*sin(pi/M))
       % AWGN channel 
       noise_var = B/EbNo; 
       noise = gaussian_noise(0, noise_var, length(xi));
       noise = noise(:)'; 
       r = xm + noise; 
       r = r(:)';
       % -------------------------------------------
       % M-PSK Demodulation with correlator
       % Assume perfect carrier recovery
       % -------------------------------------------
       yi = carrier_cos.*r;
       yq = carrier_sin.*r;
       for index = 1:nSymbol
           b_hat_i_int(1,index)=sum(yi(Ns*(index-1)+1:Ns*index));
           b_hat_q_int(1,index)=sum(yq(Ns*(index-1)+1:Ns*index));
       end
       % Bit decision
       b_hat = mpsk_decision(b_hat_i_int, b_hat_q_int, graycode,M);
      % Check error
       num_error = 0;
       err_bit = find( (b - b_hat) ~= 0);
       num_error = num_error + length(err_bit);
       Pe(M_len,n) = num_error/(nSymbol*k)
    end
end

% Plot simulation results
theory_shape=['k:';'c:';'r:';'b:';'g:'];
simul_shape=['k-x';'c-o';'r-*';'b-d';'g-s'];
for iii=1:length(M_set)
    semilogy(EbNodB, Pe_theory(iii,:), theory_shape(iii,:)), hold on;
    semilogy(EbNodB, Pe(iii,:), simul_shape(iii,:))
end
axis([-inf inf 10^(-6)  1]);
xlabel('Eb/No [dB]');
ylabel('Probability of bit error');
legend('4-Theory', '4-Simulation','8-Theory', '8-Simulation','16-Theory', '16-Simulation','32-Theory', '32-Simulation','64-Theory', '64-Simulation');
title('MPSK'),grid on;

