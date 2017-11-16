clear all,close all,clc;

load hall.mat;                      %从hall.mat中获取数据(hall_gray)
hallg=hall_gray;                    %测试图像为hall.mat中的灰度图像hall_gray
                                    %另存为hallg,避免更改原始数据hall_gray
hallp=double(hallg(21:60,31:70));   %从灰度图像选取40*40一部分hallp,注意类型变化
hallp_sub=hallp-128*ones(40,40);    %将每个像素灰度值减去128
subplot(1,2,1);                     %子图1
imshow(hallp_sub);                  %观察第一种方法处理后的图像
imwrite(hallp_sub,'./chapter2_1/1减去128.bmp');    %另存为“1减去128.bmp”,看图软件浏览

%尝试在变换域中进行
DCTa=dct2(hallp);                   %将hallp进行离散余弦变换
DCTb=dct2(128*ones(40,40));         %离散余弦变换
hallp_trans=idct2(DCTa-DCTb);       %进行离散余弦逆变换，得到变换域的处理结果hallp_trans
subplot(1,2,2);                     %子图2
imshow(hallp_trans);                %观察变换域处理后的图像
imwrite(hallp_trans,'./chapter2_1/2变换域.bmp');    %另存为“2变换域.bmp”,看图软件浏览
diffmax=max(max(abs(hallp_sub-hallp_trans)))     %两种处理方法所得图像矩阵的元素之差的最大值
Cor=corr2(hallp_sub,hallp_trans)                 %两种处理方法所得图像矩阵的相关系数(比较相似度)

