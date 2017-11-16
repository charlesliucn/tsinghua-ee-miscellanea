clear all,close all,clc;

load hall.mat;                  %获取hall.mat数据
load JpegCoeff.mat;             %获取JpegCoeff.mat数据

%处理前准备
[leny,lenx]=size(hall_gray);    %获取hall_gray大小
hallg=hall_gray;                %测试图像为hall.mat中的灰度图像hall_gray
                             	%另存为hallg,避免更改原始数据hall_gray
XNum=ceil(lenx/8);             	%水平方向每8个像素,不是8的倍数需补全
YNum=ceil(leny/8);             	%竖直方向每8个像素,不是8的倍数需补全
Total_Num=XNum*YNum;            %8*8为1块，Total_Num计算总个数
index_y=8*ones(1,YNum);         %cell单元数组每个矩阵元素的竖直高度相等，均为8
index_x=8*ones(1,XNum);         %cell单元数组每个矩阵元素的水平长度相等，均为8

%分块
Cell=mat2cell(hallg,index_y,index_x);  	%将每个8*8的块当作1个cell单元元素
QC=zeros(8*8,Total_Num);                %对每块量化并进行Zig-Zag扫描之后的系数矩阵

%减少灰度、DCT量化、Zig-Zag扫描
for i=1:YNum                            %依次对每个8*8小块进行处理
    for j=1:XNum
    Cell{i,j}=double(Cell{i,j})-128;        %对每小块图像进行预处理，即将每个像素灰度减去128,注意类型转换！！
    Cell_DCT=dct2(Cell{i,j});               %DCT：离散余弦变换，得到二维DCT系数矩阵
    Cell_QT=round(Cell_DCT./QTAB);          %量化处理
    QC(:,(i-1)*XNum+j)=zigzag2(Cell_QT); 	%对每小块的DCT系数矩阵扫描得到一个列矢量，所有列矢量构成矩阵
    end
end
DC=QC(1,:);         %第一行元素为各个块的DC系数         