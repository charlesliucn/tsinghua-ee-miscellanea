function [u] = ColorExc(L,Face)
% 函数功能：提取图像的颜色特征
% 输入：    L用于衡量颜色的种类数，Face是图像矩阵
% 返回值：  颜色特征，各种不同颜色的比例构成的矢量
    
    [width,len,dim]=size(Face);
    pixelnum=width*len;
    colornum=2^(3*L);
    adder=1/pixelnum;
    u=zeros(1,colornum);
    for i=1:width
        for j=1:len
            Color=double(Face(i,j,:));
            Color=floor(Color/2^(8-L));
            n=1+2^(2*L)*Color(1)+2^L*Color(2)+Color(3);
            u(n)=u(n)+adder;
        end
    end
end