clear all,close all,clc;
%将所有操作应用于完整的原图，并加以比较
load hall.mat;                  	%从hall.mat中获取数据(hall_gray)
hallg=hall_gray;                    %测试图像为hall.mat中的灰度图像hall_gray
                                    %另存为hallg,避免更改原始数据hall_gray
subplot(2,3,1);                     %子图1
imshow(hallg);                      %观察DCT系数矩阵不变时处理后的图像
title('原图','FontSize',8);         %标题
imwrite(hallg,'./chapter2_3and4/1原图.bmp');  %另存用图片浏览器浏览

%DCT系数矩阵右侧4列全部置零
DCT1=dct2(hallg);                 	%将hallp进行离散余弦变换
DCT1(:,37:40)=0;                 	%将DCT系数矩阵右侧4列全部置零
iDCT1=idct2(DCT1);               	%作离散余弦逆变换
subplot(2,3,2);                     %子图2
imshow(uint8(iDCT1));             	%观察DCT系数矩阵改变后处理后的图像
                                    %注意像素值用uint8类型表示，参与浮点运算的像素值要转换为unit8类型
title('DCT系数右4列置零','FontSize',8);   %标题
imwrite(uint8(iDCT1),'./chapter2_3and4/2右4列全部置零.bmp');      %另存用图片浏览器浏览

%DCT系数矩阵左侧4列全部置零
DCT2=dct2(hallg);                 	%将hallg进行离散余弦变换
DCT2(:,1:4)=0;                     	%将DCT系数矩阵左侧4列全部置零
iDCT2=idct2(DCT2);               	%作离散余弦逆变换
subplot(2,3,3);                     %子图2
imshow(uint8(iDCT2));             	%观察DCT系数矩阵改变后处理后的图像
                                    %注意像素值用uint8类型表示，参与浮点运算的像素值要转换为unit8类型
title('DCT系数左4列置零','FontSize',8);   %标题
imwrite(uint8(iDCT2),'./chapter2_3and4/3左4列全部置零.bmp');      %另存用图片浏览器浏览

%DCT系数矩阵进行转置操作
DCT3=dct2(hallg);                	%将hallp进行离散余弦变换
DCT3=DCT3';                      	%将DCT系数矩阵进行转置操作
iDCT3=idct2(DCT3);               	%作离散余弦逆变换
subplot(2,3,4);                     %子图2
imshow(uint8(iDCT3));             	%观察DCT系数矩阵改变后处理后的图像
                                    %注意像素值用uint8类型表示，参与浮点运算的像素值要转换为unit8类型
title('DCT系数矩阵转置','FontSize',8);    %标题
imwrite(uint8(iDCT3),'./chapter2_3and4/4转置.bmp');               %另存用图片浏览器浏览

%DCT系数矩阵旋转90度
DCT4=dct2(hallg);                 	%将hallp进行离散余弦变换
DCT4=rot90(DCT4);                  	%将DCT系数矩阵旋转90度
iDCT4=idct2(DCT4);               	%作离散余弦逆变换
subplot(2,3,5);                     %子图2
imshow(uint8(iDCT4));             	%观察DCT系数矩阵改变后处理后的图像
                                    %注意像素值用uint8类型表示，参与浮点运算的像素值要转换为unit8类型
title('DCT系数矩阵旋转90度(逆)','FontSize',8);  %标题
imwrite(uint8(iDCT4),'./chapter2_3and4/5逆时针旋转90度.bmp');     %另存用图片浏览器浏览

%DCT系数矩阵旋转180度                         
DCT5=dct2(hallg);                	%将hallp进行离散余弦变换
DCT5=rot90(DCT5);                  	%将DCT系数矩阵旋转90度
DCT5=rot90(DCT5);                  	%将DCT系数矩阵再旋转90度（共旋转180度）
iDCT5=idct2(DCT5);                  %作离散余弦逆变换
subplot(2,3,6);                     %子图2
imshow(uint8(iDCT5));             	%观察DCT系数矩阵改变后处理后的图像
                                    %注意像素值用uint8类型表示，参与浮点运算的像素值要转换为unit8类型
                                   	%注意像素值用uint8类型表示，参与浮点运算的像素值要转换为unit8类型
title('DCT系数矩阵旋转180度','FontSize',8);    %标题
imwrite(uint8(iDCT5),'./chapter2_3and4/6旋转180度.bmp');         %另存用图片浏览器浏览  
