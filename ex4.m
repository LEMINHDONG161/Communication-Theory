% LTI system analysis in frequency domainecho ondf=0.01;				   % Freq. resolutionfs=10;						% Sampling frequency => 10 samples per sects=1/fs;                   % Sampling intervalt=[-5:ts:5];               % Time vector x=zeros(1,length(t));         % Generate input signal x(31:40)=2*ones(1,10);      % x(t)=0   for -2<t<-1x(41:61)=2-2*cos(0.5*pi*t(41:61));   % x(t)=2-2cos(pi*t/2)  for -1<t<1x(62:71)=2*ones(1,10);     % x(t)=1   for 1<t<2x(72:91)=4-t(72:91);          % x(t)=4-t   for 2<t<4pause %Press any key to see input signal waveformplot(t,x); axis([-5 5 -2 4])title('Input signal waveform');% Part 1[X,x1,df1]=fft_mod(x,ts,df);          % Spectrum of the inputf=[0:df1:df1*(length(x1)-1)]-fs/2;  % Frequency vectorX1=X/fs;                            		% Scalingpause	% Press any key to see spectrum of the inputplot(f,fftshift(abs(X1)))title('Magnitude spectrum of the input signal');% Ideal Lowpass Filter transfer functionH=[ones(1,ceil(1.5/df1)),zeros(1,length(X)-2*ceil(1.5/df1)),ones(1,ceil(1.5/df1))];     				Y=X.*H;                             % Output spectrumy1=ifft(Y);                           % Output of the filterpause	% Press any key to see the output of the lowpass filterplot(t,abs(y1(1:length(t))));title('Filtered output signal');% Part 2% LTI system impulse responseh=zeros(1,length(t));h(51:60)=t(51:60);       % h(t)=t   for 0<t<1h(61:70)=2-t(61:70);    % h(t)=2-t  for 1<t<2pause	% Press any key to see the impulse response of the systemplot(t,h); axis([-5 5 -2 4])title('Impulse response of the system');[H2,h2,df1]=fft_mod(h,ts,df);H21=H2/fs;f=[0:df1:df1*(length(h2)-1)]-fs/2;pause %Press any key to see the frequency response of the systemmag_H21=fftshift(abs(H21));plot(f,mag_H21)title('Magnitude response of the system');% Compute output by convolutiony2=conv(h,x);					% Output of the LTI systempause	% Press any key to see the output signal of the LTI systemplot([-10:ts:10],y2);title('Output signal of the LTI system');