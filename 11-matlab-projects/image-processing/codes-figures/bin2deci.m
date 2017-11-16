function [deci] = bin2deci(bin)
% 函数功能：将二进制数转换为十进制
% 与MATLAB本身的bin2dec不同，返回值不是字符串而是十进制整数
% 若首bit是1，则直接返回十进制；否则，表示1补码对应负整数，先逐位取反得到十进制，再添加负号返回负整数
% 输入：   二进制数组
% 返回值： 十进制整数
    bitnum=length(bin);
    deci=0;
    if bin(1)==1
        for i=1:bitnum
            deci=deci+2^(bitnum-i)*bin(i);
        end
    else
        bin=~bin;
         for i=1:bitnum
            deci=deci+2^(bitnum-i)*bin(i);
         end
        deci=-deci;
    end
end
            
            

