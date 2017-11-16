clear all;close all;clc;

%% 准备工作
imraw = imread('test.jpg');     % 读取图片文件
im = mat2gray(imraw);           % 转为灰度图
im = im(:,:,1);                 % 第三维度为1
figure(1);imshow(im);           % 展示原始图片

%% 设计模板(fspecial为模板设置函数，avearge表示平均平滑滤波)
r = 1;                                          % 模板大小
template = fspecial('average',[2*r+1,2*r+1]); 	% 生成平均平滑模板
img=imfilter(im,template,'replicate');          % 运算时的边界处理
figure(2);imshow(img);
imshow(im - img);
