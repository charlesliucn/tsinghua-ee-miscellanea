clear all;close all;clc;

%% 准备工作
% 设定相关数值
nuser = 943;                                            % 用户数目
nitem = 1682;                                           % 物品(电影、商品等)数量
ntrain = 80000;                                         % 训练集大小
ntest = 10000;                                          % 测试集大小
% 准备数据
load('data_train.mat');                                 % 加载数据
[ttlnum,~] = size(data_train);                          % 计算所有数据总数
% 对数据进行处理，划分为训练集和测试集
split = randperm(ttlnum);                               % randperm随机乱序
traindata = data_train(split(1:ntrain),:);              % 取前ntrain个作为训练集
testdata = data_train(split(ttlnum-ntest+1:end),:);     % 剩下的ntest个作为测试数据

%% 将数据集还原为矩阵形式
% 矩阵初始化
M = zeros(nuser,nitem);
for i = 1:ntrain
    u = traindata(i,1);
    v = traindata(i,2);
    M(u,v) = traindata(i,3);
end

%% 使用ALS_WR算法计算U和V
d = 40;
Iterations = 5;
nlimit = 40;
trainMSE = zeros(1,nlimit);
testMSE = zeros(1,nlimit);

for lambda = 1:nlimit
    [U, V] = ALS_WR(traindata,testdata,M,d,lambda*0.01,Iterations);
    X = U*V';
    [trainMSE(lambda),testMSE(lambda)] = calcMSE(traindata,testdata,X);
end
plot([1:40]*0.01,trainMSE,'r');hold on;
plot([1:40]*0.01,testMSE,'b');
title('算法结果随超参数λ的变化');
xlabel('超参数λ');
ylabel('均方误差MSE');
legend(sprintf('trainMSE'),sprintf('testMSE'));
