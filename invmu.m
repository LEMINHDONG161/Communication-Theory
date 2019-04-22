function x = invmu(y,mu)

% ����� ����ȭ PCM �� ���� mu-law �Է±��ϱ�
% �Է� x = invmu(y,mu) 
% ��� y = mulaw(x,mu)
%
% ��� y --> �Է� x ���ϱ�

x=(((1+mu).^(abs(y))-1)./mu).*eval('signum(y)');

