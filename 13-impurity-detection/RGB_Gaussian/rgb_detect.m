function img_detect = rgb_detect(filename,step,blocksize)
% 函数功能：从所给烟草图像中对杂质进行检测：将图像分成小块，对每小块是否包含杂质进行检测
% 输入：
%   filename ：图片名(字符串)
%   step     ：重叠检测的步长
%   blocksize：块的边长。
%
% 输出：
%   img_detect：检测后得到的图像，对判定为烟草的部分作出了标记
%  Copyright (c) 2017, Liu Qian All rights reserved. 

    img = imread(filename);     % 读入图像
    [height,width,~] = size(img);
    
    % 对图像大小进行处理，方便重叠式地遍历图像
    extra = blocksize - step;   
    xneed = step - mod(extra,step);
    img_proc = [img,img(:,width-xneed+1:width,:)];              % 水平方向宽度的调整
    yneed =  step - mod(extra,step);
    img_proc = [img_proc;img_proc(height-yneed+1:height,:,:)];  % 竖直方向长度的调整

    % 此处进行了小小的处理，测试样例共分为两种类型，一种是接近方形的烟草图像
    % 一种是细长的烟草图像，考虑到不同因素对两种图像的影响，分别对两种类型的
    % 图像的阈值进行训练。此处阈值使用的是马氏(Mahalanobis)距离。
    if( height > 5000)  % 判断烟草图像的类别
        threshold = 48; % 针对近似方形图像的阈值
    else threshold = 23;% 针对细长型图像的阈值
    end
%     [rgb_mean,rgb_cov] = rgb_model_train();         % 导入对烟草图像训练的结果
    load('rgb_model.mat');
    invcov = inv(rgb_cov);
    for i = 0:step:height-blocksize                 % 重叠式遍历图像，对每个小块进行检测
        for j = 0:step:width-blocksize
            sample = img_proc(i+1:i+blocksize,j+1:j+blocksize,:);
            rfeat = mean(mean(sample(:,:,1)));      % R特征
            gfeat = mean(mean(sample(:,:,2)));      % G特征
            bfeat = mean(mean(sample(:,:,3)));      % B特征
            feat = [rfeat,gfeat,bfeat];         
            mahaDist = (feat - rgb_mean)*invcov*(feat - rgb_mean)'; % 马氏距离作为异常值检测的依据
            if mahaDist > threshold                 % 马氏距离大于某一阈值时，认为该小块包含杂质
                % 对相应的小块进行标注
                img_proc([i+1:i+step],j+1:j+step,1) = 255;
                img_proc([i+1:i+step],j+1:j+step,2) = 255;
                img_proc([i+1:i+step],j+1:j+step,3) = 255;
                img_proc(i+1:i+step,[j+1:j+step],1) = 255;
                img_proc(i+1:i+step,[j+1:j+step],2) = 255;
                img_proc(i+1:i+step,[j+1:j+step],3) = 255;
            end   
        end
    end
    img_detect = img_proc(1:height,1:width,:);              % 已经标注出杂质的图像
    imwrite(img_detect,sprintf('%s-detect.bmp',filename));  % 写入图片文件
end
