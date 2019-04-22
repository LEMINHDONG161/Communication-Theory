% *****************************************************************
% ½ÇÇè 3 FSK Demodulation - coherent & noncoherent detection
% *****************************************************************
clear; close all;
Rb = 1000;   Tb = 1/Rb;
fs = 40*Rb;  Ts=1/fs;
% FSK Modulation
b = [ 1 0 0 1 0 1];
[x, t, pulse_shape] = linecode_gen(b, 'polar_nrz', Rb, fs); 
x1 = (1-x)/2;  x2 = (1+x)/2;
fc1 = 2000;    fc2 = 5000; N=length(x);
carrier1 = carrier_gen(fc1, fs, N);
carrier2 = carrier_gen(fc2, fs, N);
x1 = x1(:)'; carrier1 = carrier1(:)';
x2 = x2(:)'; carrier2 = carrier2(:)';
xm1 = carrier1.*x1;
xm2 = carrier2.*x2;
xm = xm1 + xm2;
% -------------------------------------------
% Coherent FSK Demodulation
% -------------------------------------------
y1 = carrier1.*xm;
y2 = carrier2.*xm;
z1 = matched_filter(pulse_shape, y1, fs);
z2 = matched_filter(pulse_shape, y2, fs);
z = z2 - z1;
no_bits = length(b)+1;  % Observe signal waveform for 2 bit interval
time_range = [Ts  (no_bits*Tb)]; %  Time axis range to draw pulse waveform 
subplot(211), waveform(x, fs, time_range);
title('information signal');
subplot(212), waveform(z, fs); 
title('matched filter output');
pause    %Press any key to continue
% -------------------------------------------
% Noncoherent FSK Demodulation
% -------------------------------------------
% Theoretical envelope detection
dr_dt = diff(xm);
z = hilbert(dr_dt);         % get analytic signal 
envelope = abs(z);            % find the envelope 
demod = envelope;
subplot(211), waveform(x, fs);
title('information signal');
subplot(212), cw_waveform(demod,fs); 
title('envelope detector output');
r = axis; range = [r(1) r(2) 0 1];
axis(range);