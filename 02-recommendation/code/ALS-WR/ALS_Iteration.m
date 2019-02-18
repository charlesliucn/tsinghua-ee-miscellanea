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
lambda = 0.20;
Iterations = 40;
d = 40;
[trainMSE,testMSE] = ALS_WR_Iter(traindata,testdata,M,d,lambda,Iterations);

plot(1:Iterations,trainMSE,'r');hold on;
plot(1:Iterations,testMSE,'b');
title('算法结果随迭代次数的变化');
xlabel('迭代次数');
ylabel('均方误差MSE');
legend(sprintf('trainMSE'),sprintf('testMSE'));
% 
% plot(1:Iterations,testMSE,'b');
% xlabel('迭代次数');
% ylabel('均方误差MSE');
% title('测试集上MSE随迭代次数的变化');
