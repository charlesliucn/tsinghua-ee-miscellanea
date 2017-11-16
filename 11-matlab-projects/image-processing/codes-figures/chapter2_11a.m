clear all,close all,clc;

load jpegcodes.mat;     %获取编码得到的码流和图像宽高信息
load JpegCoeff.mat;     %获取JpegCoeff.mat数据
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
hallg_rec=uint8(Recovery);              %转换为uint8类型，用hall_rec表示还原得到的图像矩阵
save('jpegdecodes.mat','hallg_rec');    %另存为jpegdecodes.mat