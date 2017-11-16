clear all,close all,clc;

n=1;                        %起始采样点标号，原来共8000个采样点
m=1;                        %段序号
PT=80;                      %初始化基音周期
sp=zeros(1,8000);           %经过处理后的1s的信号sp
while n>0&&n<=8000
    sp(n)=1;                %脉冲点
    m=floor(n/80);          %段序号
    PT=80+5*mod(m,50);      %基音周期    
    n=n+PT;                 %每段内每个脉冲个和前一脉冲的间隔为本段的PT值
end
sound(sp,8000);             %以8kHz采样频率播放

pause(1.1);                 %停顿1.1s便于分别
a=[1];                      %定义输入信号系数
b=[1, -1.3789, 0.9506];     %定义输出信号系数
sn=filter(b,a,sp);          %用filter由输入信号得到输出s(n)
sound(sn,8000);             %以8kHz采样频率播放


