clear all;close all;clc;
%% 基础题第2小题：图像消噪
% by 无47 刘前 2014011216

%% 读入图片，准备数据
lena = imread('Lena.bmp');
[height, width] = size(lena);
imwrite(lena,'Lena.png');

%% 1.给Lena图添加高斯和椒盐噪声
%添加高斯噪声
mu = 20;        % 高斯噪声均值
sigma = 5;    % 高斯噪声方差
% gaussian_noise = sqrt(sigma2) * randn(height,width) + mu;	% 高斯噪声
gaussian_noise = normrnd(mu,sigma,height,width);            % 高斯噪声
lena_gn = lena + uint8(gaussian_noise);                 	% 添加了高斯噪声的Lena图
imshow(lena_gn);
imwrite(lena_gn,'GN.png');

%添加椒盐噪声
Pa = 0.1;                       % （黑色）噪声出现概率
Pb = 0.2;                       % （白色）噪声出现概率
I1 = rand(height,width) < Pa;
I2 = rand(height,width) < Pb;
lena_sn = lena;
lena_sn(I1&I2) = 0;
lena_sn(I1&~I2) = 255;
figure;imshow(lena_sn);

%% 2. 使用均值滤波和中值滤波两种方法消除噪声
% 消除高斯噪声
    figure;
    lena_gn_mean = meanfilter(lena_gn,3);       % 使用3*3的模板对添加了高斯噪声的Lena图去噪:均值滤波
    lena_gn_medi = medifilter(lena_gn,3);       % 使用3*3的模板对添加了高斯噪声的Lena图去噪:中值滤波
    % 展示结果
    subplot(2,2,1);imshow(lena);title('1.原始Lena图');
    subplot(2,2,2);imshow(lena_gn);title('2.添加高斯噪声后');
    subplot(2,2,3);imshow(lena_gn_mean);title('3.均值滤波后');
    subplot(2,2,4);imshow(lena_gn_medi);title('4.中值滤波后');

% 消除椒盐噪声
    figure;
    lena_sn_mean = meanfilter(lena_sn,3);       % 使用3*3的模板对添加了椒盐噪声的Lena图去噪:均值滤波
    lena_sn_medi = medifilter(lena_sn,3);       % 使用3*3的模板对添加了椒盐噪声的Lena图去噪:中值滤波
    % 展示结果
    subplot(2,2,1);imshow(lena);title('1.原始Lena图');
    subplot(2,2,2);imshow(lena_sn);title('2.添加椒盐噪声后');
    subplot(2,2,3);imshow(lena_sn_mean);title('3.均值滤波后');
    subplot(2,2,4);imshow(lena_sn_medi);title('4.中值滤波后');

%% 3. 计算消噪后均方根误差和峰值信噪比
PixelNum = height*width;
% (1) 高斯噪声
    % 均值滤波
    MSE1 = sum(sum((lena_gn_mean - lena).^2))/PixelNum;
    RMSE1 = sqrt(MSE1);
    PSNR1 = 10*log10(255*255/MSE1);
    % 中值滤波
    MSE2 = sum(sum((lena_gn_medi - lena).^2))/PixelNum;
    RMSE2 = sqrt(MSE2);
    PSNR2 = 10*log10(255*255/MSE2);

% (2) 椒盐噪声
    % 均值滤波
    MSE3 = sum(sum((lena_sn_mean - lena).^2))/PixelNum;
    PSNR3 = 10*log10(255*255/MSE3);
    RMSE3 = sqrt(MSE3);
    % 中值滤波
    MSE4 = sum(sum((lena_sn_medi - lena).^2))/PixelNum;
    RMSE4 = sqrt(MSE4);
    PSNR4 = 10*log10(255*255/MSE4);