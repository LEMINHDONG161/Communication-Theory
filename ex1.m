% Effect of amplitude distortion
t=0:0.005:2;
x_axis=0*t;
f1=1; f2=2*f1;
A1=1; A2=0.5;

% Input composed of two sinusoidal signals
x1=A1*sin(2*pi*f1*t); % First harmonic
x2=A2*sin(2*pi*f2*t); % Second harmonic
x=x1+x2;

% Channel gain and phase shift at frequency f1 and f2
gain=[0.5 1];
phase_shift=[0 0];

% Output
y1=gain(1)*A1*sin(2*pi*f1*t+phase_shift(1)); % First harmonic
y2=gain(2)*A2*sin(2*pi*f2*t+phase_shift(2)); % Second harmonic
y=y1+y2;

% Display input and output signals 
figure(1);
plot(t, x1, 'k'); hold on; plot(t, x2, 'k:'); plot(t, x, 'b'); plot(t, x_axis, 'k');
xlabel('Time (sec)'); ylabel('input signal waveform');  hold off
axis([0 2 -1.5 1.5]);
disp('hit any key to see output signal'); pause
figure(2);
plot(t, y1, 'k'); hold on; plot(t, y2, 'k:'); plot(t, y, 'b');plot(t, x_axis, 'k');
xlabel('Time (sec)'); ylabel('output signal waveform');  hold off
axis([0 2 -1.5 1.5]);