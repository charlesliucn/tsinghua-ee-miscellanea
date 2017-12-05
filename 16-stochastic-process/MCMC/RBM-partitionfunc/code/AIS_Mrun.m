clear all,close all,clc;

M_run = [5:5:50];            %AIS算法的运行次数
beta = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/100000:1.0];  %选取的beta向量，按照paper中建议的
load('test.mat');
load ('h10.mat');
W = parameter_W;        %RBM的权重矩阵W
a = parameter_a;        %隐藏层的bias向量a
b = parameter_b;        %可见层的bias向量b
N = length(M_run);
LogZ = zeros(1,N);
for i = 1:N
    LogZ(i) = AIS1(W,a,b,M_run(i),beta);
end

 plot(M_run,LogZ,'-*');
% ylim([Mean-20,Mean+20]);
% title('AIS算法(未优化)对RBM(隐变量为10)模型归一化常数的估计');
% xlabel('独立运行次数');
% ylabel('logZ(归一化常数取自然对数)');

% plot(LogZ,'-*');
% ylim([Mean-5,Mean+5])
% title('AIS算法(优化)对RBM(隐变量为10)模型归一化常数的估计');
% xlabel('独立运行次数');
% ylabel('logZ(归一化常数取自然对数)');