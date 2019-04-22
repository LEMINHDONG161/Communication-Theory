% cm73.m
% 양자화와 PCM (3)
% 비균일 양자화
%
% --- mulaw 를 사용한 비균일 양자화 ---
% 본 예제는 외부 함수 mulaw.m 이
% 같은 폴더에 있어야 실행되며, 
% 이 외부 함수의 계산결과에 signum 함수가 포함되므로
% signum.m 역시 외부함수로서 같은 폴더에 있어야 한다.
% ------------------       

% --- 기존의 변수 지우기 ---
clear

% ------------------       
x = linspace(-1,1,1000+1);   	% 입력
mu=255;
y = mulaw(x,mu);        	% mulaw 외부함수에 의한 출력 
% ------------------       
% function y = mulaw(x,mu)
% MULAW	비균일 양자화 PCM 을 위한 mu-law
% a=max(abs(x));
% y=(log(1+mu*abs(x/a))./log(1+mu)).*eval('signum(x)');

% --- 그림 창의 번호 매기기 ---
figure(73)

plot(x,y,'r')  			% mu-law 의 입출력 특성곡선 그리기
xlabel('입력')
ylabel('출력')
title('비균일 양자화를 위한 {\mu}-law 함수의 입출력')
x1=min(x); x2=max(x);      y1=min(y); y2=max(y);
axis([x1, x2, y1, y2])

line([x1 x2], [0  0]) 		% X 축 그리기
line([0 0], [y1 y2])  		% Y 축 그리기
grid                   		% GRID 그리기

print  -dmeta   -f73   fig73
