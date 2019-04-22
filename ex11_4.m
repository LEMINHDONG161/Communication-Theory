% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
%  Bandpass Simulation - QAM -
% ++++++++++++++++++++++++++++++++++++++++++++++++++++++
clear; close all;
OVERSAMPLE_FACTOR = 10;         % Oversample factor 
Rb = 1000;  Tb = 1/Rb;          % Bit rate
fs = 2*Rb*OVERSAMPLE_FACTOR;    % Sampling frequency
Ts = 1/fs;                      % Sampling interval
Ns = fs/Rb;                     % Number of samples per bit duration
M_set = [4 16 64 256 1024 4096];      
max_EbN0 = [12 16 20 26 28 34];       % Maximum Eb/No
nSymbol = 10^4;          % Total number of samples : nBits=nSymbol*2*k

for M_len=1:length(M_set)
    M = M_set(M_len);               % M = 2^(2k)
    k = log2(M)/2;                  % one symbol = 2*k bits
    B = fs/(4*k);                   % System bandwidth 
    % ---------------------------------------------------------------------
    % QAM Modulation
    % ---------------------------------------------------------------------
    graycode = graycode_gen(k);      % Generate Gray code
    b = random_seq(nSymbol * 2*k);
    [bi bq level] = level_transform(b,k,graycode);
    % Line coding
    xi = zeros(1,Ns*length(bi));
    xq = zeros(1,Ns*length(bi));
    data = ones(1,Ns);
    for ii = 1:length(bi)
        xi(1,(ii-1)*Ns+1:ii*Ns) = data(1,:).*bi(ii);
        xq(1,(ii-1)*Ns+1:ii*Ns) = data(1,:).*bq(ii);
    end
    xi=xi(:)'; xq=xq(:)';
    % Carrier
    fc = 5000; N = length(xi);                  % carrier frequency         
    carrier_cos = carrier_gen(fc, fs, N);       % I-ch carrier
    carrier_sin = carrier_gen(fc, fs, N, -90);  % Q-ch carrier
    carrier_cos = carrier_cos(:)'; 
    carrier_sin = carrier_sin(:)';
    
    xmi = carrier_cos.*xi; 
    xmq = carrier_sin.*xq;
    xm = xmi + xmq;
    % Determine signal amplitude assuming unit bit energy
    % Assume Eb = 1
    A = sqrt(2*Rb); % for QAM
    xm = A*xm;  
    xm = xm(:)'; 

    EbNodB = 0:2:max_EbN0(M_len);
    for n = 1:length(EbNodB)
       n 
       EbNo = 10^(EbNodB(n)/10);
       % Theoretical BER
       Pe_theory(M_len,n) = 2*(1-2^(-k))/k*Q_funct(sqrt(3*k/(2^(2*k)-1)*2*EbNo))

       % AWGN channel 
       noise_var = B/EbNo;          % Noise variance
       noise = gaussian_noise(0, noise_var, length(xi));
       noise = noise(:)'; 
       r = xm + noise; 
       r = r(:)';
       % ------------------------------------------------------------------
       % QAM Demodulation with correlator
       % Assume perfect carrier recovery
       % ------------------------------------------------------------------
       yi = carrier_cos.*r;
       yq = carrier_sin.*r;
       for index = 1:nSymbol;
           b_hat_i(1,index)=sum(yi(Ns*(index-1)+1:Ns*index))/(A*OVERSAMPLE_FACTOR);
           b_hat_q(1,index)=sum(yq(Ns*(index-1)+1:Ns*index))/(A*OVERSAMPLE_FACTOR);
       end
       % Bit decision 
       b_hat = qam_decision(b_hat_i, b_hat_q,level,graycode,k);
       % Check error
       num_error = 0;
       err_bit = find( (b - b_hat) ~= 0);
       num_error = num_error + length(err_bit);
       Pe(M_len,n) = num_error/(nSymbol*k*2)
    end
end

% Plot simulation results
theory_shape=['k:';'c:';'r:';'b:';'g:';'y:'];
simul_shape=['k-x';'c-o';'r-*';'b-d';'g-s';'y-+'];

for iii=1:length(M_set)
    semilogy(EbNodB, Pe_theory(iii,:), theory_shape(iii,:)),hold on;
    semilogy(EbNodB, Pe(iii,:), simul_shape(iii,:))
end
axis([-inf inf 10^(-6)  1]);
xlabel('Eb/No [dB]');
ylabel('Probability of bit error');
legend('4-Theory', '4-Simulation','16-Theory', '16-Simulation','64-Theory', '64-Simulation','256-Theory', '256-Simulation','1024-Theorety', '1024-Simulation','4092-Theory', '4092-Simulation');
title('QAM'),grid on;

