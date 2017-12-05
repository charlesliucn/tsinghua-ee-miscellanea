clear all,close all,clc;

M_run = 10;            %AIS算法的运行次数
load ('h10.mat');
W = parameter_W;        %RBM的权重矩阵W
a = parameter_a;        %隐藏层的bias向量a
b = parameter_b;        %可见层的bias向量b

beta1 = [0:1/100:1];
beta2 = [0:1/1000:1];
beta3 = [0:1/10000:1];
beta4 = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/10000:1.0];  %选取的beta向量，按照paper中建议的

N = 10;
LogZ1 = zeros(1,N);
LogZ2 = zeros(1,N);
LogZ3 = zeros(1,N);
LogZ4 = zeros(1,N);

for i = 1:N
    LogZ1(i) = AIS1(W,a,b,M_run,beta1);
    LogZ2(i) = AIS1(W,a,b,M_run,beta2);
    LogZ3(i) = AIS1(W,a,b,M_run,beta3);
    LogZ4(i) = AIS1(W,a,b,M_run,beta4);
end

plot(LogZ1,'-*b');hold on;
plot(LogZ2,'-.r');hold on;
plot(LogZ3,'->k');hold on;
plot(LogZ4,'-*g');hold on;
ylim([100,300]);
legend('beta=[0:0.01:1]','beta=[0:0.001:1]','beta=[0:0.0001:1]','beta取值间距不等');
title('AIS算法beta取不同值时对归一化常数的估计');
xlabel('运行次数');
ylabel('logZ(归一化常数取自然对数)');


% plot(LogZ,'-*');
% ylim([Mean-5,Mean+5])
% title('AIS算法对RBM(隐变量为10)模型归一化常数的估计');
% xlabel('独立运行次数');
% ylabel('logZ(归一化常数取自然对数)');