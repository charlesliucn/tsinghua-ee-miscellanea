clear all,close all,clc;
% 该.m文件是针对弱信号的捕获算法，基于FFT_Acquisition_ver2的程序进行了修改
% 主要思路是：由一次相关运算改为多次运算，从而减弱噪声的影响
% 间隔选取2000个周期中的某些周期，进行相关运算并且累加起来
% 对累加后的结果进行最大值检测，并与判决门限比较，判决门限的选取方法与之前相同
% 效果：准确性略有改善，时间复杂度增加较明显

%% 基本参数
CodeRate = 2.046e6;         %扩频信号码率：每秒2.046e6个码
CodeLength = 2046;          %北斗卫星信号码长
Fs = 10e6;                  %对接收信号的采样率
load('BD_Code.mat');        %不同的卫星PRN序列

%% 导入采集的数据
fid = fopen('Test_Data_int16.dat', 'r');   %大作业提供的测试数据，已知包含前5颗卫星的扩频信号
%fid = fopen('UEQ_rawFile_int16.dat','r');   %大作业提供的数据，包含的卫星数及编号未知
[data, count] = fread(fid, inf ,'int16');   %读取文件，获取采样的数据信息
SateNum = size(BD_Code,1);                  %卫星总数目
Sample_Num = CodeLength/CodeRate*Fs;        %2046个码在采样信号中对应的数目(10000)

%% 数据初步处理：将采样后的信号求平均
Group = count/Sample_Num;                       %分组，相当于得到采样数据中重复发送了多少次PRN序列
data_matrix = reshape(data,Sample_Num,Group);   %便于数据操作
data_mean = mean(data_matrix,2);                %不考虑噪声情况下，接收的信号是周期的，但各卫星信号相位不同
                                                %求平均值以此代表序列的特征
data_new = SampleMatchCode(data_mean',0.11);    %使用SampleMatchCode函数将data_mean转为长度为2046的离散信号

%% 逐个卫星与接收信号求相关，大于阈值即说明包含该卫星信号
correlation = zeros(SateNum,CodeLength);
cor = zeros(1,SateNum);                         %处理化，存储相关函数的最大值
maxindex = zeros(1,SateNum);                    %处理相关函数最大值对应的序号（当作延迟或者相位差）
% 使用频域计算相关函数(累计相关法)
NumPick = 20;                                   %从数据中选择的周期数目
interv = Group/NumPick;                         %选取周期时的间隔
for i = 1:SateNum
    Code_fft_conj = conj(fft(BD_Code(i,:)));    %PRN序列（本地码）的共轭FFT
    for j = 1:NumPick
        data_use = data_matrix(:,interv*(j-1)+1);   %间隔选取其中的NumPick个周期
        data_use = SampleMatchCode(data_use',0.11); %使用SampleMatchCode函数将data_mean转为长度为2046的离散信号
        data_fft = fft(data_use);                   %离散信号（处理后）的FFT
        correlation(i,:) = correlation(i,:) + ifft(data_fft.*Code_fft_conj); 
        %频域相乘再取逆，得到时域的相关函数，并且进行累加
    end
    [cor(i),maxindex(i)] = max(correlation(i,:));   %以最后累加之后的结果来判决是否捕获成功
end
Threshold = SetThreshold(cor);                  %SetThreshold函数设置阈值
hold on;    plot(0:0.05:38,Threshold,'r');      %作出门限的位置，使结果更直观
result = find(cor > Threshold);                 %找出大于阈值的卫星，即为捕获的卫星
phase = maxindex(result);                       %捕获的卫星对应的相位
stem(1:SateNum,cor);                            %对各卫星对应的相关最大值作图
title('基于FFT的相关捕获算法--优化后');xlabel('卫星编号');ylabel('相关峰值');   %标注