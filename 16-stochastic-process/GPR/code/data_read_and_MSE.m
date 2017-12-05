clear all;close all;clc;

%% 问题1
clear;
load('question1.mat');

% 下面写处理问题1的代码
addpath('./GPML');
LikeFunction = @likGauss;                                               % 高斯似然函数
sn = 0.1;                                                               % 高斯似然函数的参数
MeanFunction = @meanConst;                                              % 均值函数

Cov1 = {@covProd,{@covRQiso,@covPeriodic}};                             % RQ * Per
Cov2 = {@covSum,{@covLINiso,Cov1}};                                     % Lin + RQ
CovFunction = {@covProd,{@covSEiso,Cov2}};                              % SE * (Lin + RQ * Per)
feval(CovFunction{:})                                                   % 核函数需要优化的参数个数

hyp.cov = zeros(9,1);hyp.mean = 0;hyp.lik = log(0.1);                   % 参数初始化
hyp = minimize(hyp, @gp, -200, @infGaussLik, MeanFunction, CovFunction, LikeFunction, xtrain, ytrain);	% 共轭梯度法求优化后参数
marlik1 = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, xtrain, ytrain);               % 边缘似然值
[ytest,~] = gp(hyp, @infGaussLik, MeanFunction, CovFunction, LikeFunction, xtrain, ytrain, xtest);      % ytest:对测试数据的预测

% plot(xtest,ytest, 'LineWidth', 2);hold on;plot(xtrain, ytrain);      	% 作图
% axis([-40 25 -60 40]);
% title('Training Dataset v.s. Test Dataset');
% xlabel('Input:  x');
% ylabel('Output: y');

%  计算MSE
MSE1 = MSE_question2(ytest);                                            % 计算MSE1

%% 问题2
load('planecontrol.mat');
fprintf('运行时间较长，请耐心等待...\n');
% 下面写处理问题2的代码
addpath('./GPML');
LikeFunction = @likGauss;                                            	% 高斯似然函数
sn = 0.1;                                                               % 高斯似然函数的参数
MeanFunction = @meanConst;                                              % 均值函数
x = xtrain(1:1000,:);y = ytrain(1:1000,:);                              % 选取一部分训练数据

CovFunction = @covSEard;                                                % 核函数为SE(高维)
hyp.cov = [zeros(40,1);0];hyp.mean = 0;hyp.lik = log(0.1);              % 参数初始化

hyp = minimize(hyp, @gp, -200, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y); % 共轭梯度法优化参数
marlik2 = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);           	% 边缘似然值
[ytest,~] = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y,xtest);      % ytest:对测试数据的预测

% 计算MSE
MSE2 = MSE_plane_control(ytest);                                        %计算MSE2