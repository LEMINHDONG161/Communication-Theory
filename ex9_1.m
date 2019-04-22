% ************************************************
% Matched filter and correlator
% ************************************************
Rb = 1000;
fs = 100*Rb;
ts = 1/fs;
Tb = 1/Rb;
close all; 
b = [ 1 0 1 0 1 1];
[s, t, pulse_shape] = linecode_gen(b, 'polar_nrz', Rb, fs);
no_bits = length(b)+1;  % Observe signal waveform for 2 bit interval
time_range = [ts  (no_bits*Tb)]; %  Time axis range to draw pulse waveform 
subplot(211), waveform(s, fs, time_range);
y = matched_filter(pulse_shape, s, fs);
subplot(212), waveform(y, fs); ylabel('Matched filter output');
disp('hit any key to see correlator output'); pause
figure;
subplot(211), waveform(s, fs, time_range);
y = correlator(pulse_shape, s, fs);
subplot(212), waveform(y, fs, time_range); ylabel('Correlator output');


