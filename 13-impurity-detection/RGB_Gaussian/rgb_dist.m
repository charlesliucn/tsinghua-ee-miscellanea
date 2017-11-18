clear all;close all;clc;

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
subplot(3,1,1);hist(pos_feat(:,1),100);title('R分量');xlabel('R数值');ylabel('频次');
subplot(3,1,2);hist(pos_feat(:,2),100);title('G分量');xlabel('G数值');ylabel('频次');
subplot(3,1,3);hist(pos_feat(:,3),100);title('B分量');xlabel('B数值');ylabel('频次');