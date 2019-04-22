clc;
clear all;
close all;
fc=1000;
fs=10000;
% fm=200;
fm=800;
% t=0:1/fs:(2/fm-1/fs);
t=0:1/fs:(4/fm-1/fs);
mt=0.4*sin(2*pi*fm*t)+0.5;
st=modulate(mt,fc,fs,'PPM');
dt=demod(st,fc,fs,'PPM');
figure
subplot(3,1,1);
plot(mt);
title('message signal');
xlabel('timeperiod');
ylabel('amplitude');
axis([0 50 0 1])
subplot(3,1,2);
plot(st);
title('modulated signal');
xlabel('timeperiod');
ylabel('amplitude');
axis([0 500 -0.2 1.2])
subplot(3,1,3);
plot(dt);
title('demodulated signal');
xlabel('timeperiod');
ylabel('amplitude');
axis([0 50 0 1])
