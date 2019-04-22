% =======================================================================
% Detection using RC Filter Receiver and Matched Filter Receiver
% =======================================================================
close all; clear;
Rb = 1000;
fs = 60*Rb;
ts=1/fs;
Tb = 1/Rb;

b = [1 0 1 0 1 1 0 0 0 1];
[x, t, pulse_shape] = linecode_gen(b, 'polar_nrz', Rb, fs);
r = channel_filter(x, 1, 5.0, 25000, fs);
subplot(211), waveform(x, fs); ylabel('Transmitted signal');
title('Tx & Rx signal waveforms, Noise power = 5 W, Channel BW = 25 KHz')
subplot(212), waveform(r, fs); ylabel('Received signal');
disp('hit any key to continue'); pause
figure;

% RC filter receiver
y = rc_lpf(r, 1000, fs, Rb);
% Matched filter receiver
z = matched_filter(pulse_shape, r, fs);
subplot(211), waveform(y, fs); ylabel('Lowpass filter output');
title('Noise power = 5 W, Channel BW = 25 KHz')
subplot(212), waveform(z, fs); ylabel('Matched filter output');


