clear all,close all,clc;
num_run = 100;
psigma1 = [0.5,1,2];
psigma2 = [0.5,1,2];
R = zeros(1,num_run);
R_Mat = [];
for j = 1:3
    for k = 1:3
        for i = 1:num_run
            R(i) = MH_Sigma(psigma1(j),psigma2(k));
        end
        R_Mat = [R_Mat;R];
    end
end
plot(R_Mat(1,:),'r*');hold on;
plot(R_Mat(2,:),'y');hold on;
plot(R_Mat(3,:),'m');hold on;
plot(R_Mat(4,:),'c');hold on;
plot(R_Mat(5,:),'r');hold on;
plot(R_Mat(6,:),'g');hold on;
plot(R_Mat(7,:),'b');hold on;
plot(R_Mat(8,:),'k');hold on;
plot(R_Mat(9,:),'c.');hold on;
legend( sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(1),psigma1(1)),...
    sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(1),psigma1(2)),...
    sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(1),psigma1(3)),...
    sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(2),psigma1(1)),...
    sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(2),psigma1(2)),...
    sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(2),psigma1(3)),...
    sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(3),psigma1(1)),...
    sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(3),psigma1(2)),...
    sprintf('psigma1 = %1.1f,psigma2 = %1.1f',psigma1(3),psigma1(3)),'Location','EastOutside');
title('MH算法--提议函数选取不同方差时的估计相关系数结果');
xlabel('运行次数');
ylabel('相关系数估计值');

