% cm72.m
% ����ȭ�� PCM (2)
% ���� ����ȭ x=3*sin(t)
%
% PCM ���� �Ƴ��α�/������(A/D) ��ȯ�� �Ϸ��� 
% ǥ��ȭ(���ø�) => ����ȭ => PCM �ڵ�
% 

% --- ������ ���� ����� ---
clear

% --- �ð� ��ȣ�� ǥ��ȭ(���ø�) ---
t = linspace(0,2*pi,1000+1);    % �ð� ��
x=3*sin(t);           		% ����ȭ ������ ������ ǥ�� ��

% --- ����ȭ�� ���� ������ ���� ---
N=3;                	% N ��Ʈ ����ȭ
M=2^N;              	% M �ܰ� ����ȭ
xmax=max(abs(x));   	% �Է��� �ִ� ���� ��
y = x/xmax;         	% �Է����� ������ �ִ� ũ�⸦ 1�� ����ȭ
dy = 2/M;           	% ����ȭ step
level = dy*([0:M-1])-dy*(M-1)/2; 	% ����ȭ ���� ����  

% --- ����ȭ ---
% �� ���ø� ǥ�� ���� �ش��ϴ� ����ȭ ���� ������ ��ȯ
% ����ȭ�� ǥ�� ��
%  = ����ȭ�� �Է����� ������ �����ϴ� ����ȭ ���� ��
%    x �Է����� ������ �ִ� ũ��
%
for i=1:M
   k = find((level(i)-dy/2 <= y) & (y <= level(i)+dy/2) )  ;
   quant(k) = level(i);    	% ����ȭ ���� ��
   pcm(k) = i-1;            	% ����ȭ ��´ܰ踦 10 ������ ǥ��
end
xi=quant*xmax;             	% ���� ����ȭ�� ǥ�� ��

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
figure(72)

subplot(2,1,1)
plot(t,x,'r',t,xi)  		% ������ ǥ�� ���� ����ȭ ���� �׸���
axis([min(t), max(t), min(x), max(x)])
      x1=min(t); x2=max(t); y1=0; y2=0; 
      line([x1 x2], [y1  y2]) 	% X �� �׸���
xlabel('t')
ylabel('x_{PCM}(t)  ����ȭ ����')
title('���� ����ȭ PCM')

subplot(2,1,2)
plot(t,pcm)  		% ����ȭ�� ǥ�� ���� 10�� PCM �ڵ� �׸���
    y1=min(pcm)-(max(pcm)-min(pcm))/12;
    y2=max(pcm)+(max(pcm)-min(pcm))/12;
axis([min(t), max(t), y1, y2])
xlabel('t')
ylabel('PCM �ڵ� ��')
grid

print  -dmeta   -f72   fig72
