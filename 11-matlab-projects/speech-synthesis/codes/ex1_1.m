clear all,close all,clc;

a=[1,-1.3789,0.9506];       %定义输入信号系数
b=[1];                      %定义输出信号系数

%共振峰频率
[r,p,k]=residuez(b,a);      %求解极点
fs=8000;                    %采样频率取8000Hz
OMG=abs(angle(p));          %Ω=ωT=ω/fs
fp=OMG*fs/(2*pi)            %f=ω/(2*pi)

%用zplane,freq,impz分别绘出零极点分布图，频率响应和单位样值响应。
zplane(b,a);                %zplane作零极点分布图   
figure;                     %生成新图框
freqz(b,a);                 %freq作频率响应
figure;                     %生成新图框
impz(b,a);                  %impz作单位样值响应
set(gca,'XLim',[0,200]);    %修改x范围

%用filter绘出单位样值响应
figure;                     %生成新图框
n=[0:200]';                 %生成时间点
x=(n==0);                   %以单位样值序列作为激励信号
imp=filter(b,a,x);          %filter单位样值响应
stem(n,imp);                %作出单位样值响应

%比较impz和filter绘出的单位样值响应是否相同
figure;                     %生成新图框
impz(b,a);                  %用impz作出单位样值响应
set(gca,'XLim',[0,200]);    %修改x范围
hold on;                    %不擦除上图
stem(n,imp,'k-');           %用filter作出单位样值响应



