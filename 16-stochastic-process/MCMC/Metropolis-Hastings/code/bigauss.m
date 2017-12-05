function f = bigauss (x1, x2)
% 计算二维高斯分布在(x1,x2)处的概率密度f
% x1，x2表示两个维度随机变量的取值;返回值f表示二维高斯分布在该点的分布密度

%根据要求设置二维高斯分布的参数
u1 = 5;         %E(X1) = 5;
u2 = 10;        %E(X2) = 10;
sigma1 = 1;     %Var(X1) = 1;
sigma2 = 2;     %Var(X2) = 4;
cov = 1;        %协方差Cov(X1,X2)为1
r = cov/(sigma1*sigma2);    %r为相关系数

%以下为二维高斯分布的概率密度函数
A = 1/(2*pi*sigma1*sigma2*sqrt(1-r^2)); 
B = (x1-u1).^2/sigma1^2-(2*r*(x1-u1).*(x2-u2)/(sigma1*sigma2))+((x2-u2).^2/sigma2^2);
f = A*exp((-1/(2*(1-r^2))).*B); %概率密度
end