clear all,close all,clc;
%雪花图像进行JPEG编解码处理
load snow.mat;                  %获取snow.mat数据
load JpegCoeff.mat;             %获取JpegCoeff.mat数据
%QTAB=QTAB/2;                    %将量化步长减小为原来的一半

%-------------------------------------------编码开始---------------------------------------------%
%处理前准备
[leny,lenx]=size(snow);    %获取snow大小
snows=snow;                %测试图像为snow.mat中的灰度图像snow
                             	%另存为snows,避免更改原始数据snow
XNum=ceil(lenx/8);             	%水平方向每8个像素,不是8的倍数需补全
YNum=ceil(leny/8);             	%竖直方向每8个像素,不是8的倍数需补全
Total_Num=XNum*YNum;            %8*8为1块，Total_Num计算总个数
index_y=8*ones(1,YNum);         %cell单元数组每个矩阵元素的竖直高度相等，均为8
index_x=8*ones(1,XNum);         %cell单元数组每个矩阵元素的水平长度相等，均为8

%分块
Cell=mat2cell(snows,index_y,index_x);  	%将每个8*8的块当作1个cell单元元素
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
%---------------------------------------------编码结束----------------------------------------%

%---------------------------------------------计算压缩比--------------------------------------%
DCL=length(DCCode);         %DC系数编码的码流长度
ACL=length(ACCode);     	%AC系数编码的码流长度
InputL=Height*Width*8;  	%输入文件长度，转换为二进制，每个像素需要8位
OutputL=DCL+ACL;        	%输出码流长度，包含DC系数编码码流和AC系数编码码流
COMR=InputL/OutputL;        %压缩比=输入文件长度/输出码流长度
%---------------------------------------------计算结束----------------------------------------%

%---------------------------------------------解码开始----------------------------------------%
%DCCode解码得到DC系数
ErrDec=[];              %解码所得的预测误差向量ErrDec初始化
DLTAB=DCTAB(:,1);       %DC系数预测误差的码本中编码的长度
NumDC=length(DLTAB);    %DC系数预测误差的码本的Category总数
DCL=length(DCCode);     %DC系数预测误差编码后DCCode的码流总长度
code_start=1;           %解码时，起始是Huffman编码部分，故使用code_start表示Huffman码的起始位
while(code_start<=DCL)  %判断解码未完成时
    for CT=1:NumDC      %在码本中寻找与码流匹配的Category，与每个Category对比
        code_end=code_start+DLTAB(CT)-1;    %Huffman码的终止位，与尝试匹配时所选的Category有关
        if (DCTAB(CT,2:DLTAB(CT)+1))==DCCode(code_start:code_end)   %完全匹配，找到码本中对应的行
            Category=CT-1;                  %获取Category
            break;      %不再与码本之后的内容对比
        end
    end
    bit_start=code_end+1;              	%对于每个被编码的DC系数预测误差，Huffman码之后即为Magnitude部分
    if Category==0
        ErrDec=[ErrDec 0];            	%当Category为0时，单独处理，此时表明预测误差为0，解码出0
        code_start=bit_start+1;       	%下一位是下一个DC预测误差的Huffman码的起始位
    else
        bit_end=bit_start+Category-1; 	%其他情况下，由Category计算出Magnitude的终止位
        bits=DCCode(bit_start:bit_end);	%起始位和终止位之间的部分是预测误差对应的Magnitude，即bits
        ErrDec=[ErrDec bin2deci(bits)];	%根据bits由函数bin2cdeci得到十进制形式的预测误差，并入预测误差向量
        code_start=bit_end+1;         	%该预测误差解码完毕，更新下一预测误差的Huffman码起始位置
    end
end
DCDec=ErrDec;                     	%准备由预测误差向量得到DC系数
for i=2:length(ErrDec)
    DCDec(i)=DCDec(i-1)-ErrDec(i); 	%倒推得到DC系数向量DCDec,即为解码后的DC系数部分
end

%AC解码
ZRL=[1,1,1,1,1,1,1,1,0,0,1];	%ZRL的编码，表示AC系数中16个连零
EOB=[1,0,1,0];                  %结束符EOB的编码，AC系数每63个为一块，每块结尾都有结束符
ACDec=[];                    	%解码所得的AC系数向量初始化
ALTAB=ACTAB(:,3);           	%AC系数码本中不同Run/Size的码长L
NumAC=length(ALTAB);          	%AC系数码本中不同Run/Size的总个数
ACL=length(ACCode);         	%AC编码码流总长度
zero_dbg=zeros(1,5);           	%特别说明：由于解码时code_end可能访问到超过ACCode长度的部分
                              	%为了防止MATLAB报错，特意延长ACCode长度,事实上对结果没有任何影响
