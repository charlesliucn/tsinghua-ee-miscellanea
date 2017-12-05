function RTS_LogConst = RTS(W,a,b,beta,N)
% RTS(Rao-Blackwellized Tempered Sampling)算法估计RBM归一化常数（by 刘前）
% 输入：
%   W： 隐藏层单元和可见层单元的权重构成的矩阵；
%   a： 隐藏层单元的bias；
%   b： 可见层单元的bias；
%   N： 运行次数；
%   beta：论文中的beta参数，用于生成中间函数；
% 输出：
%   RTS_LogConst：RTS算法得到的归一化常数估计值.

%% 准备工作
    K = length(beta);                   %由beta确定K的大小
    r = 1/K *ones(1,K);                 %r_k全取为1/K
    [num_vis,num_hid] = size(W);        %根据权值矩阵获取隐藏层和可见层unit数目
    L = 10;                             %初始化起始的beta

%% 初始化
    %Z的初始化
    Z = zeros(1,K);                     %Z共有K个
    Z(1) = 1;                           %Z(1)初始值为1
    Z(2:end) = linspace(1,10e100,K-1);  %其他间隔相等
    %c的初始化(全为0)
    c = zeros(1,K);
    %初始化beta(1)=0对应的分布，类似于AIS算法中的base-rate model
    b_base = 0*b;                       %base-rate model RBM的隐藏层bias全为0
    %W_base = 0*W;                      %base-rate model RBM的权重矩阵W取为0
    v = rand(1,num_vis);                %生成随机序列
    v = v > b_base;                     %初始化可见层unit的取值
    %计算base-rate model RBM模型的归一化常数
    Z_base = sum(log(1+exp(b_base)))+sum(log(1+exp(a)));        %AIS的papar公式4.18           
    %初始化c和r的间距
    diff = 1/K;

 %% 执行RTS算法
while diff >= 0.1/K                     %RTS算法结束的条件，参考论文2.5节上方的提示
    for j = 1:N
        %定义马尔科夫链转移算子(Markov chain transition operator)，保证q(x|beta) 不变
        %%%%注意此处和AIS算法中实现的方法相同
        hB_prob = 1./(1+exp(-beta(L)*(v*W+a)));     %AIS paper公式4.16
        h_B = hB_prob > rand(1,num_hid);            %生成隐藏层unit
        v = 1./(1+exp(-(1-beta(L))*(b_base))-(beta(L))*(h_B*W'+b)); %AIS paper公式4.17
        v = v > rand(1,num_vis);                    %生成可见层unit
     
        % 从q(beta|x)采样得到beta|x
        %%%%基本原理，paper公式7，计算q(beta|x)在求和中所占的比例表示采样时beta的概率
        log_qxr = (1-beta)*(v*b_base')+sum(log(1+exp(a'*(1-beta))))+ beta*(v*b')+sum(log(1+exp((v*W+a)'*beta)));   %paper公式7的分子(不同beta)
        log_qxr  = log_qxr - (1-beta)*Z_base;
        qxr = exp(log_qxr);
        SumQ = sum(qxr);                             %求和 paper公式7中的分母
        th = rand();                                %生成随机数，用于选择beta
        prob = 0;                                   %概率初始
        for i = 1:K
            prob = prob + qxr(i)/SumQ;               %计算得到概率
            if th < prob    L = i; break;    end     %比较找到合适的beta，即为采样得到的beta
        end
        % 更新c的大小
        c = c + 1/N*qxr/SumQ;                        %c的迭代更新公式
    end
    %更新Z
    Z(2:K) = Z(2:K).*(r(1)*c(2:K))./(c(1)*r(2:K));  %Z_RTS的迭代更新公式
    diff = max(abs(c-r));                           %计算r和c之间的差距，用于判断是否符合算法要求
end
%% 算法结束，得到结果
    RTS_LogConst = log(Z(end));                     %得到归一化常数的估计值
    
