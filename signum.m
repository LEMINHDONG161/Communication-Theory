function y = signum(x)

% y = signum(x)  generates a signum function signal
%
% x<0 일 때 y=-1, x=0 일 때 y=0, x>0 일 때 y=1

y = abs(x)./(x + (x==0)*eps) ;

% eps 는 매우 작은 양의 수로 분모가 0 이 되는 것을 방지
