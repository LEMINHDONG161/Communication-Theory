% *************************************************************
% 실험 1 변조신호의 파형과 스펙트럼
% *************************************************************
clear; close all;
OVERSAMPLE_FACTOR = 10;          % Oversample factor
Rb = 2000;  Tb = 1/Rb;           % Bit rate
fs = 2*Rb*OVERSAMPLE_FACTOR;     % Sampling frequency
ts = 1/fs;                       % Sampling interval
% ========================================================
% QPSK
b = [1 1 0 0 1 1 1 0 0 1 1 1];
data = [b  random_seq(20000)];
[data_o data_e] = s_to_p(data); % Serail to parallel conversion without delay
[x_o, t, pulse_shape] = linecode_gen(data_o, 'polar_nrz', Rb, fs);
[x_e, t, pulse_shape] = linecode_gen(data_e, 'polar_nrz', Rb, fs);
fc = 4000; 
N = length(x_o); N1 = length(b)*fs/Rb; 
carrier_cos = carrier_gen(fc, fs, N, 45);    % I-ch carrier
carrier_sin = carrier_gen(fc, fs, N, -45);   % Q-ch carrier
x_o = x_o(:)';  x_e = x_e(:)'; 
carrier_cos = carrier_cos(:)'; carrier_sin = carrier_sin(:)';
I_xm = carrier_cos.*x_o;  
Q_xm = carrier_sin.*x_e;
xm = I_xm + Q_xm;
subplot(311), waveform(x_o(1:N1), fs); 
title('baseband and QPSK waveforms'); 
ylabel('x_{odd}(t)');
time_range = [1:N1]*ts;    % Time vector
subplot(312), waveform(x_e(1:N1), fs); ylabel('x_{even}(t)');
subplot(313), cw_waveform(xm(1:N1), fs); ylabel('x_{QPSK}(t)');
pause    % Press any key to continue
% QPSK spectrum
clf;
fr =[0, 20000];
M = 1024;
range = [0 10 -80 0];
subplot(211), psd_db(x_o, fs, M); axis(range);
title('Spectra of baseband signal and bandpass signal');
subplot(212), psd_db(xm, fs, M); axis(range);
pause    % Press any key to continue 
% ========================================================
% OQPSK
[data_o data_e] = s_to_p(data, 1); % Serail to parallel conversion with delay
[x_o, t, pulse_shape] = linecode_gen(data_o, 'polar_nrz', Rb, fs);
[x_e, t, pulse_shape] = linecode_gen(data_e, 'polar_nrz', Rb, fs);
N = length(x_o); N1 = length(b)*fs/Rb; 
carrier_cos = carrier_gen(fc, fs, N, 45);    % I-ch carrier
carrier_sin = carrier_gen(fc, fs, N, -45);   % Q-ch carrier
x_o = x_o(:)';  x_e = x_e(:)'; 
carrier_cos = carrier_cos(:)'; carrier_sin = carrier_sin(:)';
I_xm = carrier_cos.*x_o;  
Q_xm = carrier_sin.*x_e;
xm = I_xm + Q_xm;
subplot(311), waveform(x_o(1:N1), fs); 
title('baseband and OQPSK waveforms');
ylabel('x_{odd}(t)');
time_range = [1:N1]*ts;    % Time vector
subplot(312), waveform(x_e(1:N1), fs); ylabel('x_{even}(t)');
subplot(313), cw_waveform(xm(1:N1), fs);  ylabel('x_{OQPSK}(t)');
pause    % Press any key to continue
% OQPSK spectrum
clf;
subplot(211), psd_db(x_o, fs, M); axis(range);
title('Spectra of baseband signal and bandpass signal');
subplot(212), psd_db(xm, fs, M); axis(range);
pause    % Press any key to continue 
% ========================================================
% MSK
[data_o data_e] = s_to_p(data, 1); % Serail to parallel conversion with delay
[x_o, t, pulse_shape] = linecode_gen(data_o, 'polar_nrz', Rb, fs);
[x_e, t, pulse_shape] = linecode_gen(data_e, 'polar_nrz', Rb, fs);
N = length(x_o); N1 = length(b)*fs/Rb; 
for k =1:N
    x_o(k) = x_o(k)*cos(0.5*pi*Rb*k*ts);
    x_e(k) = x_e(k)*sin(0.5*pi*Rb*k*ts);
end
carrier_cos = carrier_gen(fc, fs, N, 45);     % I-ch carrier 
carrier_sin = carrier_gen(fc, fs, N, -45);    % Q-ch carrier
x_o = x_o(:)';  x_e = x_e(:)'; 
carrier_cos = carrier_cos(:)'; carrier_sin = carrier_sin(:)';
I_xm = carrier_cos.*x_o;  
Q_xm = carrier_sin.*x_e;
xm = I_xm + Q_xm;
subplot(311), waveform(x_o(1:N1), fs); 
title('baseband and MSK waveforms');
ylabel('x_{odd}(t)');
time_range = [1:N1]*ts;    % Time vector
subplot(312), waveform(x_e(1:N1), fs); ylabel('x_{even}(t)');
subplot(313), cw_waveform(xm(1:N1), fs);  ylabel('x_{MSK}(t)');
pause    % Press any key to continue
% OQPSK spectrum
clf;
subplot(211), psd_db(x_o, fs, M); axis(range);
title('Spectra of baseband signal and bandpass signal');
subplot(212), psd_db(xm, fs, M); axis(range);
