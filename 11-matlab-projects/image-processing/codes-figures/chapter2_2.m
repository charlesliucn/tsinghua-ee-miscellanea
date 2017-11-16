clear all,close all,clc;

load hall.mat;                      %从hall.mat中获取数据(hall_gray)
hallg=hall_gray;                    %测试图像为hall.mat中的灰度图像hall_gray
                                    %另存为hallg,避免更改原始数据hall_gray
hallp=double(hallg(21:60,31:70));   %从灰度图像选取40*40一部分hallp,注意类型变化
DCT1=dct2(hallp);                   %自写二维DCT函数mydct2
DCT2=mydct2(hallp);                 %MATLAB自带dct2

diffmax=max(max(abs(DCT1-DCT2)))    %自写二维DCT函数mydct2与MATLAB自带dct2对比
Corr=corr2(dct2(hallp),mydct2(hallp))  %两个矩阵所得结果的相关系数(比较结果是否一致) 
