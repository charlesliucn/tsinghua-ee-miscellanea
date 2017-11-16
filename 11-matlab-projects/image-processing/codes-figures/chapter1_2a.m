clear all,close all,clc;

load hall.mat;                      %从hall.mat中获取数据(hall_color)
hallc=hall_color;                   %测试图像为hall.mat中的彩色图像hall_color
                                    %另存为hallc,避免更改原始数据hall_color
imshow(hallc);                      %展示原图
imwrite(hallc,'./chapter1_2/0hall_origin.bmp');	%另存为hall_origin.bmp，看图软件浏览

[len,width,n]=size(hallc);          %获取图像的长宽
radius=min(len,width)/2;            %长和宽中较小值为半径
center_x=len/2;                     %中间点的横坐标
center_y=width/2;                   %中间点的纵坐标
for i=1:len
    for j=1:width
        dis_sq=(i-center_x)^2+(j-center_y)^2;   %计算(i,j)到中心点距离的平方
        if(dis_sq<=radius^2)        %判断点(i, j)属于圆内
            hallc(i,j,1)=255;       %将圆内的每一像素点置为红色
            hallc(i,j,2)=0;         %(R,G,B)=(255,0,0)
            hallc(i,j,3)=0;
        end
    end
end

figure;
imshow(hallc);                      %展示修改后图像
imwrite(hallc,'./chapter1_2/1hall_circle.bmp');    %另存为hall_circle.bmp,看图软件浏览