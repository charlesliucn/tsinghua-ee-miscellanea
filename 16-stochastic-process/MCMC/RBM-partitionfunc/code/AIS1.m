function AIS_LogConst = AIS1(W,a,b,M_run,beta)
% AIS(Annealed Importance Sampling)算法估计RBM归一化常数(没有batchdata)
% 输入：
%   W： 隐藏层单元和可见层单元的权重构成的矩阵；
%   a： 隐藏层单元的bias；
%   b： 可见层单元的bias；
%   M_run：AIS运行次数；
%   beta：论文中的β参数，用于生成中间函数；
% 输出：
%   AIS_LogConst：AIS算法得到的归一化常数估计值.

%% 对base_rate model的基本设置
%base-rate model的相关参数都用*_base表示
%W_base = 0*W;                          %base-rate model RBM的权重矩阵W取为0
b_base = 0*b;                           %base-rate model RBM的可见层bias全部取0
b_matrix_base = repmat(b_base,M_run,1);	%base-rate model 可见层的bias
                                        %base-rate model RBM的隐藏层的bias全部为1
[num_vis,num_hid] = size(W);            %获取可见层和隐藏层的点数
%base-rate model的归一化常数(取log)
LogConst_base = sum(log(1+exp(b_base)))+(num_hid)*log(2); %paper公式4.18；取ln, a = 0.

%% 设置初始的参数，在paper第42页最下方的公式
a_mat = repmat(a,M_run,1); 
b_mat = repmat(b,M_run,1);

%% 对base-rate model进行采样
Log_w = zeros(M_run,1);                             %公式4.10中的w取ln的初值
v = repmat(1./(1+exp(-b_base)),M_run,1);           
v = v > rand(M_run,num_vis);                        %基于base-rate model生成初始v
Log_w = Log_w - (v*b_base' + num_hid*log(2));       %Log_w对于base-rate model之后的取值

%% AIS算法运行
 %因为beta(1)=0对应于base-rate model，之前已经进行了计算
 %所以从beta(2)开始，最后一次只需进行收尾工作，在循环结构外实现
 for beta_k = beta(2:end-1)                    
   exp_Wh = exp(beta_k*(v*W + a_mat));
   Log_w  =  Log_w + (1-beta_k)*(v*b_base') + beta_k*(v*b') + sum(log(1+exp_Wh),2); %paper第42页最下方公式
   
   %定义马尔科夫链转移算子(Markov chain transition operator)
   hB_prob = exp_Wh./(1 + exp_Wh);      	%paper公式4.16
   h_B = hB_prob > rand(M_run,num_hid);   	%生成隐藏层unit
   v = 1./(1 + exp(-(1-beta_k)*b_matrix_base - beta_k*(h_B*W' + b_mat)));%paper公式4.17
   v = v > rand(M_run,num_vis);         	%生成可见层unit

   %更新计算结果
   exp_Wh = exp(beta_k*(v*W + a_mat));
   Log_w  =  Log_w - ((1-beta_k)*(v*b_base') + beta_k*(v*b') + sum(log(1+exp_Wh),2));
 end
 
%% 最后的beta(end)计算RBM模型的归一化常数,取对数
    exp_Wh = exp(v*W + a_mat); 
    Log_w  = Log_w +  v*b' + sum(log(1+exp_Wh),2);
    
    %为防止数值太大MATLAB溢出，使用log表示数值
    dims = size(Log_w); 
    dim = find(dims >1 );
    out_base = max(Log_w,[],dim)-log(realmax)/2;
    dims_rep = ones(size(dims)); 
    dims_rep(dim) = dims(dim);
    log_sumw = out_base + log(sum(exp(Log_w - repmat(out_base,dims_rep)),dim));
    
    Log_rAIS = log_sumw -  log(M_run);      %paper公式4.4
    AIS_LogConst = Log_rAIS + LogConst_base;        %paper公式4.4取ln的结果

end