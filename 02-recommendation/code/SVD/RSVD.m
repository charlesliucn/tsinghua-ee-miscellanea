clear all;close all;clc;

nuser = 943;
nitem = 1682;
nfeature = 20;
Iterations = 20;
lambda = 0.20;
gamma = 0.05;

ntrain = 80000;                                         % 训练集大小
ntest = 10000;                                          % 测试集大小

load('data_train.mat');                                 % 加载数据
[ttlnum,~] = size(data_train);                          % 计算所有数据总数
M = zeros(nuser,nitem);
for i = 1:ttlnum
    u = data_train(i,1);
    v = data_train(i,2);
    M(u,v) = data_train(i,3);
end
% 对数据进行处理，划分为训练集和测试集
split = randperm(ttlnum);                               % randperm随机乱序
traindata = data_train(split(1:ntrain),:);              % 取前ntrain个作为训练集
test_set = data_train(split(ttlnum-ntest+1:end),:);     % 剩下的ntest个作为测试数据

train_set = zeros(nuser,nitem);
for i = 1:ntrain
    u = traindata(i,1);
    v = traindata(i,2);
    train_set(u,v) = traindata(i,3);
end
rated_mark = train_set; rated_mark(rated_mark>0) = 1;

baseline = zeros(nuser, nitem);
user_feature = 0.1 * rand(nuser, nfeature) / sqrt(nfeature);
item_feature = 0.1 * rand(nitem, nfeature) / sqrt(nfeature);
mean = mean_calc(train_set, rated_mark);

[user_bias, item_bias] = bias_calc(train_set, rated_mark, mean);
nrated = length(find(rated_mark==1));

X = zeros(nuser,nitem);
% train
for iter = 1 : Iterations
	sigma = 0;
    for u = 1 : nuser
        for i = 1 : nitem
            if rated_mark(u, i) == 1
                baseline(u, i) = mean + user_bias(u) + item_bias(i);
                predict_rate_train = baseline(u, i) + user_feature(u, :) * item_feature(i, :)';
                X(u,i) = predict_rate_train;
                eui = train_set(u, i) - predict_rate_train;
                temp_user_feature = user_feature(u, :);
                temp_item_feature = item_feature(i, :);
                
                user_bias(u) = user_bias(u) + gamma * (eui - lambda * user_bias(u));
                item_bias(i) = item_bias(i) + gamma * (eui - lambda * item_bias(i));
                user_feature(u, :) = temp_user_feature + gamma * (eui * temp_item_feature - lambda * temp_user_feature);
                item_feature(i, :) = temp_item_feature + gamma * (eui * temp_user_feature - lambda * temp_item_feature);
                sigma = sigma + eui^2;
            else
                baseline(u, i) = mean + user_bias(u) + item_bias(i);
            end
        end
    end
    train_mse = sigma / nrated;
    fprintf('Iteration = %d, train mse = %f\n', iter, train_mse);
end

test_sigma = 0;
for i = 1:ntest
   u = test_set(i, 1); 
   v = test_set(i, 2);
   r = test_set(i, 3);
   predict_rate = baseline(u, v) + user_feature(u, :) * item_feature(v, :)';
   X(u,v) = predict_rate;
   test_sigma = test_sigma + (predict_rate - r)^2;
end
test_mse = double(test_sigma) / ntest;
fprintf('test mse = %f\n', test_mse);
