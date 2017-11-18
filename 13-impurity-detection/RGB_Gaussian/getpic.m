clear all;close all;clc;
img_raw = imread('2.bmp');
img_marked = imread('2-marked.bmp');
[impurity1,tabacoo1] = extraction(img_raw,img_marked,3);
savepic(impurity1,1);
imwrite(tabacoo1,'tabacoo-1.bmp');

%% 第一幅图in4483.bmp
img_raw = imread('in4483.bmp');
img_marked = imread('in4483-marked.bmp');
[impurity1,tabacoo1] = extraction(img_raw,img_marked,1);
savepic(impurity1,1);
imwrite(tabacoo1,'tabacoo-1.bmp');
     
%% 第二幅图in4484.bmp
img_raw = imread('in4484.bmp');
img_marked = imread('in4484-marked.bmp');
[impurity2,tabacoo2] = extraction(img_raw,img_marked,1);
savepic(impurity2,2);
imwrite(tabacoo2,'tabacoo-2.bmp');

%% 第三幅图in4488.bmp
img_raw = imread('in4488.bmp');
img_marked = imread('in4488-marked.bmp');
[impurity3,tabacoo3] = extraction(img_raw,img_marked,1);
savepic(impurity3,3);
imwrite(tabacoo3,'tabacoo-3.bmp');

%% 第四幅图20161121-04.bmp
img_raw = imread('20161121-04.bmp');
img_marked = imread('20161121-04-marked.bmp');
[impurity4,tabacoo4] = extraction(img_raw,img_marked,2);
savepic(impurity4,4);
imwrite(tabacoo4,'tabacoo-4.bmp');

%% 第五幅图20161121-06.bmp
img_raw = imread('20161121-06.bmp');
img_marked = imread('20161121-06-marked.bmp');
[impurity5,tabacoo5] = extraction(img_raw,img_marked,2);
savepic(impurity5,5);
imwrite(tabacoo5,'tabacoo-5.bmp');