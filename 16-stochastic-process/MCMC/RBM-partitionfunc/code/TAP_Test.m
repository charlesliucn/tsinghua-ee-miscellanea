clear all,close all,clc;

load('h10.mat');
W = parameter_W;
a = parameter_a;
b = parameter_b;
N = 10;
TAP2_LogZ = zeros(1,N);
TAP3_LogZ = zeros(1,N);
for i = 1:N
    TAP2_LogZ(i) = TAP2(W, a, b);
    TAP3_LogZ(i) = TAP3(W, a, b);
end
Mean1 = mean(TAP2_LogZ);
Var1 = var(TAP2_LogZ);
Mean2 = mean(TAP3_LogZ);
Var2 = var(TAP3_LogZ);
plot(TAP2_LogZ,'-*r');hold on;
plot(TAP3_LogZ,'->b');hold on;
legend('TAP二阶近似','TAP三阶近似');
