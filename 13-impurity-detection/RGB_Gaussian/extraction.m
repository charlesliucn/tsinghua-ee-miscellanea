function [impurity,tabacoo] = extraction(img_raw,img_marked,type)
% 函数功能：从已经标记出杂质的烟草图像训练样本中提取出杂质图像(将烟草与杂质分离)
% 参数说明：
%   输入：
%       img_raw：        原始图像矩阵
%       img_marked：     标记出杂质的图像矩阵
%       type：           烟草图像的类别
%               in44**.bmp          type = 1
%           	20161121-**.bmp     type = 2
%
%   输出：
%       impurity：       元胞数组，存储了提取出的杂质图像
%       tabacoo：        提取出杂质之后剩下的烟草图像
%  Copyright (c) 2017, Liu Qian All rights reserved. 

%% 准备工作
[height,width,~] = size(img_raw);   %获取图像大小信息
maximum = height * width;           %像素点数量
img_dif = img_marked - img_raw;     %标记的图像与原始图像的差别，有助于杂质和烟草的分离
img_refer = img_dif(:,:,type);      %RGB三维中选取其中一维。对于红色框标记的杂质，选取R，即type = 1;绿色框标记的type = 2
index = find(img_refer ~= 0)';      %找到边框
pos = [];                           %pos用于存储每个杂质图像的最左上角的像素点的位置

%% 寻找杂质的位置
for i = index(index <= maximum - height - 1)
    if ( img_refer(i) ~= 0 && img_refer(i-height) ~= 0 && img_refer(i+1) ~=0 && img_refer(i-1) ~=0 && img_refer(i + height) ~= 0 ...
         && img_refer(i + height + 1) == 0) && img_refer(i-4*height-4) ~=0 && img_refer(i-4*height-5) == 0 && img_refer(i-5*height-4) ==0 ...
         && img_refer(i-4*height-3) ~= 0 && img_refer(i-3*height-4) ~= 0  %很长的判断条件
    pos = [pos,i];                  %存储找到的位置
    end
end
pos = pos + height + 1;             %运算后的结果实际上才是杂质的最左上角的像素
%% 初始化
block_num = length(pos);            %杂质图像的数目
blockh = zeros(1,block_num);    blockw = zeros(1,block_num);
pos_x = zeros(1,block_num);     pos_y = zeros(1,block_num);
impurity = cell(1,block_num);       %初始化元胞数组，用于存储杂质图像

%% 对每个杂质图像进行提取，提取后从原图中删除该部分杂质
for i = 1:block_num
    pos_x(i) = fix(pos(i)/height)+1;
    pos_y(i) = mod(pos(i),height);
    for j = 1:height
        if (pos_y(i) + j <= height)
            if (img_refer(pos(i) + j) ~= 0)
                if(img_refer(pos(i) + j - height + 5) ~= 0), continue;
                else blockh(i) = j; break;
                end
            end
        else blockh(i) = height - pos_y(i) + 1;
        end
    end
    for j = 1:width
        if (pos_x(i) + j <= width)
            if(img_refer(pos(i) + j*height) ~=0)
                if(img_refer(pos(i) + j*height + 5*height - 1) ~= 0),continue;
                else blockw(i) = j; break;
                end
            end
        else blockw(i) = width - pos_x(i) + 1;
        end
    end
    impurity{i} = img_raw(pos_y(i):pos_y(i)+blockh(i)-1, pos_x(i):pos_x(i)+ blockw(i)-1,:);
    img_raw(pos_y(i):pos_y(i)+blockh(i)-1, pos_x(i):pos_x(i)+ blockw(i)-1,:) = 0;
    tabacoo = img_raw;              %删除杂质后的烟草图像
end
