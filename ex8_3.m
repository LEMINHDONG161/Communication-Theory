close all; clear;
Rb = 1000;
fs = 40*Rb;

% Eye diagram
b = RANDOM_SEQ(400);
[x, t] = LINECODE_GEN(b, 'polar_nrz', Rb, fs);

% Bandlimited filter only
figure
y = CHANNEL_FILTER(x, 1, 0.0, 2500, fs);
EYE_PATTERN(y, Rb, fs);
pause; disp('Press any key to continue');
y = CHANNEL_FILTER(x, 1, 0.0, 800, fs);
EYE_PATTERN(y, Rb, fs);
pause; disp('Press any key to continue');
y = CHANNEL_FILTER(x, 1, 0.0, 500, fs);
EYE_PATTERN(y, Rb, fs);
pause; disp('Press any key to continue');

% Filter and noise
b = RANDOM_SEQ(100);
[x, t] = LINECODE_GEN(b, 'polar_nrz', Rb, fs);
close all
y = CHANNEL_FILTER(x, 1, 0.0, 800, fs);
EYE_PATTERN(y, Rb, fs);
pause; disp('Press any key to continue');
y = CHANNEL_FILTER(x, 1, 0.1, 800, fs);
EYE_PATTERN(y, Rb, fs);
pause; disp('Press any key to continue');
y = CHANNEL_FILTER(x, 1, 0.2, 800, fs);
EYE_PATTERN(y, Rb, fs);

