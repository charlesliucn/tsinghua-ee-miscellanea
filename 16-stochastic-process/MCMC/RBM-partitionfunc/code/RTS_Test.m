clear all,close all,clc;
load('h10.mat');

W = parameter_W;
a = parameter_a;
b = parameter_b;
beta =[0:0.001:1];
N = 20;

M = 10;
for i = 1:M
    Z(i) = RTS(W,a,b,beta,N);
end
Mean = mean(Z);
Var = var(Z);