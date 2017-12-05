function Log_Like = LikeliHood(W,a,b,logZ,data,num_test)
% 根据估计得到的归一化常数，计算测试数据上的总似然值
% 输入：
%   W： 隐藏层单元和可见层单元的权重构成的矩阵；
%   a： 隐藏层单元的bias；
%   b： 可见层单元的bias；
%   logZ：算法得到的归一化常数估计值（取log）；
%   testbatchdata：测试数据
% 输出：
%   Log_Like：测试数据上的总似然值

%% 计算测试数据上的总似然值
Pv = exp(data*b' + sum(log(1+exp(ones(num_test,1)*a + data*W)),2) - logZ);
Log_Like = sum(Pv);
