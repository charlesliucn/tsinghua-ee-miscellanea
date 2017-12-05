function varargout = GPR(hyperpara, infmethod, meanfunc, kernel, likfunc, xtrain, ytrain, xtest)
% 函数：
%   高斯过程回归(Gaussian Process Regresssion,GPR)函数。
%
% 功能：
%   基于高斯过程回归(GPR)的推断和预测。
%       先验为高斯过程，由均值函数和协方差函数(核函数,kernel function)
%   唯一确定。本函数主要基于训练数据使用高斯过程回归实现模型的选择，并基
%   于选择的模型进行数据的预测。
%
% 使用说明：
%   使用时分为两种情况：
%   1. 只输入训练数据。函数输出训练得到的边缘似然值(marginal likelihood)和超参数；
%   [logMaLik,dlogMaLik]                 = gp(hyp, inf, mean, cov, lik, x, y);
%   2. 输入训练数据和测试数据。函数输出训练后对测试数据的预测结果。
%   [mean_test,var_test,mean_lat,varlat] = gp(hyp, inf, mean, cov, lik, x, y, xs);
%
% 参数说明：
%   输入参数：
%       hyperpara：均值函数、核函数和似然函数中的超参数(hyperparameters)
%       infmethod：用于推断的方法 
%       meanfun  ：(先验)均值函数
%       kernel   ：(先验)协方差函数(核函数)
%       likfun   ：似然函数
%       xtrain   ：训练数据的输入
%       ytrain   ：训练数据的输出
%       xtest    ：测试数据的输入
%   输出参数：
%   1.第一种使用方法：
%       logMalik ：边缘似然值(取log并取负)
%       dlogMalik：关于均值、协方差、似然函数超参数的边缘似然的偏导数(列向量)
%   2.第二种使用方法：
%       mean_test：对测试数据的预测-均值
%       var_test ：对测试数据的预测-方差
%       mean_lat ：预测均值
%       var_lar  ：预测方差

%%  设置均值函数
if isempty(meanfunc)                    %输入均值函数为空时，使用默认的均值函数meanZero
    meanfunc = {@meanZero};                                         %详见meanZero函数
end
if ischar(meanfunc) || isa(meanfunc, 'function_handle')
    meanfunc = {meanfunc};                                %输入的均值函数，存入元胞数组
end

%%  设置核函数
if isempty(kernel)                                                 %GPR中核函数不能为空
    error('Error:输入核函数不能为空！');                                   %提示出现错误
end
if ischar(kernel) || isa(kernel,'function_handle')
    kernel  = {kernel};                                      %输入的核函数，存入元胞数组
end                         
kernelinput = kernel{1};                                                  %输入的核函数
if isa(kernelinput,'function_handle')
    kernelinput = func2str(kernelinput);                   %将函数句柄转为函数名的字符串
end
%%  设置似然函数
if isempty(likfunc)
    likfunc = {@likGauss};                                       %默认似然函数为高斯函数
end
if ischar(likfunc) || isa(likfunc,'function_handle')
    likfunc = {likfunc};                                      %输入似然函数，存入元胞数组
end
likefuninput = likfunc{1};                                               %输入的似然函数
if isa(likefuninput,'function_handle')
    likefuninput = func2str(likefuninput);              %将函数句柄转换为函数名称的字符串
end

%%  设置推断方法
if isempty(infmethod)
    infmethod = {@infGaussLik};                                  %默认推断方式为高斯推断
end
if ischar(infmethod)
    infmethod = str2func(infmethod);                %将推断方式名称的字符串转换为函数句柄
end
if ischar(infmethod) || isa(infmethod,'function_handle')
    infmethod = {infmethod};                                %输入的推断方式，存入元胞数组
end
infmethodinput = infmethod{1};                                           %输入的推断方式
if isa(infmethodinput,'function_handle')
    infmethodinput = func2str(infmethodinput);       %将输入的推断方式的函数句柄转为字符串
end
if strcmp(infmethodinput,'infPrior') 
  infmethodinput = infmethod{2};                     %字符串比较，先验推断将其存入元胞数组
end

%% 超参数错误检测
D = size(xtrain,2);
if ~isfield(hyperpara,'mean')
    hyperpara.mean = [];                                          %均值函数的超参数置为空
end
if ~isfield(hyperpara,'cov')
    hyperpara.cov = [];                                             %核函数的超参数置为空
end
if ~isfield(hyperpara,'lik')
    hyperpara.lik = [];                                           %似然函数的超参数置为空
end
if eval(feval(meanfunc{:})) ~= numel(hyperpara.mean)
  error('Error：输入的均值函数的超参数个数与均值函数不符！');                  %提示错误信息
