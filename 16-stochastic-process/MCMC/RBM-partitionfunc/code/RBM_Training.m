clear all,close all,clc;

load('train.mat');          %载入训练数据
%% RBM初始化
opts.numepochs =   1;
opts.batchsize = 100;
opts.momentum  =   0;
opts.alpha     =   1;
training_data = MNIST_for_log;

%% 训练10个hidden unit的RBM
dbn.sizes = 10;
dbn = dbnsetup(dbn, training_data, opts);
dbn = dbntrain(dbn, training_data, opts);
parameter_W = dbn.rbm{1,1}.W';
parameter_a = dbn.rbm{1,1}.c';
parameter_b = dbn.rbm{1,1}.b';
save('trained_h10.mat','parameter_W','parameter_a','parameter_b');

%% 训练20个hidden unit的RBM
dbn.sizes = 20;
dbn = dbnsetup(dbn, training_data, opts);
dbn = dbntrain(dbn, training_data, opts);
parameter_W = dbn.rbm{1,1}.W';
parameter_a = dbn.rbm{1,1}.c';
parameter_b = dbn.rbm{1,1}.b';
save('trained_h20.mat','parameter_W','parameter_a','parameter_b');

%% 训练100个hidden unit的RBM
dbn.sizes = 100;
dbn = dbnsetup(dbn, training_data, opts);
dbn = dbntrain(dbn, training_data, opts);
parameter_W = dbn.rbm{1,1}.W';
parameter_a = dbn.rbm{1,1}.c';
parameter_b = dbn.rbm{1,1}.b';
save('trained_h100.mat','parameter_W','parameter_a','parameter_b');

%% 训练500个hidden unit的RBM
dbn.sizes = 500;
dbn = dbnsetup(dbn, training_data, opts);
dbn = dbntrain(dbn, training_data, opts);
parameter_W = dbn.rbm{1,1}.W';
parameter_a = dbn.rbm{1,1}.c';
parameter_b = dbn.rbm{1,1}.b';
save('trained_h500.mat','parameter_W','parameter_a','parameter_b');