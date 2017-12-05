function R = MH_Step(step)

Sample_Num = step*10000;
sample = zeros(2,Sample_Num);%用于保存生成的随机样本，第一行存储x1,第二行存储对应的x2

%高斯分布范围为无穷，选择一个合适大小的范围,便于作图比较
x1_range = [0,10];      %x1的范围
x2_range = [0,20];  	%x2的范围
psigma1 = 1;
psigma2 = 4;
n = 1;                  %n用于记录随机样本数量，初始化为1

%随机生成的初值作为第一个随机样本
sample(1,n) = unifrnd(x1_range(1),x1_range(2));    %使用unifrnd在x1的取值范围内选取x1的初值
sample(2,n) = unifrnd(x2_range(1),x2_range(2));    %使用unifrnd在x2的取值范围内选取x2的初值

%%Metropolis-Hastings算法生成随机样本
for n = 1:Sample_Num-1
    x1_next = normrnd(sample(1,n),psigma1);	%使用normrnd函数产生以x1为均值、psigma1为方差的随机数，作为x1_next
    x2_next = normrnd(sample(2,n),psigma2); %使用normrnd函数产生以x2为均值、psigma2为方差的随机数，作为x2_next
    temp1 = bigauss(x1_next,x2_next)/bigauss(sample(1,n),sample(2,n)); %计算比率，与1比较取最小值
    paccept = min(1,temp1);                 %计算得到accept probability
    U = rand;                             	%从[0,1]的均匀分布中选取一个随机数U
    if U < paccept                         	%当U比accept probability小时，接受
       sample(1,n+1) = x1_next;          	%将x1_next作为更新后的x1
       sample(2,n+1) = x2_next;             %将x2_next作为更新后的x2
    else
       sample(1,n+1) = sample(1,n);         %否则，将前一个x1(n)作为更新后的x1(n+1)
       sample(2,n+1) = sample(2,n);         %将前一个x2(n)作为更新后的x2(n+1)
    end
end

%根据产生的随机样本估计二维高斯分布的相关系数
X1 = sample(1,1:step:end);               %随机样本中的X1
X2 = sample(2,1:step:end);               %随机样本中的X2
L = length(X1);
E1 = sum(X1)/L;                 %X1的均值
E2 = sum(X2)/L;                 %X2的均值
Var1 = sum((X1-E1).^2)/L;       %X1的样本方差
Var2 = sum((X2-E2).^2)/L;       %X2的样本方差
E12 = sum(X1.*X2)/L;            %根据样本计算E(X1X2)
Cov= E12-E1*E2;                 %计算协方差
R = Cov/sqrt(Var1*Var2);        %得到相关系数

%作图比较
% figure;
% subplot(1,2,1);                 %子图1，作出真实分布图
% num = 100;                      %每个方向范围分的段数
% xx1 = linspace(x1_range(1),x1_range(2),num); %在x1方向分为num段
% xx2 = linspace(x2_range(1),x2_range(2),num); %在x2方向分为num段
% [x1g,x2g] = meshgrid(xx1,xx2);  %生成矩阵，矩阵运算
% f = bigauss(x1g,x2g);           %计算出高斯分布在各点的概率密度
% surf(x1g,x2g,f);                %作出概率密度分布图
% xlabel('X1');                   %三维坐标中x方向名称为X1
% ylabel('X2' );                  %三维坐标中x方向名称为X2
% zlabel( 'Frequency' );         	%三维坐标中x方向名称为Frequency（频数）
% 
% subplot(1,2,2);                 %子图2，作出随机样本的频数分布直方图
% samples = sample(:,:);
% hist3(samples','Edges',{xx1,xx2});%作出样本的频数分布直方图
% xlabel('X1');                   %三维坐标中x方向名称为X1
% ylabel('X2' );                  %三维坐标中x方向名称为X2
% zlabel( 'Frequency' );         	%三维坐标中x方向名称为Frequency（频数）
end