function y = mulaw(x,mu)

% ����� ����ȭ PCM �� ���� mu-law ��±��ϱ�
% �Է� x = invmu(y,mu) 
% ��� y = mulaw(x,mu)
%
% �Է� x --> ��� y ���ϱ�

a=max(abs(x));
y=(log(1+mu*abs(x/a))./log(1+mu)).*eval('signum(x)');

