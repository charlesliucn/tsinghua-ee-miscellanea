function acquisition= MyAlgorithm (filename)
% 基于FFT的相关捕获算法
% 输入：
%   filename：采样数据文件的文件名
% 输出：
%   acquisition：捕获的卫星，第一行是卫星编号，第二行是相位

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

%% 数据初步处理：将采样后的信号求平均
Group = count/Sample_Num;                       %分组，相当于得到采样数据中重复发送了多少次PRN序列
data_matrix = reshape(data,Sample_Num,Group);   %便于数据操作
data_mean = mean(data_matrix,2);                %不考虑噪声情况下，接收的信号是周期的，但各卫星信号相位不同
                                                %求平均值以此代表序列的特征
data_new = SampleMatchCode(data_mean',0.11);    %使用SampleMatchCode函数将data_mean转为长度为2046的离散信号

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
Threshold = SetThreshold(cor);                  %SetThreshold函数设置阈值
hold on;    plot(0:0.05:38,Threshold,'r');      %作出门限的位置，使结果更直观
result = find(cor > Threshold);                 %找出大于阈值的卫星，即为捕获的卫星
phase = maxindex(result);                       %捕获的卫星对应的相位
stem(1:SateNum,cor);                            %对各卫星对应的相关最大值作图
title('基于FFT的相关捕获算法--优化后');xlabel('卫星编号');ylabel('相关峰值');   %标注
acquisition = [result;phase];
