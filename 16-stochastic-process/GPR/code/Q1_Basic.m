%% 文件说明
% 本.m文件试图使用一些基本的核函数，利用高斯过程回归，根据question1.mat提供的测试数据建立合适的模型。
% 以下模型固定均值函数、似然函数和推断方法，只研究核函数对模型建立的影响。
% 涉及的核函数包括：SE、Per、Lin及RQ，以预测测试数据后得到的MSE衡量模型的效果。

%% 准备工作
clear all;close all;clc;
load('question1.mat');
addpath('./GPML');
x = xtrain;
y = ytrain;
z = xtest;

%% 作出训练数据(数据维度为一维)的图形
figure(1);
plot(x,y);                                          %作图直观表现训练数据输入输出之间的关系
title('Plot of Training Dataset');
xlabel('Input:  xtrain');
ylabel('Output: ytrain');
axis([-40,20,-50,40]);                                                      %限制坐标范围

%% 默认均值函数和似然函数
MeanFunction = {@meanSum, {@meanLinear, @meanConst}};                           %均值函数
LikeFunction = @likGauss;                                                   % 高斯似然函数
sn = 0.1;                                                             % 高斯似然函数的参数

%% 1. 平方指数(SE)函数作为核函数
tic;
CovFunction = @covSEiso;
hyp.cov = [0;0]; hyp.mean = [0;0];hyp.lik = log(0.1);                                                 %参数设置
hyp = minimize(hyp, @GPR, -100, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik = GPR(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m1,s2] = GPR(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差

figure(2);                                                            %新图框
f = [m1 + 2*sqrt(s2); flip(m1 - 2*sqrt(s2),1)];                       %作出范围
fill([z; flip(z,1)], f, [7 7 7]/8);
hold on; plot(z, m1, 'LineWidth', 2); plot(x, y);                       %作图
axis([-40 25 -50 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE1 = MSE_question2(m1);                                   %计算测试数据的MSE
toc;

%% 2. 线性(Lin)核函数
tic;
CovFunction = @covLINiso;                                                                           %线性核函数
hyp.cov = 0; hyp.mean = [0; 0];hyp.lik = log(0.1);                                                  %参数初始化
hyp = minimize(hyp, @GPR, -100, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);         %参数优化
[m2,s2] = GPR(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m2为预测均值，s2为预测方差

figure(3);
f = [m2 + 2*sqrt(s2); flip(m2 - 2*sqrt(s2),1)];
fill([z; flip(z,1)], f, [7 7 7]/8);
hold on; plot(z, m2, 'LineWidth', 2); plot(x, y);
axis([-40 25 -50 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE2 = MSE_question2(m2);      %计算测试数据的MSE
toc;
%% 3. 有理二次(RQ)函数作为核函数
tic;
CovFunction = @covRQiso;            %有理二次函数
hyp.cov = [0;0;0]; hyp.mean = [0; 0]; hyp.lik = log(0.1);
hyp = minimize(hyp, @GPR, -100, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);
[m3,s2] = GPR(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);

figure(4);
f = [m3 + 2*sqrt(s2); flip(m3 - 2*sqrt(s2),1)];
fill([z; flip(z,1)], f, [7 7 7]/8);
hold on; plot(z, m3, 'LineWidth', 2); plot(x, y);
axis([-40 25 -50 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE3 = MSE_question2(m3);
toc;
%% 4. SE的周期函数作为核函数
tic;
CovFunction = @covPeriodic;
hyp.cov = [0;0;0]; hyp.mean = [0;0]; hyp.lik = log(0.5);
hyp = minimize(hyp, @GPR, -100, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);
[m4,s2] = GPR(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);

figure(5);
f = [m4 + 2*sqrt(s2); flip(m4 - 2*sqrt(s2),1)];
fill([z; flip(z,1)], f, [7 7 7]/8);
hold on; plot(z, m4, 'LineWidth', 2); plot(x, y);
axis([-40 25 -50 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');
MSE4 = MSE_question2(m4);
toc;
%% 作图比较各基本核函数的结果
figure(6);
plot(z,m1,'r*');hold on;
plot(z,m2,'b','LineWidth', 2);hold on;
plot(z,m3,'g+');hold on;
plot(z,m4,'m.');hold on;
legend(sprintf('SE'),sprintf('Lin'),sprintf('RQ'),sprintf('Per'));
title('Structure Based on Basic Kernels','FontSize',14);
xlabel('Test Input','FontSize',14);ylabel('Test Output','FontSize',14);
