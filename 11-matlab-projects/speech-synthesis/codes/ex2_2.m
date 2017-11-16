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
%plot(sp);


