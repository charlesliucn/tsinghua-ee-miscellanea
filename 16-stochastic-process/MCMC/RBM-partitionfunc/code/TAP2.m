function TAP_LogConst = TAP2(W, a, b) 
% TAP(Thouless-Anderson-Palmer)算法估计RBM归一化常数(选择二阶近似)
% 输入：
%   W： 隐藏层单元和可见层单元的权重构成的矩阵；
%   a： 隐藏层单元的bias；
%   b： 可见层单元的bias；
% 输出：
%   TAP_LogConst：TAP算法(二阶)得到的归一化常数估计值.

%% 准备工作
[num_vis,num_hid] = size(W); 	%由权重矩阵获取隐藏层和可见层的unit数
if(num_hid < 100)
    mv = 1./(1+exp(-b))';
    mh = 1./(1+exp(-a))';
else
    mv = randn(num_vis,1);      	%初始化mv
    mh = randn(num_hid,1);          %初始化mh
end
%% TAP算法（二阶近似）
flag = 0;                    	%用于判断是否收敛的标志
while(flag == 0)
     %迭代公式中更新得到mh_next 公式9
     update_h = a'+W'*mv+(W.^2)'*(mv-mv.^2).*(mh-0.5);
     one_h = ones(num_hid,1);
     mh_next = one_h./(1+exp(-update_h));
     
     %迭代公式更新得到mv_next 公式10
     update_v = b'+W*mh_next+(W.^2)*(mh_next-mh_next.^2).*(mv - 0.5);
     one_v = ones(num_vis,1);
     mv_next = one_v./(1+exp(-update_v));
     
     %判断是否收敛
     if(max(abs(mh - mh_next)) == 0 && max(abs(mv - mv_next) == 0))
         flag = 1;
     else
        %得到更新后的结果
    	mh = mh_next;
        mv = mv_next;
     end
 end
 
%% TAP算法(二阶近似）
S1 = - sum(mv.*log(mv) + (1-mv).*log(1-mv));    % mv的熵(entropy)
S2 = - sum(log(mh.^mh)+log((1-mh).^(1-mh)));    % mh的熵(entropy)
TAP_LogConst = S1 + S2 + sum(b'.*mv) + sum(a'.*mh) + mv'*W*mh + 0.5*((W.^2)'*(mv-mv.^2))'*(mh-mh.^2); %公式7计算归一化常数

end