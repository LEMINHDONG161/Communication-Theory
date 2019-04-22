% cm72.m
% 양자화와 PCM (2)
% 균일 양자화 x=3*sin(t)
%
% PCM 으로 아날로그/디지털(A/D) 변환을 하려면 
% 표본화(샘플링) => 양자화 => PCM 코딩
% 

% --- 기존의 변수 지우기 ---
clear

% --- 시간 신호의 표본화(샘플링) ---
t = linspace(0,2*pi,1000+1);    % 시간 축
x=3*sin(t);           		% 양자화 이전의 원래의 표본 값

% --- 양자화를 위한 변수를 설정 ---
N=3;                	% N 비트 양자화
M=2^N;              	% M 단계 양자화
xmax=max(abs(x));   	% 입력의 최대 진폭 값
y = x/xmax;         	% 입력전압 레벨의 최대 크기를 1로 정규화
dy = 2/M;           	% 양자화 step
level = dy*([0:M-1])-dy*(M-1)/2; 	% 양자화 판정 레벨  

% --- 양자화 ---
% 각 샘플링 표본 값에 해당하는 양자화 레벨 값으로 변환
% 양자화된 표본 값
%  = 정규화된 입력전압 레벨에 대응하는 양자화 레벨 값
%    x 입력전압 레벨의 최대 크기
%
for i=1:M
   k = find((level(i)-dy/2 <= y) & (y <= level(i)+dy/2) )  ;
   quant(k) = level(i);    	% 양자화 레벨 값
   pcm(k) = i-1;            	% 양자화 출력단계를 10 진수로 표현
end
xi=quant*xmax;             	% 균일 양자화된 표본 값

% --- PCM 코딩 ---
% 각 양자화된 표본 값을 PCM 코드로 변환
% PCM 코드 10진 --> 2진 변환
code=zeros(length(x),N);
for k = 1:length(x)
      decimal = pcm(k);
   for n = 1:N
    if ( fix(decimal/(2^(N-n))) == 1)
	code(k,n) = 1;
	decimal = decimal - 2^(N-n);
    end
  end
end 

% --- 양자화된 표본 값에 의한 10진과 2진 PCM 코드의 저장 ---
data = [pcm' code];
% data 를 pcmdata.txt 파일로 저장
% save pcmdata.txt  data -ascii

% --- 그림 창의 번호 매기기 ---
figure(72)

subplot(2,1,1)
plot(t,x,'r',t,xi)  		% 본래의 표본 값과 양자화 레벨 그리기
axis([min(t), max(t), min(x), max(x)])
      x1=min(t); x2=max(t); y1=0; y2=0; 
      line([x1 x2], [y1  y2]) 	% X 축 그리기
xlabel('t')
ylabel('x_{PCM}(t)  양자화 레벨')
title('균일 양자화 PCM')

subplot(2,1,2)
plot(t,pcm)  		% 양자화된 표본 값의 10진 PCM 코드 그리기
    y1=min(pcm)-(max(pcm)-min(pcm))/12;
    y2=max(pcm)+(max(pcm)-min(pcm))/12;
axis([min(t), max(t), y1, y2])
xlabel('t')
ylabel('PCM 코드 값')
grid

print  -dmeta   -f72   fig72
