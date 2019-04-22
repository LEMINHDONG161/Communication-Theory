% ---------------------------------------------------------% FM_DEM.m% Matlab program example for FM demodulation % Message signals are:% Signal 1: multilevel rectangular pulse sequence%        m(t) =  1  for 0 < t < 0.05%        m(t) = -2  for 0.05 < t < 0.1%        m(t) =  0  otherwise%% Signal 2: triangular pulse with pulse width tau2=0.1% ---------------------------------------------------------clear; close allecho ondf=0.2            % desired frequency resolution [Hz]ts=1/2000;        % sampling interval [sec]fs=1/ts;           % sampling frequencyfc=250;            % carrier frequencykf=40  ;            % frequency sensitivity [Hz/volt]% -----------------------------------------------% Message signal generation% -----------------------------------------------% For signal 1: multilevel rectangular pulse sequence     T1=0; T2=0.15;    % observation time interval (from T1 to T2 sec)     m=[ones(1,T2/(3*ts)),-2*ones(1,T2/(3*ts)),zeros(1,T2/(3*ts)+1)];     % For signal 2: triangular pulse with pulse width tau2=0.1 and amplitude=2    %T1=-0.1; T2=0.1;    % observation time interval (from T1 to T2 sec)    %m=2*triangle(0.1, T1, T2, fs, df);         m_min=min(m); m_max=max(m);% -------------% Modulation % -------------t=[T1:ts:T2];    % observation time vectorN=length(t);integ_m(1)=0;for i=1:length(t)-1                  	% integral of m  integ_m(i+1)=integ_m(i)+m(i)*ts;  echo off ;endecho on ;[M,m,df1]=fft_mod(m,ts,df);        % Fourier transform of message signalM=M/fs;                              	% scalingf=[0:df1:df1*(length(m)-1)]-fs/2;    	% frequency vectors_m=cos(2*pi*(fc*t + kf*integ_m));    % modulated signal[S_m,s_m,df1]=fft_mod(s_m,ts,df);     % Fourier transform of modulated signalS_m=S_m/fs;                              	% scalingpause  % Press any key to see the signal waveformsubplot(2,1,1);plot(t,m(1:length(t)));axis([T1 T2 m_min-0.1 m_max+0.1]);xlabel('Time');title('Message signal');subplot(2,1,2);plot(t,s_m(1:length(t)));xlabel('Time');title('Modulated signal');pause   % Press any key to see the spectrumsubplot(2,1,1);plot(f,abs(fftshift(M))) ;xlabel('Frequency');title('Magnitude spectrum of the message signal');subplot(2,1,2);plot(f,abs(fftshift(S_m))) title('Magnitude spectrum of the modulated signal');xlabel('Frequency');pause   % Press any key to demodulate the FM signal% ---------% Channel% ---------snr_dB=30;                          % SNR in dB snr=10^(snr_dB/10);             % linear SNR signal_power=(norm(s_m(1:N))^2)/N;   % modulated signal powernoise_power=signal_power/snr;	      % noise powernoise_std=sqrt(noise_power);         	% noise standard deviationnoise=noise_std*randn(1,N);             % Generate noiser=s_m(1:N);                                    % When there is no noise%r=r+noise;                                     % Add noise to the modulated signal% ----------------------% Coherent demodulation % ----------------------z=complex_env(r,ts,T1,T2,fc);              % find phase of the received signalphase=angle(z);theta=unwrap(phase);                   	  % restore original phasedemod=(1/(2*pi*kf))*(diff(theta)/ts);  % demodulator output, differentiate and scale phasepause	% Pres any key to see plots of the message and the demodulator outputfigure;subplot(2,1,1)plot(t,m(1:length(t)));axis([T1 T2 m_min-1 m_max+1]);xlabel('Time')title('Message signal')t1=t(1:length(t)-1);subplot(2,1,2)plot(t1,demod(1:length(t1)));axis([T1 T2 m_min-1 m_max+1]);xlabel('Time');title('Demodulated signal');% --------------------------% Noncoherent demodulation % --------------------------dr_dt=diff(r);z=hilbert(dr_dt);                      % get analytic signal envelope=abs(z);                   % find the envelope demod1=envelope;pause	% Pres any key to see plots of the message and the demodulator outputfigure;subplot(2,1,1)plot(t,m(1:length(t)));axis([T1 T2 m_min-1 m_max+1]);xlabel('Time')title('Message signal')subplot(2,1,2)plot(t1,demod1(1:length(t1)));axis([T1 T2 min(demod1)-0.1 max(demod1)+0.1]);xlabel('Time');title('Demodulated signal');