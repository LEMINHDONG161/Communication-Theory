function x=triangle(tau, T1, T2, fs, df)
% 
%*************************************************
% Generation of triangular pulse
% tau : pulse width [sec]
% fs : sampling frequency
%       fs must be greater than or equal to 2/T
% [T1, T2] : observation time interval [sec]
% df : frequency resolution [Hz]
%
% example 
% x=rect(2, -5, 5, 10, 0.01)
%**************************************************

%clear
%tau=2;
%T1=-5; T2=5;
%df=0.01; %frequency resolution
%fs=10; %sampling frequency
ts=1/fs; %sampling period
t=[T1:ts:T2]; %observation time interval

% Signal genaration of triangular pulse
x=zeros(size(t));
midpoint=floor((T2-T1)/2/ts)+1;
L1=midpoint-fix(tau/2/ts);
L2=midpoint+fix(tau/2/ts)-1;
x(L1:midpoint)=(2/tau)*t(L1:midpoint)+1; %2/tau is the slope
x(midpoint+1:L2)=-(2/tau)*t(midpoint+1:L2)+1;
%[X,x1,df1]=fftseq(x,ts,df);
%X1=X/fs; %scaling
%f=[0:df1:df1*(length(x1)-1)]-fs/2; %frequency vector (range to plot)
%plot(t,x); axis([T1, T2 -2 4])