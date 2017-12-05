clear all,close all,clc;

M = 100;
R = zeros(1,M);
for i = 1:M
    R(i) = MH_Gibbs();
end
plot(R);
hold on;
MAX = max(R);
plot([0,100],[MAX,MAX],'r:');
hold on;
MIN = min(R);
plot([0,100],[MIN,MIN],'k:');
hold on;
ylim([0.4,0.6]);
legend(sprintf('相关系数估计值'),sprintf('估计值浮动上限y = %1.2f',MAX),...
    sprintf('估计值浮动下限y = %1.2f',MIN));