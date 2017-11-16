clear all,close all,clc;
% 本.m文件为最初实现的算法，核心思想是基于FFT的相关计算。
% 对采样数据的预处理过程详见注释，主要将长度为20,000,000的数据转为长度为2046的数据
% 需要说明的问题：
% 1. PRN序列长度为2046，每个周期采样得到的数据长度为10000
% 2. 该.m是按照一定间隔从(20,000,000个数据求平均后的)10000个采样数据选择数据，构成长度为2046的离散信号
% 3. 判决门限是人为观察作图结果后设定的，因而不能作为一般算法
% 之后的版本将对以上问题进行修改和完善

%% 基本参数
CodeRate = 2.046e6;         %扩频信号码率：每秒2.046e6个码
CodeLength = 2046;          %北斗卫星信号码长
Fs = 10e6;                  %对接收信号的采样率
load('BD_Code.mat');        %不同的卫星PRN序列

%% 导入采集的数据
%fid = fopen('Test_Data_int16.dat', 'r');   %大作业提供的测试数据，已知包含前5颗卫星的扩频信号
fid = fopen('UEQ_rawFile_int16.dat','r');   %大作业提供的数据，包含的卫星数及编号未知
[data, count] = fread(fid, inf ,'int16');   %读取文件，获取采样的数据信息
SateNum = size(BD_Code,1);                  %卫星总数目
Sample_Num = CodeLength/CodeRate*Fs;        %2046个码在采样信号中对应的数目(10000)

%% 数据初步处理：将采样后的信号分成2000组后求平均
Group = count/Sample_Num;                       %分组，相当于得到采样数据中重复发送了多少次PRN序列
data_matrix = reshape(data,Sample_Num,Group);  	%便于数据操作
data_mean = mean(data_matrix,2);                %不考虑噪声情况下，接收的信号是周期的，但各卫星信号相位不同
                                                %求平均值以此代表序列的特征
data_new = data_mean(1:Sample_Num/CodeLength:Sample_Num)';  %从长度为10000的data_mean中间隔选取2046个采样值

%% 逐个卫星与接收信号求相关，大于阈值即说明包含该卫星信号
cor = zeros(1,SateNum);                         %处理化，存储相关函数的最大值
maxindex = zeros(1,SateNum);                    %处理相关函数最大值对应的序号（当作延迟或者相位差）
%   使用频域计算相关函数
for i = 1:SateNum           
    Code_fft_conj = conj(fft(BD_Code(i,:)));    %PRN序列（本地码）的共轭FFT
    data_fft = fft(data_new);                   %接收信号（处理后）的FFT
    correlation = ifft(data_fft.*Code_fft_conj);%以上两个频域相乘再取逆，得到时域的相关函数
    [cor(i),maxindex(i)] = max(correlation);    %相关函数最大值及对应的序号（相位）
end
Threshold = 7e4;                                %此处的阈值（判决门限）还是人为设定的
hold on;    plot(0:0.05:38,Threshold,'r');      %作出门限的位置，使结果更直观
result = find(cor > Threshold);                 %找出大于阈值的卫星，即为捕获的卫星
phase = maxindex(result);                       %捕获的卫星对应的相位
stem(1:SateNum,cor);                            %对各卫星对应的相关最大值作图
title('基于FFT的相关捕获算法--version1(采样数据间隔选取)');xlabel('卫星编号');ylabel('相关峰值');    %标注