function y = signum(x)

% y = signum(x)  generates a signum function signal
%
% x<0 �� �� y=-1, x=0 �� �� y=0, x>0 �� �� y=1

y = abs(x)./(x + (x==0)*eps) ;

% eps �� �ſ� ���� ���� ���� �и� 0 �� �Ǵ� ���� ����
