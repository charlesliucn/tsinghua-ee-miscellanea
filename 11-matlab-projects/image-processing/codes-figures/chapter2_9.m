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
    QC(:,(i-1)*XNum+j)=zigzag1(Cell_QT); 	%对每小块的DCT系数矩阵扫描得到一个列矢量，所有列矢量构成矩阵
    end
end

%---------------DC系数编码--------------%
Err=QC(1,:);                            %亮度直流分量预测误差矢量
Category=zeros(1,Total_Num);          	%Category参量
Category(1)=ceil(log2(abs(Err(1))+1));  %对第一项预测误差进行单独处理      
Magnitude=deci2bin(Err(1));             %Magnitude是预测误差的二进制表示，负数则用1反码表示
                                        %deci2bin是专门为编码写的函数，详见deci2bin.m    
DCCode=[DCTAB(Category(1)+1,2:1+DCTAB(Category(1)+1,1)) Magnitude];     %第一项预测误差的编码
for i=2:Total_Num                           %从第2项DC系数开始依次进行处理
    Err(i)=QC(1,i-1)-QC(1,i);               %预测误差的计算
    Category(i)=ceil(log2(abs(Err(i))+1));  %Category参量的计算
    Magnitude=deci2bin(Err(i));             %Magnitude是预测误差的二进制表示
    DCCode=[DCCode DCTAB(Category(i)+1,2:1+DCTAB(Category(i)+1,1)) Magnitude];
                                            %将每项DC系数的编码并入DCCode矢量中
                                            %包含Category和Magnitude两部分
end

%-----------AC系数编码------------%
ACCode=[];                          %ACCode初始化为空矩阵
ZRL=[1,1,1,1,1,1,1,1,0,0,1];        %连续16个0，则插入ZRL，(F/0)编码为11111111001
EOB=[1,0,1,0];                      %编完最后一个非零AC系数，插入块结束符EOB，(0/0)编码为1010
for i=1:Total_Num                   %对扫描后所得的QC矩阵逐列进行处理
    Run=0;                          %行程Run初始化
    AC=QC(2:end,i);                 %每列的第一个元素为DC系数，剩余元素为AC系数
    last_nonz=find(AC~=0,1,'last'); %先找到最后一个非零系数，之后元素均为0元素
    if ~isempty(last_nonz)              %last_nonz可能为空矩阵（当AC全为0时）
        for j=1:last_nonz               %从AC系数向量的第一个一直到之前所得的最后一个非零系数
            if AC(j)==0                 %每逢零元素
                if Run<15               %判断是否连续16个零
                    Run=Run+1;          %未到连续16个零时，每逢零元素，行程加1
                else
                    ACCode=[ACCode ZRL];%连续16个零，则插入ZRL
                    Run=0;              %并且将Run重新置零
                end
            else                        %当AC系数是非零元素时
                Size=ceil(log2(abs(AC(j))+1));	%Size的计算/与Catagory相同
                Amplitude=deci2bin(AC(j));     	%Amplitude的计算/与Magnitude相同
                L=ACTAB(10*Run+Size,3);        	%获取AC编码的长度
                ACCode=[ACCode ACTAB(10*Run+Size,4:3+L) Amplitude]; 
                                                %得到该非零元素的编码
                                                %包括(Run/Size)联合体的Huffman编码和Amplitude
                Run=0;                         	%将Run重新置零
            end
        end
    end
    ACCode=[ACCode EOB];                        %每一列处理完都要加EOB，先验：每一列最后都会有若干零
end 

%图像尺寸
Height=leny;        %图像高度
Width=lenx;         %图像宽度

%输出为DC系数的码流、AC系数的码流、图像的高度和宽度，将四个变量写入jepgcodes.mat文件
save('jpegcodes.mat','DCCode','ACCode','Height','Width');
