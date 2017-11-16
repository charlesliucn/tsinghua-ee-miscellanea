clear all,close all,clc;

a=[1,-1.3789,0.9506];       %定义输入信号系数
b=[1];                      %定义输出信号系数
[z,p,k]=tf2zp(b,a);         %求解9.2.1(1)极点
fs=8000;                    %采样频率取8000Hz
delta_omg=2*pi*150/fs.*sign(angle(p));  %推导的公式中的±△Ω
pn=p.*exp(1i*delta_omg);                %得到两个共轭的新极点
[B,A]=zp2tf(z,pn,k);                    %用zp2tf函数得到系数矩阵A,B





