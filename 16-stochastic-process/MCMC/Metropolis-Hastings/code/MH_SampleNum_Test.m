clear all,close all,clc;

Sample_Num = [100,1000,10000,100000];
len = length(Sample_Num);
Times = 50;
R = zeros(len,Times);
for i = 1:len
    for j = 1:Times
        R(i,j) = MH_Sample_Num(Sample_Num(i));
    end
end
plot(R(1,:),'r:');hold on;
plot(R(2,:),'b');hold on;
plot(R(3,:),'k-');hold on;
plot(R(4,:),'m*');hold on;
ylim([0,1]);
legend(sprintf('随机样本数N = 100'),sprintf('随机样本数N = 1000'),...
    sprintf('随机样本数N = 10000'),sprintf('随机样本数N = 100000'));
title('相关系数估计值的浮动 与 随机样本数目 的关系');
xlabel('运行次数');
ylabel('相关系数估计值');
