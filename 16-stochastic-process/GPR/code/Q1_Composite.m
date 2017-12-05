%% 文件说明
% 本.m文件尝试使用一些基本核函数的加乘复合，利用高斯过程回归，根据question1.mat提供的测试数据建立合适的模型。
% 本均值函数、似然函数和推断方法，只研究核函数(Kernel)对模型建立的影响。
% 涉及的核函数包括：SE、Per、Lin及RQ，通过加法乘法复合预测测试数据后得到的MSE衡量模型的效果。
% 核函数运算：
%   加法： A + B -------- {@covSum,{A,B}}
%   乘法： A * B -------- {@covProd,{A,B}}

%% 准备工作
clear all;close all;clc;
load('question1.mat');
addpath('./GPML');
x = xtrain;
y = ytrain;
z = xtest;
% 默认似然函数及参数
LikeFunction = @likGauss;                                                   % 高斯似然函数
sn = 0.1;                                                             % 高斯似然函数的参数

%% 作出训练数据(数据维度为一维)的图形
figure(1);
plot(x,y,'b','LineWidth',1.5);                                          %作图直观表现训练数据输入输出之间的关系
title('Plot of Training Dataset','FontSize',14);
xlabel('Input:  xtrain','FontSize',14);
ylabel('Output: ytrain','FontSize',14);
axis([-35,15,-40,30]);                                                      %限制坐标范围

%% 均值函数为Const
MeanFunction = @meanConst;                           %均值函数

%% 复合模型一
% SE + SE*PER + RQ + SE+WN;
Cov1 = {@covProd,{@covSEiso,@covPeriodic}};
Cov2 = {@covSum,{@covSEiso,@covNoise}};
CovFunction = {@covSum,{@covSEiso,Cov1,@covRQiso,Cov2}};
feval(CovFunction{:})

