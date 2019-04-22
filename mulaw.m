function y = mulaw(x,mu)

% 비균일 양자화 PCM 을 위한 mu-law 출력구하기
% 입력 x = invmu(y,mu) 
% 출력 y = mulaw(x,mu)
%
% 입력 x --> 출력 y 구하기

a=max(abs(x));
y=(log(1+mu*abs(x/a))./log(1+mu)).*eval('signum(x)');

