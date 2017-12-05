clear all,close all,clc;
%% 说明
% 为保证估计结果的准确性，采用AIS算法
% 但是AIS算法计算复杂度较高，因而计算时间较长，请耐心等待，谢谢！ 
 fprintf(1,'不要着急，请耐心等待O(∩_∩)O~...\n');
%% 准备工作
load('test.mat');
[num1, num_hid, num2]=size(testbatchdata);      %获取测试数据大小
num_test = num1*num2;
data = [];                                      %整理测试数据的格式
for i=1:num2
	data = [data; testbatchdata(:,:,i)];
end

M_run = 100;            %AIS算法的运行次数
beta = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/10000:1.0];  %选取的beta向量，按照paper中建议的
fprintf(1,'................准备工作完成.................\n');
%% 归一化常数估计值和测试数据上的总似然值
load ('trained_h10.mat');
W = parameter_W;        %RBM的权重矩阵W
a = parameter_a;        %隐藏层的bias向量a
b = parameter_b;        %可见层的bias向量b
LogZ1 = AIS2(W,a,b,M_run,beta,testbatchdata);
Log_Like1 =  LikeliHood(W,a,b,LogZ1,data,num_test);
fprintf(1,'............................................\n');
fprintf(1,'对于h10.mat,归一化常数估计值(取log)为%6.6f\n',LogZ1);
fprintf(1,'对于h10.mat,测试数据上的似然值为%d\n',Log_Like1);
fprintf(1,'............................................\n');

load ('trained_h20.mat');
W = parameter_W;        %RBM的权重矩阵W
a = parameter_a;        %隐藏层的bias向量a
b = parameter_b;        %可见层的bias向量b
LogZ2 = AIS2(W,a,b,M_run,beta,testbatchdata);
Log_Like2 =  LikeliHood(W,a,b,LogZ2,data,num_test);
fprintf(1,'.............................................\n');
fprintf(1,'对于h20.mat,归一化常数估计值(取log)为%6.6f\n',LogZ2);
fprintf(1,'对于h20.mat,测试数据上的似然值为%d\n',Log_Like2);
fprintf(1,'.............................................\n');

load ('trained_h100.mat');
W = parameter_W;        %RBM的权重矩阵W
a = parameter_a;        %隐藏层的bias向量a
b = parameter_b;        %可见层的bias向量b
LogZ3 = AIS2(W,a,b,M_run,beta,testbatchdata);
Log_Like3 =  LikeliHood(W,a,b,LogZ3,data,num_test);
fprintf(1,'.............................................\n');
fprintf(1,'对于h100.mat,归一化常数估计值(取log)为%6.6f\n',LogZ3);
fprintf(1,'对于h100.mat,测试数据上的似然值为%d\n',Log_Like3);
fprintf(1,'.............................................\n');

load ('trained_h500.mat');
W = parameter_W;        %RBM的权重矩阵W
a = parameter_a;        %隐藏层的bias向量a
b = parameter_b;        %可见层的bias向量b
LogZ4 = AIS2(W,a,b,M_run,beta,testbatchdata);
Log_Like4 =  LikeliHood(W,a,b,LogZ4,data,num_test);
fprintf(1,'.............................................\n');
fprintf(1,'对于h500.mat,归一化常数估计值(取log)为%6.6f\n',LogZ4);
fprintf(1,'对于h500.mat,测试数据上的似然值为%d\n',Log_Like4);
fprintf(1,'.............................................\n');
