clear all,close all,clc;

M_run = 20;            %AIS�㷨�����д���
beta = [0:1/1000:0.5 0.5:1/10000:0.9 0.9:1/100000:1.0];  %ѡȡ��beta����������paper�н����
load('test.mat');
load ('h10.mat');
W = parameter_W;        %RBM��Ȩ�ؾ���W
a = parameter_a;        %���ز��bias����a
b = parameter_b;        %�ɼ����bias����b
N = 10;
LogZ = zeros(1,N);
for i = 1:N
    LogZ(i) = AIS1(W,a,b,M_run,beta);
end
Mean = mean(LogZ);
Var = var(LogZ);


plot(LogZ,'-*');
ylim([Mean-20,Mean+20]);
title('AIS�㷨(δ�Ż�)��RBM(������Ϊ10)ģ�͹�һ�������Ĺ���');
xlabel('�������д���');
ylabel('logZ(��һ������ȡ��Ȼ����)');