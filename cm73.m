% cm73.m
% ����ȭ�� PCM (3)
% ����� ����ȭ
%
% --- mulaw �� ����� ����� ����ȭ ---
% �� ������ �ܺ� �Լ� mulaw.m ��
% ���� ������ �־�� ����Ǹ�, 
% �� �ܺ� �Լ��� ������� signum �Լ��� ���ԵǹǷ�
% signum.m ���� �ܺ��Լ��μ� ���� ������ �־�� �Ѵ�.
% ------------------       

% --- ������ ���� ����� ---
clear

% ------------------       
x = linspace(-1,1,1000+1);   	% �Է�
mu=255;
y = mulaw(x,mu);        	% mulaw �ܺ��Լ��� ���� ��� 
% ------------------       
% function y = mulaw(x,mu)
% MULAW	����� ����ȭ PCM �� ���� mu-law
% a=max(abs(x));
% y=(log(1+mu*abs(x/a))./log(1+mu)).*eval('signum(x)');

% --- �׸� â�� ��ȣ �ű�� ---
figure(73)

plot(x,y,'r')  			% mu-law �� ����� Ư��� �׸���
xlabel('�Է�')
ylabel('���')
title('����� ����ȭ�� ���� {\mu}-law �Լ��� �����')
x1=min(x); x2=max(x);      y1=min(y); y2=max(y);
axis([x1, x2, y1, y2])

line([x1 x2], [0  0]) 		% X �� �׸���
line([0 0], [y1 y2])  		% Y �� �׸���
grid                   		% GRID �׸���

print  -dmeta   -f73   fig73
