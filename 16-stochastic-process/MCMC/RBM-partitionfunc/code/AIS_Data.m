clear all,close all,clc;

M_run = 20;            %AIS算法的运行次数
beta = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/100000:1.0];  %选取的beta向量，按照paper中建议的
load('test.mat');
load ('h10.mat');
W = parameter_W;        %RBM的权重矩阵W
a = parameter_a;        %隐藏层的bias向量a
b = parameter_b;        %可见层的bias向量b
N = 10;
LogZ1 = zeros(1,N);
LogZ2 = zeros(1,N);
for i = 1:N
    LogZ1(i) = AIS1(W,a,b,M_run,beta);
    LogZ2(i) = AIS2(W,a,b,M_run,beta,testbatchdata);
end
 Mean1 = mean(LogZ1);
 Var1 = var(LogZ1);

 Mean2= mean(LogZ2);
 Var2 = var(LogZ2);

plot(LogZ1,'-*');hold on;
plot(LogZ2,'->r');hold on;
ylim([150,250]);
title('AIS算法选取不同base-rate model时归一化常数的估计值');
xlabel('运行次数');
ylabel('logZ(归一化常数取自然对数)');