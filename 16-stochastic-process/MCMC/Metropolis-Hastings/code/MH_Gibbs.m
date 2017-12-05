%function R = MH_Gibbs()

u1 = 5;         %E(X1) = 5;
u2 = 10;        %E(X2) = 10;
sigma1 = 1;     %Var(X1) = 1;
sigma2 = 2;     %Var(X2) = 4;
cov = 1;        %协方差Cov(X1,X2)为1
realr = cov/(sigma1*sigma2);    %r为相关系数

N = 100000;          %设生成随机样本数为N
sample = zeros(2,N);%用于保存生成的随机样本，第一行存储x1,第二行存储对应的x2

%高斯分布范围为无穷，所以需要选择一个合适大小的范围
x1_range = [0,10];      %x1的范围
x2_range = [0,20];  	%x2的范围

n = 1;                  %n用于记录随机样本数量，初始化为1
%将随机生成的初值保存第一个随机样本
sample(1,n) = unifrnd(x1_range(1),x1_range(2));    %使用unifrnd在x1的取值范围内选取初值x1_start
sample(2,n) = unifrnd(x2_range(1),x2_range(2));    %使用unifrnd在x2的取值范围内选取初值x2_start

%%Metropolis-Hastings算法生成随机样本
for n = 1:N-1 
    u1_new = u1+realr*(sample(2,n)-u2);
    sigma_new = sqrt(1-realr^2);
    sample(1,n+1) = normrnd(u1_new,sigma_new);
    u2_new = u2+realr*(sample(1,n+1)-u1);
    sample(2,n+1) = normrnd(u2_new,sigma_new);
end

%根据产生的随机样本估计二维高斯分布的相关系数
X1 = sample(1,:);               %随机样本中的X1
X2 = sample(2,:);               %随机样本中的X2
L = length(X1);
E1 = sum(X1)/L;                 %X1的均值
E2 = sum(X2)/L;                 %X2的均值
Var1 = sum((X1-E1).^2)/L;       %X1的样本方差
Var2 = sum((X2-E2).^2)/L;       %X2的样本方差
E12 = sum(X1.*X2)/L;            %根据样本计算E(X1X2)
Cov= E12-E1*E2;                 %计算协方差
R = Cov/sqrt(Var1*Var2);        %得到相关系数

subplot(1,2,1);                 %子图1，作出真实分布图
num = 100;                      %每个方向范围分的段数
xx1 = linspace(x1_range(1),x1_range(2),num); %在x1方向分为num段
xx2 = linspace(x2_range(1),x2_range(2),num); %在x2方向分为num段
[x1g,x2g] = meshgrid(xx1,xx2);  %生成矩阵，矩阵运算
f = bigauss(x1g,x2g);           %计算出高斯分布在各点的概率密度
surf(x1g,x2g,f);                %作出概率密度分布图
xlabel('X1');                   %三维坐标中x方向名称为X1
ylabel('X2' );                  %三维坐标中x方向名称为X2
zlabel( 'Frequency' );         	%三维坐标中x方向名称为Frequency（频数）

subplot(1,2,2);                 %子图2，作出随机样本的频数分布直方图
hist3(sample','Edges',{xx1,xx2});%作出样本的频数分布直方图
xlabel('X1');                   %三维坐标中x方向名称为X1
ylabel('X2' );                  %三维坐标中x方向名称为X2
zlabel( 'Frequency' );         	%三维坐标中x方向名称为Frequency（频数）
%end