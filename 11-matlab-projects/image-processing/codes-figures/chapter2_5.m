clear all,close all,clc;

a=1;        %定义输出信号系数
b=[-1,1];   %定义输入信号系数
freqz(b,a)  %系统频率响应