end
if eval(feval(kernel{:})) ~= numel(hyperpara.cov)
  error('Error：输入的核函数的超参数个数与核函数不符！');                      %提示错误信息       
end
if eval(feval(likfunc{:})) ~= numel(hyperpara.lik)
  error('Error：输入的似然函数的超参数个数与似然函数不符！');                  %提示错误信息
end
%%
if nargin > 7                      %当函数使用模式为第二种(有测试数据)时，计算边缘函数似然值
    if isstruct(ytrain)
        posterior = ytrain;
    else
        posterior = feval(infmethod{:}, hyperpara, ...  %feval函数估计函数在给定参数处的值
            meanfunc, kernel, likfunc, xtrain, ytrain);
    end
else
    if nargout <= 1
      [posterior,logMalik] = feval(infmethod{:}, hyperpara, ...
          meanfunc, kernel, likfunc, xtrain, ytrain);   %feval函数估计函数在给定参数处的值
      dlogMalik = {};                                                        %偏导数为空
    else
      [posterior,logMalik,dlogMalik] = feval(infmethod{:},hyperpara,...
          meanfunc, kernel, likfunc, xtrain, ytrain);   %feval函数估计函数在给定参数处的值
    end
end

if nargin == 7                                        %当函数使用第一种模式(没有测试数据)时
	varargout = {logMalik, dlogMalik, posterior};            %输出边缘似然值、偏导数和后验结果
else
    alpha = posterior.alpha;                                  	  %后验结果包括alpha,L和sW
    L = posterior.L;
    sW = posterior.sW;
    if issparse(alpha)
        nonzero = (alpha ~= 0);                                              %非零值的指标
        if issparse(L)
            L = full(L(nonzero,nonzero)); 
        end
        if issparse(sW)
            sW = full(sW(nonzero)); 
        end
    else
        nonzero = true(size(alpha,1),1); 
    end
    if isempty(L)                                                   %L未给出时，需自行计算L
        K = feval(kernel{:}, hyperpara.cov, xtrain(nonzero,:));
        L = chol(eye(sum(nonzero))+sW*sW'.*K);
    end
    
    Lchol = isnumeric(L) && all(all(tril(L,-1)==0)&diag(L)'>0&isreal(diag(L))');
    ntest = size(xtest,1);                                                   %测试数据个数
    if strncmp(kernelinput,'apxGrid',7)
        xtest = apxGrid('idx2dat',kernel{3},xtest); 
    end
    %测试数据结果初始化
 	mean_test = zeros(ntest,1); 
    var_test  = zeros(ntest,1);
    mean_lat  = zeros(ntest,1);
    var_lat   = zeros(ntest,1);
    nperbatch = 10;                                     %批量处理时，每batch的测试数据个数
    nprced = 0;                                                     %已经处理的测试数据个数
    while nprced < ntest                                         %处理每批(batch)的测试数据
        id = (nprced+1):min(nprced + nperbatch,ntest);            %需要处理的测试数据的角标
        kss = feval(kernel{:}, hyperpara.cov, xtest(id,:), 'diag'); 
        if strcmp(kernelinput,'covFITC') || strcmp(kernelinput,'apxSparse')
            Ks = feval(kernel{:}, hyperpara.cov, xtrain, xtest(id,:)); Ks = Ks(nonzero,:);
        else
            Ks = feval(kernel{:}, hyperpara.cov, xtrain(nonzero,:), xtest(id,:));
        end
        ms = feval(meanfunc{:}, hyperpara.mean, xtest(id,:));
    	N = size(alpha,2);
        mean_cond = repmat(ms,1,N) + Ks'*full(alpha(nonzero,:));          %条件分布的均值
        mean_lat(id) = sum(mean_cond,2)/N;                                    %预测的均值
        if Lchol
            V  = L'\(repmat(sW,1,length(id)).*Ks);
            var_lat(id) = kss - sum(V.*V,1)';                                 %预测的方差
        else
            if isnumeric(L)
                LKs = L*Ks; 
            else
                LKs = L(Ks);
            end
            var_lat(id) = kss + sum(Ks.*LKs,1)';                              %预测的方差
        end
        var_lat(id) = max(var_lat(id),0);                                       %去除噪声
        var_cond = repmat(var_lat(id),1,N);                                     %条件方差
        if nargin < 9
            [Lp, Ymu, Ys2] = feval(likfunc{:},hyperpara.lik,[],mean_cond(:),var_cond(:));
        end
        mean_test(id) = sum(reshape(Ymu,[],N),2)/N;         
        var_test(id) = sum(reshape(Ys2,[],N),2)/N;
        nprced = id(end);                                  %将角标设置为上一个处理的数据点
    end
    varargout = {mean_test, var_test, mean_lat, var_lat};               %函数最终输出结果
end
