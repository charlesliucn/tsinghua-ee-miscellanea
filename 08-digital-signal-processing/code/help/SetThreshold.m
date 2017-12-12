function threshold = SetThreshold( cor )
% SetThreshold函数：
% 功能：设置卫星信号捕获的判决门限
% 思路：将各卫星PRN序列与处理后的接收信号的相关峰值从低到高排序，每个元素与之前的元素对比
%       若前后两个元素之比超出某一合理的范围，则将前一个元素作为判决门限
% 输入：cor：       各卫星PRN序列与将接收信号的相关峰值(矢量)
% 输出：threshold： 设置的判决门限

    num = length(cor);                      %相关峰值矢量的长度（即为卫星的数目）
    error = 0.5;                            %前后两个元素相差的比例（容易控制）
    sort_cor = sort(cor);                   %将相关峰值矢量进行排序
    for i = 2:num
        comp = sort_cor(i)/sort_cor(i-1);   %前后两个元素之比
        if(comp > 1+error)                  %假如超出一定范围
            threshold = sort_cor(i-1);      %设置门限为前一个元素，即为输出值
            break;                          %停止比较
        end
    end
    
end

