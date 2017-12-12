clear all;close all;clc;
%% 基础题第8小题：图像水印
% by 无47 刘前 2014011216

%% 读入图像及准备工作
carrier = imread('Girl.bmp');   % 载体图像
hidden = imread('Couple.bmp');  % 隐藏图像
[height,width] = size(carrier); % 获取图像信息
PixelNum = height*width;        % 像素点总数
% 展示原始图像
subplot(2,2,1);
imshow(carrier);title('载体图像Girl.bmp原始图像');
subplot(2,2,2);
imshow(hidden);title('隐藏图像Couple.bmp原始图像');

%% 1.单幅迭代混合
alpha = 0.7;                    % 混合参数
carrier = double(carrier);      % 转成double型数据进行隐藏处理
hidden = double(hidden);        % 转成double型数据进行隐藏处理
mix1 = alpha*carrier + (1 - alpha)*hidden;    	% 混合后图像
subplot(2,2,3);                 % 展示混合图像结果
imshow(uint8(mix1));title('混合图像');

mix1 = double(uint8(mix1));
hidden_rec1 = (mix1 - alpha*carrier)/(1-alpha);	% 恢复隐藏图像
subplot(2,2,4);                 % 展示恢复图像结果
imshow(uint8(hidden_rec1));title('恢复图像');
% 计算均方误差
RMSE1 = sqrt(sum(sum((hidden_rec1 - hidden).^2))/PixelNum);

%% 多次迭代
% 2次
mix1 = alpha*carrier + (1 - alpha)*hidden;    	% 混合后图像
mix2 = alpha*carrier + (1 - alpha)*mix1;    	% 混合后图像
mix2 = double(uint8(mix2));
hidden_rec2 = (mix2 - alpha*carrier)/(1-alpha);	% 恢复隐藏图像
hidden_rec2 = (hidden_rec2 - alpha*carrier)/(1-alpha);	% 恢复隐藏图像
RMSE2 = sqrt(sum(sum((hidden_rec2 - hidden).^2))/PixelNum);

% 3次
mix2 = alpha*carrier + (1 - alpha)*mix1;    	% 混合后图像
mix3 = alpha*carrier + (1 - alpha)*mix2;    	% 混合后图像
mix3 = double(uint8(mix3));
hidden_rec3 = (mix3 - alpha*carrier)/(1-alpha);	% 恢复隐藏图像
hidden_rec3 = (hidden_rec3 - alpha*carrier)/(1-alpha);	% 恢复隐藏图像
hidden_rec3 = (hidden_rec3 - alpha*carrier)/(1-alpha);	% 恢复隐藏图像
RMSE3 = sqrt(sum(sum((hidden_rec3 - hidden).^2))/PixelNum);

figure;
subplot(2,3,1);imshow(uint8(mix1));title('迭代1次--混合图像');
subplot(2,3,2);imshow(uint8(mix2));title('迭代2次--混合图像');
subplot(2,3,3);imshow(uint8(mix3));title('迭代3次--混合图像');
subplot(2,3,4);imshow(uint8(hidden_rec1));title('迭代1次--恢复图像');
subplot(2,3,5);imshow(uint8(hidden_rec2));title('迭代2次--恢复图像');
subplot(2,3,6);imshow(uint8(hidden_rec3));title('迭代3次--恢复图像');
%% 2.混合图像质量和参数的关系
RMSE_carrier = [];              % 初始化载体图像RMSE
RMSE_hidden = [];               % 初始化隐藏图像恢复后RMSE
index = 0:0.001:1.0; 
% 以0.1为间隔，计算不同α值对应的均方根误差
for alpha = 0:0.001:1.0
    mix = alpha*carrier + (1 - alpha)*hidden;        % 混合图像
    mix = double(uint8(mix));
    RMSE_carrier = [RMSE_carrier,sqrt(sum(sum((mix - carrier).^2))/PixelNum)];      % 载体图像均方根误差
    mix = alpha*carrier + (1 - alpha)*hidden;        % 混合图像
    mix = double(uint8(mix));
    hidden_rec = (mix - alpha*carrier)/(1-alpha);    % 恢复的隐藏图像
    RMSE_hidden = [RMSE_hidden,sqrt(sum(sum((hidden_rec - hidden).^2))/PixelNum)];  % 恢复图像均方根误差
end
% 作图
figure;
subplot(1,2,1);plot(index,RMSE_carrier);title('混合图像均方根误差 v.s. α');xlabel('混合参数α');ylabel('RMSE');
subplot(1,2,2);plot(index,RMSE_hidden);title('恢复图像均方根误差 v.s. α');xlabel('混合参数α');ylabel('RMSE');
figure;plot(index,RMSE_carrier+RMSE_hidden);title('混合图像与恢复图像均方根误差和 v.s. α');xlabel('混合参数α');ylabel('RMSE');