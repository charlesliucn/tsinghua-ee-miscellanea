clear all,close all,clc;

FaceNum=33;
L=5;
colornum=2^(3*L);
v_sum=zeros(1,colornum);
 for i=1:FaceNum
    filename=sprintf('%i.bmp',i);   %各图像文件名
    Face=imread(filename);        	%读取图片
    u=ColorExc(L,Face);
    v_sum=v_sum+u;
 end
 v3=v_sum/FaceNum;
 save('v3.mat','v3');