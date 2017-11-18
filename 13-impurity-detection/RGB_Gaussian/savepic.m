function [] = savepic(impurity,picnumber)
% 函数功能：保存图片
%   输入：
%       impurity： extraction函数输出的杂质图像元胞数组
%       picnumber：图像序号(用于杂质图像的命名)
%  Copyright (c) 2017, Liu Qian All rights reserved. 

    npic = length(impurity);
    for i = 1:npic
         imwrite(impurity{i},sprintf('%d-%d.bmp',picnumber,i));
    %    imwrite(impurity{i},sprintf('./impurity/%d-%d.bmp',picnumber,i));   %存到当前目录的impurity文件夹内
    end
end