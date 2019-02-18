function [U, V] = ALS_WR(traindata,testdata,M,d,lambda,Iterations)
% 使用ALS_WR算法计算U和V

[nuser,nitem] = size(M);
[usridx,itmidx] = find(M);                              % 训练矩阵中非零参数的index(user index、item index)
% 矩阵迭代前初始化
U = zeros(nuser,d);                                     % U矩阵初始化
V = rand(nitem,d);                                      % V矩阵初始化

% 开始迭代计算
for iter = 1:Iterations
    % 固定矩阵V，更新矩阵U的每一行
    for i = 1:nuser                                     % 对于每一个user
        logic = (usridx == i);                          % 返回一个逻辑型向量
        if(nnz(logic) > 0)                           	% 若其中有该user的数据
            items = itmidx(logic);                   	% 该user对应的打分的item
            Vs = V(items,:);                            % 挑选出被打分的item作为一个新的(小)矩阵
            nitem_i = nnz(M(i,items));                  % 用户i所评价的item的数量
            A = Vs'*Vs + lambda * nitem_i * eye(d);    % 代入迭代公式part1
            T = Vs' * M(i,items)';                      % 代入迭代公式part2
            U(i,:) = A\T;                               % 本算法中核心公式
        else
            U(i,:) = zeros(1,d);                        % 如果该用户没有打分，则置为0向量
        end;
    end;
    % 固定矩阵U，更新矩阵V的每一行
    for j = 1:nitem                                     % 对于每一个item
        logic = (itmidx == j);                          % 返回一个逻辑型向量
        if(nnz(logic) > 0)                              % 若该item有受到评价
            users = usridx(logic);                      % 打出评价的所有user
            Us = U(users,:);                            % 挑选出给打分的user作为一个新的(小)矩阵
            nuser_i = nnz(M(users,j));                  % item所受到的评价数量
            A = (Us' * Us) + lambda * nuser_i * eye(d); % 代入迭代公式part1
            T = Us' * M(users,j);                       % 代入迭代公式part2
            V(j,:) = A\T;                               % 本算法中核心公式
        else
            V(j,:) = zeros(1,d);                        % 如果该item没有受到评价，则置为0向量
        end;
    end;
    % 迭代结束，得到矩阵U和V
    X = U*V';
    [trainMSE,testMSE] = calcMSE(traindata,testdata,X);
    fprintf('Iteration %d -- trainMSE %f | testMSE %f\n',iter, trainMSE, testMSE);
end
