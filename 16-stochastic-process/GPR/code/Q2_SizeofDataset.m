clear all;close all;clc;

load('planecontrol.mat');
LikeFunction = @likGauss;
MeanFunction = @meanConst;
sn = 0.1;
z = xtest;
MSE1 = [];MSE2 = [];MSE3 = [];
%% 
for i = 1:10
    x = xtrain(1:200*i,:);
    y = ytrain(1:200*i,:);

    CovFunction = @covSEard;
    hyp.cov = [zeros(40,1);log(2)];
    hyp.lik = log(0.1);hyp.mean = 0;                                                                   %参数设置
    hyp = minimize(hyp, @gp, -100, @infLaplace, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
    marlik = gp(hyp, @infLaplace, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
    [mean,s2] = gp(hyp, @infLaplace, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差

    MSE = MSE_plane_control(mean);
    MSE1 = [MSE1;MSE];
end

%%
for i = 1:10
    x = xtrain(1:200*i,:);
    y = ytrain(1:200*i,:);

    CovFunction = @covSEard;
    hyp.cov = [zeros(40,1);log(2)];
    hyp.lik = log(0.1);hyp.mean = 0;                                                                   %参数设置
    hyp = minimize(hyp, @gp, -100, @infVB, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
    marlik = gp(hyp, @infVB, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
    [mean,s2] = gp(hyp, @infVB, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差

    MSE = MSE_plane_control(mean);
    MSE2 = [MSE2;MSE];
end

%%
for i = 1:10
    x = xtrain(1:200*i,:);
    y = ytrain(1:200*i,:);

    CovFunction = @covSEard;
    hyp.cov = [zeros(40,1);log(2)];
    hyp.lik = log(0.1);hyp.mean = 0;                                                                   %参数设置
    hyp = minimize(hyp, @gp, -100, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);       %参数初始化
    marlik = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y);                     %边缘似然值
    [mean,s2] = gp(hyp, @infLOO, MeanFunction, CovFunction, LikeFunction, x, y, z);  %m1为预测均值，s2为预测方差

    MSE = MSE_plane_control(mean);
    MSE3 = [MSE3;MSE];
end

%%
figure(1);
plot(1:10,MSE1,'r');hold on;
plot(1:10,MSE2,'b');hold on;
plot(1:10,MSE3,'m');hold on;

legend( sprintf('Mean:Const; Kernel:Model 1'),...
        sprintf('Mean:Const; Kernel:Model 2'),...
        sprintf('Mean:Const; Kernel:Model 3'),...
        sprintf('Mean:Const+Lin; Kernel:Model 1'),...
        sprintf('Mean:Const+Lin; Kernel:Model 2'),...
        sprintf('Mean:Const+Lin; Kernel:Model 3'))
title('Structure Based on Composite Kernels','FontSize',14);
xlabel('Test Input','FontSize',14);ylabel('Test Output','FontSize',14);
