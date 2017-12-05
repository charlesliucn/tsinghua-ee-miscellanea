clear all;close all;clc;

load('planecontrol.mat');
addpath('./GPML');
n = length(xtrain);
x = xtrain(1:1000,:);
y = ytrain(1:1000,:);
z = xtest;

%% 
LikeFunction = @likGauss;
sn = 0.1; 
%%
tic;
CovFunction = @covSEard;
% CovFunction = @ covSEiso;(效果明显不佳)
hyp.cov = [zeros(40,1);0];
hyp.lik = log(0.1);                                                                   %参数设置
hyp = minimize(hyp, @gp, -200, @infLOO, [], CovFunction, LikeFunction, x, y);       %参数初始化
marlik1 = gp(hyp, @infLOO, [], CovFunction, LikeFunction, x, y);                     %边缘似然值
[m1,~] = gp(hyp, @infLOO, [], CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
MSE1 = MSE_plane_control(m1);
toc;
%%
tic;
CovFunction = @covLINard;
hyp.cov = zeros(40,1);
hyp.lik = log(0.1);                                                                   %参数设置
hyp = minimize(hyp, @gp, -200, @infLOO, [], CovFunction, LikeFunction, x, y);       %参数初始化
marlik2 = gp(hyp, @infLOO, [], CovFunction, LikeFunction, x, y);                     %边缘似然值
[m2,~] = gp(hyp, @infLOO, [], CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
MSE2 = MSE_plane_control(m2);
toc;
%%
tic;
CovFunction = {@covSum,{@covLINard,@covSEard}};
hyp.cov = zeros(81,1);
hyp.lik = log(0.1);                                                                   %参数设置
hyp = minimize(hyp, @gp, -200, @infLOO, [], CovFunction, LikeFunction, x, y);       %参数初始化
marlik3 = gp(hyp, @infLOO, [], CovFunction, LikeFunction, x, y);                     %边缘似然值
[m3,~] = gp(hyp, @infLOO, [], CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
MSE3 = MSE_plane_control(m3);
toc;
%% 
tic;
CovFunction = {@covProd,{@covLINard,@covSEard}};
hyp.cov = zeros(81,1);
hyp.lik = log(0.1);                                                                   %参数设置
hyp = minimize(hyp, @gp, -200, @infLOO, [], CovFunction, LikeFunction, x, y);       %参数初始化
marlik4 = gp(hyp, @infLOO, [], CovFunction, LikeFunction, x, y);                     %边缘似然值
[m4,~] = gp(hyp, @infLOO, [], CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
MSE4 = MSE_plane_control(m4);
toc;
%%
MeanFunction = @meanConst;
hyp.mean = 0;
%%
tic;
CovFunction = @covSEard;
% CovFunction = @ covSEiso;(效果明显不佳)
hyp.cov = [zeros(40,1);0];
hyp.lik = log(0.1);                                                                   %参数设置
hyp = minimize(hyp, @gp, -200, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik5 = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m5,~] = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
MSE5 = MSE_plane_control(m5);
toc;
%%
tic;
CovFunction = @covLINard;
hyp.cov = zeros(40,1);
hyp.lik = log(0.1);                                                                   %参数设置
hyp = minimize(hyp, @gp, -200, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik6 = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m6,~] = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
MSE6 = MSE_plane_control(m6);
toc;
%%
tic;
CovFunction = {@covSum,{@covLINard,@covSEard}};
hyp.cov = zeros(81,1);
hyp.lik = log(0.1);                                                                   %参数设置
hyp = minimize(hyp, @gp, -200, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik7 = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m7,~] = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
MSE7 = MSE_plane_control(m7);
toc;
%% 
tic;
CovFunction = {@covProd,{@covLINard,@covSEard}};
hyp.cov = zeros(81,1);
hyp.lik = log(0.1);                                                                   %参数设置
hyp = minimize(hyp, @gp, -200, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
marlik8 = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
[m8,~] = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差
MSE8 = MSE_plane_control(m8);
toc;