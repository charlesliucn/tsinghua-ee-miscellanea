function pdata = SampleMatchCode(rawdata,bias)
% SampleMatchCode函数
% 功能：将扩频信号一个周期的采样数据(长度为10000)对应到长度为2046的离散信号，以便与本地PRN序列做相关
% 思路：将扩频信号一个周期的采样数据(长度为10000)先对应到2046个区间，再对各区间内的数据取均值，作为该区间的代表
% 输入：
%       rawdata：采样得到的数据，或者是初步处理后的数据，对应扩频信号的一个周期；
%       bias： 	微调采样点，使得尽可能多的扩频信号的首个采样点对应一个码元的起始位置；
% 输出：
%       pdata：  处理后的数据，长度与PRN序列相同，即可进行相关运算


    CodeLength = 2046;                      %PRN序列的长度
    num = length(rawdata);                  %扩频信号一个周期的采样数据的长度，当采样频率为10MHz时，长度为10000
    pdata = zeros(1,CodeLength);            %初始化处理数据，长度等于PRN序列
    %将10000的数据点对应到2046个区间
    lowerbound = zeros(1,CodeLength);       %初始化区间的下界
    upperbound = zeros(1,CodeLength);       %初始化区间的上界
    lowerbound(1) = 1;                      %对于第一个区间特殊处理，区间下界为1，即从第一个数据开始
    upperbound(1) = floor(num/CodeLength);  %对于第一个区间特殊处理，区间上界计算公式
    pdata(1) = mean(rawdata(lowerbound(1):upperbound(1)));  %对第一个区间特殊处理，获取第一个区间内的均值
    for i = 2:CodeLength                                    %对之后的每个区间作相同处理
        upperbound(i) = floor(num*(i-bias)/CodeLength);     %获取区间上界
        lowerbound(i) = ceil(num*(i-bias-1)/CodeLength);    %获取区间下界
        pdata(i) = mean(rawdata(lowerbound(i):upperbound(i)));  %求区间内数据的均值
    end
end