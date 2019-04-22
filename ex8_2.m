close all; clear;
Rb = 1000;
fs = 40*Rb;

% Effects of channel bandwidth(2500Hz, 800Hz, 500Hz)
b = RANDOM_SEQ(20);
[x, t] = LINECODE_GEN(b, 'polar_nrz', Rb, fs);
y = CHANNEL_FILTER(x, 1, 0.0, 5000,fs);
subplot(211), WAVEFORM(x, fs); title('f_{cutoff} / f_s = 5,000/40,000')
subplot(212), WAVEFORM(y, fs)
disp('hit any key to continue'); pause

y = CHANNEL_FILTER(x, 1, 0.0, 2500,fs);
subplot(211), WAVEFORM(x, fs); title('f_{cutoff} / f_s = 2,500/40,000')
subplot(212), WAVEFORM(y, fs)
disp('hit any key to continue'); pause

y = CHANNEL_FILTER(x, 1, 0.0, 800,fs);
subplot(211), WAVEFORM(x, fs); title('f_{cutoff} / f_s = 800/40,000')
subplot(212), WAVEFORM(y, fs)
disp('hit any key to continue'); pause

y = CHANNEL_FILTER(x, 1, 0.0, 500,fs);
subplot(211), WAVEFORM(x, fs); title('f_{cutoff} / f_s = 500/40,000')
subplot(212), WAVEFORM(y, fs)

disp('hit any key to see the effects of noise'); pause

% Effects of noise
close all % close all figure windows
y = CHANNEL_FILTER(x, 1, 0.01, 5000,fs);
subplot(211), WAVEFORM(x, fs); title('noise power = 0.01')
subplot(212), WAVEFORM(y, fs)
disp('hit any key to continue'); pause

y = CHANNEL_FILTER(x, 1, 0.1, 5000,fs);
subplot(211), WAVEFORM(x, fs); title('noise power = 0.1')
subplot(212), WAVEFORM(y, fs)
disp('hit any key to continue'); pause

y = CHANNEL_FILTER(x, 1, 0.5, 5000,fs);
subplot(211), WAVEFORM(x, fs); title('noise power = 0.5')
subplot(212), WAVEFORM(y, fs)
disp('hit any key to continue'); pause

y = CHANNEL_FILTER(x, 1, 1.0, 5000,fs);
subplot(211), WAVEFORM(x, fs); title('noise power = 1.0')
subplot(212), WAVEFORM(y, fs)

disp('hit any key to see PSD'); pause

% PSD of channel filter output
close all;
b = RANDOM_SEQ(2000);
x = LINECODE_GEN(b, 'polar_nrz', Rb, fs);
subplot(121), PSD(x,fs), ylabel('Power spectrum'), a = axis;
title('PSD of line code waveform');
y=CHANNEL_FILTER(x, 1, 0.01, 5000, fs);
subplot(122), PSD(y,fs), ylabel('Power spectrum'), axis(a), 
title('PSD of channel filter output');
hold on
pause; disp('Press any key to continue');
PSD(CHANNEL_FILTER(x, 1, 0.1, 5000, fs), fs);
pause; disp('Press any key to continue');
PSD(CHANNEL_FILTER(x, 1, 0.5, 5000, fs), fs);
pause; disp('Press any key to continue');
PSD(CHANNEL_FILTER(x, 1, 1, 5000, fs), fs);