tic;
hyp.cov = zeros(13,1);hyp.mean = 0;hyp.lik = log(0.1);                    %参数设置
hyp = minimize(hyp, @gp, -200, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik1 = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m1,s2] = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
m1 = m1-2*sqrt(s2);
toc;
figure(2);                                                            %新图框
plot(z, m1, 'LineWidth', 2); hold on;plot(x, y);                       %作图
axis([-40 25 -60 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE1 = MSE_question2(m1);                                   %计算测试数据的MSE

%% 复合模型二
% LIN*SE + SE*PER + SE*RQ
Cov1 = {@covProd,{@covLINiso,@covSEiso}};
Cov2 = {@covProd,{@covSEiso,@covPeriodic}};
Cov3 = {@covProd,{@covSEiso,@covRQiso}};
CovFunction = {@covSum,{Cov1,Cov2,Cov3}};
feval(CovFunction{:})

tic;
hyp.cov = zeros(13,1);hyp.mean = 0;hyp.lik = log(0.1);                    %参数设置
hyp = minimize(hyp, @gp, -200, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik2 = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m2,s2] = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
toc;

figure(3);                                                            %新图框
f = [m2 + 2*sqrt(s2); flip(m2-2*sqrt(s2),1)];                       %作出范围
fill([z; flip(z,1)], f, [7 7 7]/8);
hold on; plot(z, m2, 'LineWidth', 2); plot(x, y);                       %作图
axis([-40 25 -60 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE2 = MSE_question2(m2);                                   %计算测试数据的MSE

%% 复合模型三
% SE*(LIN + RQ*PER)
Cov1 = {@covProd,{@covRQiso,@covPeriodic}};
Cov2 = {@covSum,{@covLINiso,Cov1}};
CovFunction = {@covProd,{@covSEiso,Cov2}};
feval(CovFunction{:})

tic;
hyp.cov = zeros(9,1);hyp.mean = 0;hyp.lik = log(0.1);                    %参数设置
hyp = minimize(hyp, @gp, -200, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik3 = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m3,s2] = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
toc;

figure(4);                                                            %新图框
f = [m3 + 2*sqrt(s2); flip(m3-2*sqrt(s2),1)];                       %作出范围
fill([z; flip(z,1)], f, [7 7 7]/8);
hold on; plot(z, m3, 'LineWidth', 2); plot(x, y);                       %作图
axis([-40 25 -60 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE3 = MSE_question2(m3);                                   %计算测试数据的MSE

%******************************************************************************%
%******************************************************************************%
%% 均值函数为 Lin + Const    
MeanFunction = {@meanSum,{@meanLinear,@meanConst}};                  %均值函数

%% 复合模型一
% SE + SE*PER + RQ + SE+WN;
Cov1 = {@covProd,{@covSEiso,@covPeriodic}};
Cov2 = {@covSum,{@covSEiso,@covNoise}};
CovFunction = {@covSum,{@covSEiso,Cov1,@covRQiso,Cov2}};
feval(CovFunction{:})

tic;
hyp.cov = zeros(13,1);hyp.mean = [0;0];hyp.lik = log(0.1);                    %参数设置
hyp = minimize(hyp, @gp, -200, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik4 = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m4,s2] = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
m4 = m4 + 2*sqrt(s2);
toc;

figure(5);                                                            %新图框
plot(z, m4, 'LineWidth', 2); hold on;plot(x, y);                       %作图
axis([-40 25 -60 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE4 = MSE_question2(m4);                                   %计算测试数据的MSE

%% 复合模型二
% LIN*SE + SE*PER + SE*RQ
Cov1 = {@covProd,{@covLINiso,@covSEiso}};
Cov2 = {@covProd,{@covSEiso,@covPeriodic}};
Cov3 = {@covProd,{@covSEiso,@covRQiso}};
CovFunction = {@covSum,{Cov1,Cov2,Cov3}};

tic;
hyp.cov = zeros(13,1);hyp.mean = [0;0];hyp.lik = log(0.1);                    %参数设置
hyp = minimize(hyp, @gp, -200, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik5 = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m5,s2] = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
toc;

figure(6);                                                            %新图框
f = [m5 + 2*sqrt(s2); flip(m5-2*sqrt(s2),1)];                       %作出范围
fill([z; flip(z,1)], f, [7 7 7]/8);
hold on; plot(z, m5, 'LineWidth', 2); plot(x, y);                       %作图
axis([-40 25 -60 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE5 = MSE_question2(m5);                                   %计算测试数据的MSE

%% 复合模型三
% SE*(LIN + RQ*PER)

Cov1 = {@covProd,{@covRQiso,@covPeriodic}};
Cov2 = {@covSum,{@covLINiso,Cov1}};
CovFunction = {@covProd,{@covSEiso,Cov2}};
feval(CovFunction{:})

tic;
hyp.cov = zeros(9,1);hyp.mean = [0;0];hyp.lik = log(0.1);                    %参数设置
hyp = minimize(hyp, @gp, -200, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik6 = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m6,s2] = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
toc;

figure(7);                                                            %新图框
f = [m6 + 2*sqrt(s2); flip(m6-2*sqrt(s2),1)];                       %作出范围
fill([z; flip(z,1)], f, [7 7 7]/8);
hold on; plot(z, m6, 'LineWidth', 2); plot(x, y);                       %作图
axis([-40 25 -60 40]);
title('Training Dataset v.s. Test Dataset');
xlabel('Input:  x');
ylabel('Output: y');

MSE6 = MSE_question2(m6);                                   %计算测试数据的MSE


%% 作图比较6中模型效果
figure(8);
plot(z,m1,'r','LineWidth', 2);hold on;
plot(z,m2,'m','LineWidth', 2);hold on;
plot(z,m3,'c','LineWidth', 2);hold on;
plot(z,m4,'k','LineWidth', 2);hold on;
plot(z,m5,'g','LineWidth', 2);hold on;
plot(z,m6,'b','LineWidth', 2);hold on;

legend( sprintf('Mean:Const; Kernel:Model 1'),...
        sprintf('Mean:Const; Kernel:Model 2'),...
        sprintf('Mean:Const; Kernel:Model 3'),...
        sprintf('Mean:Const+Lin; Kernel:Model 1'),...
        sprintf('Mean:Const+Lin; Kernel:Model 2'),...
        sprintf('Mean:Const+Lin; Kernel:Model 3'))
title('Structure Based on Composite Kernels','FontSize',14);
xlabel('Test Input','FontSize',14);ylabel('Test Output','FontSize',14);
