clear all,close all,clc;
num_run = 100;
R = zeros(1,num_run);
SE = zeros(1,num_run);
for i = 1:num_run
    R(i) = MH_Origin();
end
SE = (R-0.5).^2;
figure(1);
plot(R);
ylim([0,1]);
title('MH算法估计相关系数结果(未进行参数的调整)');
xlabel('MH算法运行次数');
ylabel('相关系数估计值');
figure(2);
plot(SE);
title('MH算法估计相关系数 误差分析(未进行参数的调整)');
xlabel('MH算法运行次数');
ylabel('相关系数估计值与真实值的误差');
