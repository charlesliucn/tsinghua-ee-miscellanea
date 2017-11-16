clear all,close all,clc;
% 该文件以1号卫星的PRN序列为例，计算它与所有卫星PRN序列的相关函数
% 从而比较卫星PRN序列的自相关函数及与不同卫星的互相关函数

load('BD_Code.mat');        %不同的卫星PRN序列
SateNum = size(BD_Code,1);  %获取卫星的数目
cor = zeros(1,SateNum);     %初始化相关函数峰值的矢量
CodeA = BD_Code(1,:);       %以1号卫星为例，其PRN序列与所有卫星的PRN序列做相关
for i = 1:SateNum
    A_fft_conj = conj(fft(CodeA));  %1号卫星PRN序列（本地码）的共轭FFT
    B_fft = fft(BD_Code(i,:));      %另一个卫星PRN序列的FFT
    correlation = ifft(B_fft.*A_fft_conj);%以上两个频域相乘再取逆，得到时域的相关函数
    cor(i) = max(correlation);      %相关函数最大值
end
stem(1:SateNum,cor);                %作图
title('1号卫星与37颗卫星的相关峰值');xlabel('卫星编号');ylabel('相关峰值');