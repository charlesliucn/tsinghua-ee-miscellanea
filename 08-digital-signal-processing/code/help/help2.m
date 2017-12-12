clear all,close all,clc;
% 帮助文件2
% 功能：用于观察各卫星PRN序列与处理后的采样数据的相关函数
%       帮助查看是否有峰值，且峰值的绝对大小，可以人为观察判断哪些卫星可能被捕获
%% 基本参数
CodeRate = 2.046e6;         %扩频信号码率：每秒2.046e6个码
CodeLength = 2046;          %北斗卫星信号码长
Fs = 10e6;                  %对接收信号的采样率
load('BD_Code.mat');        %不同的卫星PRN序列

%% 导入采集的数据
%fid = fopen('Test_Data_int16.dat', 'r');   %大作业提供的测试数据，已知包含前5颗卫星的扩频信号
fid = fopen('UEQ_rawFile_int16.dat','r');   %大作业提供的数据，包含的卫星数及编号未知
[data, count] = fread(fid, inf ,'int16');   %获取采样的数据信息
SateNum = size(BD_Code,1);                  %获取卫星数目
Sample_Num = CodeLength/CodeRate*Fs;        %2046个码在采样信号中对应的数目(10000)

%% 数据初步处理：将采样后的信号求平均
Group = count/Sample_Num;                   %分组，相当于得到采样数据中重复发送了多少次PRN序列
data_matrix = reshape(data,Sample_Num,Group);   %便于数据操作
data_mean = mean(data_matrix,2);            %不考虑噪声情况下，接收的信号是周期的，但各卫星信号相位不同
                                            %求平均值以此代表序列的特征
data_new = SampleMatchCode(data_mean',0.11);%使用SampleMatchCode函数将data_mean转为长度为2046的离散信号
for i = 1:SateNum
     Code_fft_conj = conj(fft(BD_Code(i,:)));  	%PRN序列（本地码）的共轭FFT
    data_fft = fft(data_new);                   %接收信号（处理后）的FFT
    correlation = ifft(data_fft.*Code_fft_conj);%以上两个频域相乘再取逆，得到时域的相关函数
    figure(i);                              %新图框
    stem(correlation);                      %作图
end
