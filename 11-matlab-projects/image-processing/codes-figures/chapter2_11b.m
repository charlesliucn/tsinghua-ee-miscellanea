clear all,close all,clc;
%用客观（PSNR）和主观方法评价编解码效果
load jpegdecodes.mat;
load hall.mat;

hallg=hall_gray;         	%测试图像为hall.mat中的灰度图像hall_gray
                            %另存为hallg,避免更改原始数据hall_gray
[Height,Width]=size(hallg); %获取图像大小
PixelNum=Height*Width;      %总像素数目，用于计算MSE
MSE=1/PixelNum*sum(sum((double(hallg_rec)-double(hallg)).^2));
                            %根据公式计算MSE
PSNR=10*log10(255^2/MSE);   %根据公式计算PSNR
subplot(1,2,1);             %子图1
imshow(hallg);              %作出原图
title('原图');              %设定标题
imwrite(hallg,'./chapter2_11/1原图.bmp');  %另存用图片浏览器浏览
subplot(1,2,2);            	%子图2
imshow(hallg_rec);          %作出经过JPEG编码和解码之后复原得到的图
title('JPEG编解码复原图');   %设定标题
imwrite(hallg_rec,'./chapter2_11/2JPEG编解码复原图.bmp');  %另存用图片浏览器浏览