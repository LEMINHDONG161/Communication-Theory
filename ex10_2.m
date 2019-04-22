% *****************************************************************
% 실험 2 ASK Demodulation - coherent & noncoherent detection
% *****************************************************************
clear; close all;
Rb = 1000;   Tb = 1/Rb;
fs = 40*Rb;  Ts=1/fs;
% ASK Modulation
b = [ 1 0 0 1 0 1];
[x, t, pulse_shape] = linecode_gen(b, 'unipolar_nrz', Rb, fs);
fc = 5000; N = length(x);
carrier = carrier_gen(fc, fs, N);
x = x(:)'; carrier = carrier(:)';
xm = carrier.*x;
% -------------------------------------------
% ASK Demodulation with matched filter
% -------------------------------------------
y = carrier.*xm;
z = matched_filter(pulse_shape, y, fs);
no_bits = length(b)+1;  % Observe signal waveform for 2 bit interval
time_range = [Ts  (no_bits*Tb)]; %  Time axis range to draw pulse waveform 
subplot(211), waveform(x, fs, time_range);
title('information signal');
subplot(212), waveform(z, fs); 
title('matched filter output');
V = AXIS;
pause    %Press any key to continue
% -------------------------------------------
% Carrier phase error가 있는 경우 복조기 출력 
% -------------------------------------------
rx_carrier = carrier_gen(fc, fs, N, 30); % Phase error of 30 degrees
y = rx_carrier.*xm;
z = matched_filter(pulse_shape, y, fs);
subplot(211), waveform(x, fs, time_range);
title('information signal');
subplot(212), waveform(z, fs); 
title('matched filter output');
axis(V);
pause    %Press any key to continue
% -------------------------------------------
% Carrier frequency error가 있는 경우 복조기 출력 
% -------------------------------------------
rx_carrier = carrier_gen(fc+50, fs, N, 0); % Frequency error of 50Hz
y = rx_carrier.*xm;
z = matched_filter(pulse_shape, y, fs);
subplot(211), waveform(x, fs, time_range);
title('information signal');
subplot(212), waveform(z, fs); 
title('matched filter output');
axis(V);
pause    %Press any key to continue
% ========================================================
% Noncoherent Demodulation
% ASK 
% Theoretical envelope detection
z = hilbert(xm);            % get analytic signal 
envelope = abs(z);          % find the envelope 
subplot(211), waveform(x, fs);
title('information signal');
subplot(212), cw_waveform(envelope,fs); 
title('envelope detector output');