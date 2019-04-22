% cm75.m
% ����ȭ�� PCM (5)
% ����� ����ȭ x=3*sin(t), mu=255
%
% PCM ���� �Ƴ��α�/������(A/D) ��ȯ�� �Ϸ��� 
% ǥ��ȭ(���ø�) => ����ȭ => PCM �ڵ�
%
% --- mulaw �� ����� ����� ����ȭ ---
% �� ������ �ܺ� �Լ� mulaw.m �� invmu.m �� 
% ���� ������ �־�� ����Ǹ�, 
% �̵� �ܺ� �Լ��� ������� signum �Լ��� ���ԵǹǷ�
% signum.m ���� �ܺ��Լ��μ� ���� ������ �־�� �Ѵ�.

% --- ������ ���� ����� ---
clear

% --- �ð� ��ȣ�� ǥ��ȭ(���ø�) ---
t = linspace(0,2*pi,1000+1);    % �ð� ��
x=3*sin(t);           		% ����ȭ ������ ������ ǥ�� ��

% --- ����ȭ�� ���� ������ ���� ---
N=4;                		% N ��Ʈ ����ȭ
M=2^N;              		% M �ܰ� ����ȭ
xmax=max(abs(x));   		% �Է��� �ִ� ���� ��

% ------------------
% �Է����� ������ �ִ� ũ�⸦ 1�� ����ȭ�Ͽ�
% ����� ����ȭ PCM �� ���� mu-law ��±��ϱ�
mu=255;                
y = mulaw(x/xmax,mu);  		% mu-law ��±��ϱ� 

% ------------------       
dy = 2/M;                   		% ����ȭ step
level = dy*([0:M-1])-dy*(M-1)/2;   	% ����ȭ ���� ����  

% --- ����ȭ ---
% �� ���ø� ǥ�� ���� �ش��ϴ� ����ȭ ���� ������ ��ȯ
% ����ȭ�� ǥ�� ��
%  = ����ȭ�� �Է����� ������ �����ϴ� ����ȭ ���� ������
%    ����� ����ȭ PCM �� ���� mu-law �Է±��ϱ�
%    x �Է����� ������ �ִ� ũ��
%
for i=1:M
   k = find((level(i)-dy/2 <= y) & (y <= level(i)+dy/2) )  ;
   quant(k) = level(i);     	% ����ȭ ���� ��
   pcm(k) = i-1;       		% ����ȭ ��´ܰ踦 10 ������ ǥ��
end
% ------------------
xi=invmu(quant,mu)*xmax; 	% ����� ����ȭ�� ǥ�� ��

% --- PCM �ڵ� ---
% �� ����ȭ�� ǥ�� ���� PCM �ڵ�� ��ȯ
% PCM �ڵ� 10�� --> 2�� ��ȯ
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

% --- ����ȭ�� ǥ�� ���� ���� 10���� 2�� PCM �ڵ��� ���� ---
data = [pcm' code];
% data �� pcmdata.txt ���Ϸ� ����
% save pcmdata.txt  data -ascii

% --- �׸� â�� ��ȣ �ű�� ---
figure(75)

subplot(2,1,1)
plot(t,x,'r',t,xi)  	% ������ ǥ�� ���� ����ȭ ���� �׸���
axis([min(t), max(t), min(x), max(x)])
      x1=min(t); x2=max(t); y1=0; y2=0; 
      line([x1 x2], [y1  y2]) 		% X �� �׸���
xlabel('t')
ylabel('x_{PCM}(t)  ����ȭ ����')
title('����� ����ȭ PCM     ({\mu}-law ���, {\mu}=255)')

subplot(2,1,2)
plot(t,pcm)  		% ����ȭ�� ǥ�� ���� 10�� PCM �ڵ� �׸���
    y1=min(pcm)-(max(pcm)-min(pcm))/12;
    y2=max(pcm)+(max(pcm)-min(pcm))/12;
axis([min(t), max(t), y1, y2])
xlabel('t')
ylabel('PCM �ڵ� ��')
grid

print  -dmeta   -f75   fig75
