clear all;close all;clc;

%% 准备工作
imraw = imread('test.jpg');     % 读取图片文件
im = mat2gray(imraw);           % 转为灰度图
im = im(:,:,1);                 % 第三维度为1
figure(1);imshow(im);           % 展示原始图片
[nrow,ncol,~] = size(im);       % 获取图片大小
im_new = zeros(size(im));       % 初始化输出图像

%% 设计模板(fspecial为模板设置函数，avearge表示平均平滑滤波)
r = 1;                          % 模板大小
template = fspecial('gaussian',[2*r+1,2*r+1]); 	% 生成平均平滑模板

%% 图像边界的处理
im_conv = zeros(nrow + 2*r,ncol + 2*r);                     % 初始化含有边界的图像矩阵
im_conv(r+1:nrow+r,r+1:ncol+r) = im;                        % 原始图像部分
im_conv(1:r,:) = im_conv(r+1:r+r,:);                        % 上边界处理
im_conv(nrow+r+1:nrow+2*r,:) = im_conv(nrow+1:nrow+r,:);    % 下边界处理
im_conv(:,1:r) = im_conv(:,r+1:r+r);                        % 左边界处理
im_conv(:,nrow+r+1:nrow+2*r) = im_conv(:,nrow+1:nrow+r);    % 右边界处理

%% 基于模板卷积运算的线性平滑滤波
for i = r+1:nrow+r
    for j = r+1:ncol+r
        im_new(i-r,j-r) = sum(sum(im_conv(i-r:i+r,j-r:j+r).*template))/sum(sum(template));
    end
end

%% 展示滤波后结果
imnew = mat2gray(im_new);   % 格式转变
imnew = imnew(:,:,1);       % 灰度图像
figure(2);imshow(imnew);    % 展示线性平滑滤波后的图片
figure(3);imshow(im - imnew)% 展示滤波前后图片的差异
