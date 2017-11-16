clear all,close all,clc;

load hall.mat;               	%从hall.mat中获取数据(hall_color)
hallc=hall_color;            	%测试图像为hall.mat中的彩色图像hall_color
                              	%另存为hallc,避免更改原始数据hall_color
[len,width,n]=size(hallc);   	%获取图像的长宽
slen=len/8;                 	%国际象棋棋盘为8*8
                                %slen表示每一小格的长度
swidth=width/8;               	%swidth表示每一小格的宽度
for i=1:8
    for j=1:8               
        if(mod((i+j),2)==1)   	%8*8的棋盘，发现棋盘中某一格(i,j)满足i+j为奇数则是黑色
                             	%i+j为偶数则为白色，保持原图，故不作处理
                             	%黑色(R,G,B)=(0,0,0)
            hallc((i-1)*slen+1:i*slen,(j-1)*swidth+1:j*swidth,1)=0;
            hallc((i-1)*slen+1:i*slen,(j-1)*swidth+1:j*swidth,2)=0;
            hallc((i-1)*slen+1:i*slen,(j-1)*swidth+1:j*swidth,3)=0;
        end
    end
end
imshow(hallc);                     %展示修改后图片
imwrite(hallc,'./chapter1_2/3hall_chess.bmp');      %另存为hall_chess.bmp,看图软件浏览

