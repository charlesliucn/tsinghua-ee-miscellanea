clear all,close all,clc;

load hall.mat;                  %获取hall.mat中hall_gray的数据
hallg=double(hall_gray);        %uint8到double的类型转换

%对信息进行空域隐藏
info='Hello World';             %需要隐藏的信息(字符串)
info_bin=dec2bin(double(info)); %将字符串转换为char型，存储二进制
[height,width]=size(info_bin);  %获取info_bin的宽高，事实上height等于隐藏信息的字符串的长度
len=height*width;               %获取二进制字符串的长度
info_bit=[];                    %二进制数组初始化
for i=1:height  
    for j=1:width
    info_bit=[info_bit str2num(info_bin(i,j))];    
    end                        	%得到info_bit数组，存储了需要隐藏的字符串的二进制数组形式
end
for i=1:len                     %隐藏到图像中，用信息位逐一替换图像各像素点的灰度最低位
    bit=deci2bin(hallg(i));  	%获取图像像素点的灰度值，并转换为二进制数组
    bit(end)=info_bit(i);       %将该像素点灰度的最低位替换为对应序号的需要隐藏的信息位
    hallg(i)=bin2deci(bit);     %再将改变后的像素灰度转换回十进制数形式
end
%imshow(uint8(hallg));          %查看空域隐藏信息之后的图像

%提取隐藏的信息
for i=1:len                     %len为隐藏信息的字符串长度
    bit=deci2bin(hallg(i));     %对该长度范围内的每一像素点的灰度值进行处理
    exc(i)=bit(end);            %提取出每个灰度值的最低位
end
exc=reshape(exc,width,height);  %改变矩阵的长宽
info_exc=[];                    %提取出的信息 初始化
for i=1:height                  %获取隐藏的字符串中每一个字符的ASII值
    info_exc=[info_exc uint8(bin2deci(exc(:,i)))];  
end                             %并且转换为uint8类型
info_exc=char(info_exc)         %将ASCII数组转换为字符串