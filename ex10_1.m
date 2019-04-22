% *************************************************************
% 실험 1 변조신호의 파형과 스펙트럼
% *************************************************************
clear; close all;
Rb = 1000;
fs = 20*Rb;
Ts=1/fs;
% ========================================================
% ASK 파형 
b = [ 1 0 0 1 0 1];
data = [b  random_seq(1000)];
[x, t, pulse_shape] = linecode_gen(data, 'unipolar_nrz', Rb, fs);
fc = 5000; 
N = length(x); N1 = length(b)*fs/Rb;
carrier = carrier_gen(fc, fs, N);
x = x(:)'; carrier = carrier(:)';
xm = carrier.*x;
subplot(211), waveform(x(1:N1), fs);
title('baseband and OOK waveforms');
time_range = [1:N1]*Ts;    % Time vector
subplot(212), cw_waveform(xm(1:N1), fs, time_range);
pause    %Press any key to continue
% ASK spectrum
clf;
fr =[0, 20000];
M = 1024;
range = [0 10 -80 0];
subplot(211), psd_db(x, fs, M); axis(range);
title('Spectra of baseband signal and bandpass signal');
subplot(212), psd_db(xm, fs, M); axis(range);
pause %Press any key to continue
% ========================================================
% PSK 파형 
close all; 
[x, t, pulse_shape] = linecode_gen(data, 'polar_nrz', Rb, fs);
x = x(:)'; xm = carrier.*x;
subplot(211), waveform(x(1:N1), fs);
title('baseband and PSK waveforms');
subplot(212), cw_waveform(xm(1:N1), fs, time_range);
pause %Press any key to continue
% PSK spectrum
clf;
subplot(211), psd_db(x, fs, M); axis(range);
title('Spectra of baseband signal and bandpass signal');
subplot(212), psd_db(xm, fs, M); axis(range);
pause %Press any key to continue
% ========================================================
% FSK 파형 
close all;
[x, t, pulse_shape] = linecode_gen(data, 'polar_nrz', Rb, fs); 
x1 = (1-x)/2;
x2 = (1+x)/2;
fc1 = 2000; fc2 = 5000; N=length(x);
carrier1 = carrier_gen(fc1, fs, N);
carrier2 = carrier_gen(fc2, fs, N);
x1 = x1(:)'; carrier1 = carrier1(:)';
x2 = x2(:)'; carrier2 = carrier2(:)';
xm1 = carrier1.*x1;
xm2 = carrier2.*x2;
xm = xm1 + xm2;
subplot(211), waveform(x(1:N1), fs);
title('Spectra of baseband signal and bandpass signal');
subplot(212), cw_waveform(xm(1:N1), fs, time_range);
pause %Press any key to continue
% FSK spectrum
clf
subplot(211), psd_db(x, fs, M); axis(range);
title('Spectra of baseband signal and bandpass signal');
subplot(212), psd_db(xm, fs, M); axis(range);