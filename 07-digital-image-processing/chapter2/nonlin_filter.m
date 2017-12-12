clear all;close all;clc;

%% 准备工作
imraw = imread('test.jpg');             % 读取图片文件
imraw = mat2gray(imraw);                % 转为灰度图
imraw = imraw(:,:,1);                   % 第三维度为1
figure(1);imshow(imraw);                % 展示原始图片

%% 中值滤波
im_medfil = medfilt2(imraw);
figure;imshow(im_medfil,[4,4]);
figure;imshow(imraw - im_medfil);

%% 