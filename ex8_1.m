close all;  clear;
Rb = 1000;
fs = 16*Rb;

% Line code waveform
b =[ 1 0 1 0 1 1];
subplot(411), [x, t] = LINECODE_GEN(b, 'polar_nrz', Rb, fs); WAVEFORM(x, fs)
ylabel('polar nrz');
subplot(412), [x, t] = LINECODE_GEN(b, 'unipolar_rz', Rb, fs); WAVEFORM(x, fs)
ylabel('unipolar rz');
subplot(413), [x, t] = LINECODE_GEN(b, 'bipolar_rz', Rb, fs); WAVEFORM(x, fs)
ylabel('bipolar rz');
subplot(414), [x, t] = LINECODE_GEN(b, 'manchester', Rb, fs); WAVEFORM(x, fs)
ylabel('manchester');
disp('hit any key to continue'); pause

% Power spectral density
b = RANDOM_SEQ(2000);
subplot(121), [x, t] = LINECODE_GEN(b, 'unipolar_nrz', 1000, fs);
   PSD(x,fs); %axis([0 8 10^(-9) 10^(-1)]);
   title('unipolar nrz signaling with R_b = 1 kbps')
subplot(122), [x, t] = LINECODE_GEN(b, 'unipolar_nrz', 2000, fs); ...
   PSD(x,fs); axis([0 8 10^(-9) 10^(-1)]);
   title('unipolar nrz signaling with R_b = 2 kbps')
disp('hit any key to continue'); pause

clf
subplot(121), [x, t] = LINECODE_GEN(b, 'manchester', 1000, fs); 
   PSD(x,fs); axis([0 8 10^(-9) 10^(-1)]);
   title('manchester signaling with R_b = 1 kbps')
subplot(122), [x, t] = LINECODE_GEN(b, 'manchester', 2000, fs); 
   PSD(x,fs); axis([0 8 10^(-9) 10^(-1)]);
   title('manchester signaling with R_b = 2 kbps')
