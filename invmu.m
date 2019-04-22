function x = invmu(y,mu)

% 비균일 양자화 PCM 을 위한 mu-law 입력구하기
% 입력 x = invmu(y,mu) 
% 출력 y = mulaw(x,mu)
%
% 출력 y --> 입력 x 구하기

x=(((1+mu).^(abs(y))-1)./mu).*eval('signum(y)');

