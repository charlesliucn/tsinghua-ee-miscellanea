clear all,close all,clc;

%单位样值串频率为200Hz
fs=8000;                            %采样频率为8000Hz
f_delta=200;                        %单位样值串频率为200Hz
num=floor(fs/f_delta);              %num为采样点的间隔
f_200=(mod([1:fs],num)==0)+0;       %选取num的倍数的点进行采样
                                    %加0可以将逻辑型变量转换为整数型
sound(f_200,8000);                  %以8kHz采样频率播放
pause(1.1);                         %停顿1.1s,将两种语音分开

%单位样值串频率为300Hz
fs=8000;                            %采样频率为8000Hz
f_delta=300;                        %单位样值串频率为300Hz
num=floor(fs/f_delta);              %num为采样点的间隔
f_300=(mod([1:fs],num)==0)+0;       %选取num的倍数的点进行采样
                                    %加0可以将逻辑型变量转换为整数型
sound(f_300,8000);                  %以8kHz采样频率播放
