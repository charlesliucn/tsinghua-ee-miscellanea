clear all;close all;clc;

step = 50;
blocksize = 64;
% [rgb_mean,rgb_cov] = rgb_model_train();
img_detect = rgb_detect('in4483.bmp',step,blocksize);
img_comp = rgb_compare('in4483.bmp','in4483.bmp-detect.bmp','in4483-marked.bmp',1);

%% 对测试集进行结果评价
type = 3;
for i = 2:13
    rawname = sprintf('%d.bmp',i);
    detname = sprintf('%d.bmp-detect.bmp',i);
    markedname = sprintf('%d-marked.bmp',i);
    img_detect = rgb_detect(rawname,step,blocksize);
    img_comp = rgb_compare(rawname,detname,markedname,type);
end