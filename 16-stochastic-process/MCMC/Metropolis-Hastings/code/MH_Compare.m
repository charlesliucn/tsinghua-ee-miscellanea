clear all,close all,clc;

N = 20;
R = zeros(3,N);
for j = 1:N
    R(1,j) = MH_Origin();
    R(2,j) = MH_Optimal();
    R(3,j) = MH_Gibbs();
end
E_Orin = sum(R(1,:))/N;
E_Op = sum(R(2,:))/N;
E_Gibbs = sum(R(3,:))/N;
Var_Orin = sum((R(1,:)-E_Orin).^2)/N;
Var_Op = sum((R(2,:)-E_Op).^2)/N;
Var_Gibbs = sum((R(3,:)-E_Gibbs).^2)/N;
plot(R(1,:),'k.');hold on;
plot(R(2,:),'b:');hold on;
plot(R(3,:),'r');hold on;ylim([0,1]);
legend(sprintf('MH算法-参数未改动'),sprintf('MH算法-参数优化'),...
    sprintf('Gibbs算法'));
title('MH算法优化前后比较');
xlabel('运行次数');
ylabel('相关系数估计值');