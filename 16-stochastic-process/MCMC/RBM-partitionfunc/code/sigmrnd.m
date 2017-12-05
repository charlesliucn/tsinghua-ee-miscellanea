function X = sigmrnd(P)
%生成基于Sigmoid函数的随机数

    X = double(1./(1+exp(-P)) > rand(size(P)));
end