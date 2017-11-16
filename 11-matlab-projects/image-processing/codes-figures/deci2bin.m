function [bin] = deci2bin(deci)
% 函数功能：将十进制数转换为二进制
% 与MATLAB本身的dec2bin不同，返回值不是字符串而是整数数组
% 非负整数返回二进制（原码），负整数返回1反码
% 输入：   一个十进制数
% 返回值： 十进制数的二进制形式，用数组存储
    if deci==0
        bin=[0];
    else
        bitnum=ceil(log2(abs(deci)+1));
        bin=zeros(1,bitnum);
        bin_str=dec2bin(abs(deci));
        for i=1:bitnum
            bin(i)=str2num(bin_str(i));
        end
        if(deci<0)
            bin=~bin;
        end
end

