function [rgb_mean,rgb_cov] = rgb_model_train()
% 函数功能：烟草图像的RGB值的分布可以近似为三维的联合高斯分布。
% 该函数根据测试样本，对烟草图像RGB分布的均值和协方差特征进行训练
%
% 输出：
%       rgb_mean：均值向量
%       rgb_cov ：协方差矩阵
%  Copyright (c) 2017, Liu Qian All rights reserved. 

    %load('impurity.mat');           % 用于训练的杂质样本
    load('tabacoo.mat');            % 用于训练的烟草样本
    pos_sample = tabacoo;           % 正样本(烟草)
    %neg_sample = impurity;          % 负样本(杂质)
    pos_num = length(pos_sample);   
    %neg_num = length(neg_sample);
    pos_feat = zeros(pos_num,3);    % 样本的特征：R、G、B共三维

    for i = 1:pos_num               % 每个样本对应三个维度的特征
        r = pos_sample{i}(:,:,1);   
        pos_feat(i,1) = mean(mean(r(r~=0),2));  % 得到R分量
        g = pos_sample{i}(:,:,2);
        pos_feat(i,2) = mean(mean(g(g~=0),2));  % 得到G分量
        b = pos_sample{i}(:,:,3);
        pos_feat(i,3) = mean(mean(b(b~=0),2));  % 得到B分量
    end
    rgb_mean = mean(pos_feat);                  % 均值向量
    rgb_cov = cov(pos_feat);                    % 协方差矩阵
    save('rgb_model.mat','rgb_mean','rgb_cov');
end
