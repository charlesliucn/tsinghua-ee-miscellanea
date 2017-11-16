clear all,close all,clc;
%DCT系数矩阵左侧4列全部置零(选取35*35一小块)
load hall.mat;                      %从hall.mat中获取数据(hall_gray)
hallg=hall_gray;                    %测试图像为hall.mat中的灰度图像hall_gray
                                    %另存为hallg,避免更改原始数据hall_gray
hallp=hallg(26:60,66:100);          %选取原图的一部分
subplot(1,2,1);                     %子图1
imshow(hallp);                      %观察DCT系数矩阵不变时处理后的图像

DCT=dct2(hallp);                    %将hallg进行离散余弦变换
DCT(:,1:4)=0;                       %将DCT系数矩阵左侧4列全部置零
iDCT=idct2(DCT);                    %作离散余弦逆变换
subplot(1,2,2);                     %子图2
imshow(uint8(iDCT));             	%观察DCT系数矩阵改变后处理后的图像
                                    %注意像素值用uint8类型表示，参与浮点运算的像素值要转换为unit8类型
imwrite(uint8(iDCT),'./chapter2_3and4_35×35/3左侧4列置零_35×35.bmp');        