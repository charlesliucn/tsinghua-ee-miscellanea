function [img_comp] = rgb_compare(rawname,detname,markedname,type)
% 函数功能：使用RGB模型检测的烟草图像结果与真实的杂质结果在同一张图像中进行对比
% 输入：
%   rawname   ：原始待检测烟草图像文件名
%   detname   ：RGB检测之后的结果图像文件名
%   markedname：正确标记出杂质的图像文件名
%   type      ：正确标记出杂质的图像中用于框出杂质的颜色
%       type = 1,代表使用的是红色
%       type = 2,代表使用的是绿色
%       type = 3,代表使用的是蓝色
%  Copyright (c) 2017, Liu Qian All rights reserved. 

%% 读入三个图像
    img_raw = imread(rawname);
    img_detect = imread(detname);
	img_real = imread(markedname);

%% 初始化比较后的图像
    img_compr = img_detect(:,:,1);
    img_compg = img_detect(:,:,2);
    img_compb = img_detect(:,:,3);   
    img_comp = img_detect;
    
%% 在detect图像中找到框所在的位置
    img_dif = img_real - img_raw;
    img_dif = img_dif(:,:,type);  % 以RGB其中一种作为依据
    img_dif = find(img_dif ~=0);  
    % 全部统一用红色标出
    img_compr(img_dif) = 255;
    img_compg(img_dif) = 0;
    img_compb(img_dif) = 0;

    img_comp(:,:,1) = img_compr;
    img_comp(:,:,2) = img_compg;
    img_comp(:,:,3) = img_compb;
    % 将结果写入文件
    imwrite(img_comp,sprintf('%s-compare.bmp',rawname));
    
end


