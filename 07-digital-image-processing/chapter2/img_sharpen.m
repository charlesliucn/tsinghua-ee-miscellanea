clear all;close all;clc;

%% 准备工作
imraw = imread('test.jpg');             % 读取图片文件
imraw = mat2gray(imraw);                % 转为灰度图
imraw = imraw(:,:,1);                   % 第三维度为1
figure(1);imshow(imraw);                % 展示原始图片

%%
num = [1,2,5,10,20,50];
figure;
for i = 1:length(num)
    r = num(i);                                     % 模板大小
    template = fspecial('laplacian');               % 生成拉普拉斯锐化模板
 	img1 = imfilter(imraw,template,'replicate'); 	% 运算时的边界处理
    subplot(3,4,2*i-1);imshow(img1);
    subplot(3,4,2*i);imshow(imraw-img1);
end
figure;
for i = 1:length(num)
    r = num(i);                                     % 模板大小
    template = fspecial('laplacian');               % 生成平均平滑模板
 	img1 = imfilter(imraw,template,'symmetric'); 	% 运算时的边界处理
    subplot(3,4,2*i-1);imshow(img1);
    subplot(3,4,2*i);imshow(imraw-img1);
end
figure;
for i = 1:length(num)
    r = num(i);                                     % 模板大小
    template = fspecial('laplacian');               % 生成平均平滑模板
 	img1 = imfilter(imraw,template,'circular');   	% 运算时的边界处理
    subplot(3,4,2*i-1);imshow(img1);
    subplot(3,4,2*i);imshow(imraw-img1);
end