ACCode=[ACCode zero_dbg];     	%延长后得到的ACCode
code_start=1;                 	%解码时，起始是Huffman编码部分，故使用code_start表示Huffman码的起始位
while(code_start<=ACL)          %判断解码未完成时,对ACCode码流进行解码
    if(ACCode(code_start:code_start+3)==EOB)    %解码遇到EOB结束符
        currL=length(ACDec);                    %获取当前解码得到的ACDec的长度
        if(mod(currL,63)==0&&ACDec(end)~=0)     %如果当前ACDec长度已经为63的倍数并且最后一位是非零数
                                                %表明不需要再补零
            code_start=code_start+4;            %直接进入下一段Huffman码的解码,更新code_start
        else                                    %其他情况需要将ACDec用零补全63位(ACDec长度为63的倍数)
            zero=zeros(1,63-mod(currL,63));     %用于补全的零向量，63-mod(currL,63)计算需要零的个数
            ACDec=[ACDec zero];                 %用零向量补全63位
            code_start=code_start+4;            %处理EOB完毕，进入下一段Huffman码的解码,更新code_start
        end
    elseif (ACCode(code_start:code_start+10)==ZRL)  %解码遇到ZRL，表明AC系数矩阵中有连续16个零
        zero=zeros(1,16);           %16个零的向量
        ACDec=[ACDec zero];         %解码向量ACDec中增加16个零
        code_start=code_start+11;   %处理ZRL完毕，进入下一段Huffman的解码，更新code_start
    else                            %除去EOB和ZRL之外，其他情况需要根据码流依次解码
        for k=1:NumAC               %在码本中寻找与码流匹配的Run/Size
            code_end=code_start+ALTAB(k)-1;     %Huffman码的终止位，与码本中对应的码长有关
            if (ACTAB(k,4:ALTAB(k)+3))==ACCode(code_start:code_end)   %完全匹配，找到码本中对应的行
                Run=ACTAB(k,1);  	%获取行程Run，即非零系数之前零的个数
                Size=ACTAB(k,2);    %获取Size，即当前AC系数二进制表示时的比特数
                break;
            end
        end
        zero=zeros(1,Run);          %生成长度等于Run的零矩阵
        ACDec=[ACDec zero];         %解码向量ACDec中增加该矩阵
        bit_start=code_end+1;       %下一位对应该AC系数二进制形式的起始位
        bit_end=bit_start+Size-1;   %由Size计算得到AC系数二进制形式的终止位
        bits=ACCode(bit_start:bit_end);	%从ACCode码流中得到AC系数对应的二进制形式
        ACDec=[ACDec bin2deci(bits)]; 	%根据bits由函数bin2cdeci得到十进制形式的AC系数，并入AC系数向量
        code_start=bit_end+1;       %该AC系数解码完毕，更新下一系数的Huffman码起始位置  
    end
end
ACcount=length(ACDec);              %获取解码得到的系数向量总长度
ACMat=reshape(ACDec,63,ACcount/63); %将向量转换为63行的矩阵
CoMat=[DCDec;ACMat];                %DC系数和AC系数合并，恢复得到DCT系数矩阵(Zig-Zag处理之后)
%后续处理
YNum=Height/8;                      %8*8为一块
XNum=Width/8;
Cell=cell(YNum,XNum);               %分块处理，得到元胞数组（cell单元数组）
for i=1:YNum                        %从左向右-从上至下逐块处理
    for j=1:XNum
        Cell{i,j}=izigzag(CoMat(:,(i-1)*XNum+j));   %逆Zig-Zag函数，根据扫描后1*64的向量还原8*8矩阵
        Cell_DCT=Cell{i,j}.*QTAB;                   %反量化处理
        Cell{i,j}=idct2(Cell_DCT);                  %idct2二维离散余弦逆变换
        Cell{i,j}=round(Cell{i,j}+128);             %加128进行复原
    end
end
Recovery=cell2mat(Cell);                %拼接操作，将Cell元胞数组还原为矩阵形式，宽高与原图的完全相同
snows_rec=uint8(Recovery);              %转换为uint8类型，用snow_rec表示还原得到的图像矩阵

%--------------------------------------------解码结束-----------------------------------------%

%-----------------------------------------评价编解码效果--------------------------------------%
snows=snow;         	%测试图像为snow.mat中的灰度图像snow
                            %另存为snows,避免更改原始数据snow
[Height,Width]=size(snows); %获取图像大小
PixelNum=Height*Width;      %总像素数目，用于计算MSE
MSE=1/PixelNum*sum(sum((double(snows_rec)-double(snows)).^2));
                            %根据公式计算MSE
PSNR=10*log10(255^2/MSE);   %根据公式计算PSNR
subplot(1,2,1);             %子图1
imshow(snows);              %作出原图
title('原图');              %设定标题
imwrite(snows,'./chapter2_13/1原图.bmp');  %另存用图片浏览器浏览
subplot(1,2,2);            	%子图2
imshow(snows_rec);          %作出经过JPEG编码和解码之后复原得到的图
title('JPEG编解码复原图');   %设定标题
imwrite(snows_rec,'./chapter2_13/2JPEG编解码复原图.bmp');  %另存用图片浏览器浏览
