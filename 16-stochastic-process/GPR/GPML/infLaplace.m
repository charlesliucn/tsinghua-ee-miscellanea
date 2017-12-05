function [posterior,logMaLik,logZ_dr1,alpha] = infLaplace(hyperpara, meanfunc, kernel, likfunc, x, y, opt)
% 函数：
%   贝叶斯推断近似方法 之 Laplace近似方法(infLaplace)
% 
% 函数说明：
%  高斯过程后验分布的近似：Laplace近似。
%
% 参数说明：
%   输入参数：
%       hyperpara：超参数(hyperparameters)
%       meanfunc ：均值函数
%       kernel   ：核函数(协方差函数)
%       likfunc  ：似然函数
%       x        ：函数自变量(输入)
%       y        ：函数相应结果
%       opt      ：优化参数

%% 准备工作
infmethod = 'infLaplace';
persistent old_alpha;                 %persistent变量，保证函数调用时前一次调用改变后的参数传递给下一次调用
if any(isnan(old_alpha))        %若前一次函数调用后参数old_alpha中出现NaN,则令old_alpha全为0，避免函数出错
    old_alpha = zeros(size(old_alpha));
end   % prevent
if nargin <= 6
    opt = [];                                                               %未给定参数opt时，opt设置为空
end            
n = size(x,1);                                                                          %输入列向量的长度
if isstruct(kernel)
    K = kernel;                                                              %使用输入的核函数(协方差函数)
else
    K = apx(hyperpara,kernel,x,opt); 
end                                                                              %协方差近似(apx近似函数)
if isnumeric(meanfunc)
    mean = meanfunc;                                                                  %使用输入的均值向量
else
    [mean,mean_dr] = feval(meanfunc{:},hyperpara.mean,x);                           %计算均值向量及其导数
end
likfun = @(f) feval(likfunc{:},hyperpara.lik,y,f,[],infmethod);                          %取log的似然函数

if any(size(old_alpha) ~= [n,1])                                              %找到alpha和函数f的迭代起点 
  alpha = zeros(n,1);                                     %如果old_alpha大小不匹配，则old_alpha赋值为0向量
else
  alpha = old_alpha;                                                               %尝试上一次使用的alpha
  if Psi(alpha,mean,K.mvm,likfun) > -sum(likfun(mean)) 
    alpha = zeros(n,1);
  end
end

%% GPML提供的IRLS优化方法
%优化方法(GPML p41-p52)
alpha = irls(alpha, mean,K,likfun, opt);%使用IRLS(Iteratively Reweighted Least Squares,加权迭代最小二乘方法)
f = K.mvm(alpha)+mean;                                                                %计算f(GPML 公式3.33)
old_alpha = alpha;                                                                                %更新参数
[logprob,logprob_dr1,logprob_dr2,logprob_dr3] = likfun(f);                      %计算概率取log及其一二三阶导
W = -logprob_dr2;                                                                                   %计算W
[logdB2,KW,dW,hyp_dr] = K.fun(W);      
posterior.alpha = K.P(alpha);                                                          %返回值为后验的alpha
posterior.sW = sqrt(abs(W)).*sign(W);                                                             %保号运算
posterior.L = @(r) - K.P(KW(K.Pt(r)));

logMaLik = alpha'*(f - mean)/2 - sum(logprob) + logdB2;                                  %计算边缘似然函数值
if nargout > 2                                                                      %参数大于2是需要计算导数
  fhat_dr1 = dW.*logprob_dr3;                      %fhat的一阶导数:计算公式dfhat=diag(inv(inv(K)+W)).*d3lp/2
  ahat_dr1 = fhat_dr1 - KW(K.mvm(fhat_dr1));                                                 %ahat的一阶导数
  logZ_dr1 = hyp_dr(alpha,logprob_dr1,ahat_dr1);                                             %logZ的一阶导数
  logZ_dr1.lik = zeros(size(hyperpara.lik));                                                         %初始化
  for i = 1:length(hyperpara.lik)                                                           %似然函数的超参数
    [logprob_dhyp,logprob_dhyp_dr1,logprob_dhyp_dr2] = feval(likfunc{:},hyperpara.lik,y,f,[],infmethod,i);
    logZ_dr1.lik(i) = -dW'* logprob_dhyp_dr2 - sum(logprob_dhyp);
    b = K.mvm(logprob_dhyp_dr1);                          %计算参数b:公式b-K*(Z*b) = inv(eye(n)+K*diag(W))*b
    logZ_dr1.lik(i) = logZ_dr1.lik(i) - fhat_dr1'*(b-K.mvm(KW(b)));
  end
  logZ_dr1.mean = -mean_dr(alpha + ahat_dr1);
end

%% GPML 公式3.35-3.39
%   Psi(alpha) = alpha'*K*alpha + likfun(f)
%   f = K*alpha+m
%   likfun(f) = feval(lik{:},hyp.lik,y,f,[],inf).
function [psi,psi_dr,f,alpha,logprob_dr,W] = Psi(alpha,m,mvmK,likfun)
% 函数：根据公式计算Psi及其一阶导数
  f = mvmK(alpha)+m;
  [logprob,logprob_dr,logprob_dr2] = likfun(f); 
  W = -logprob_dr2;
  psi = alpha'*(f-m)/2 - sum(logprob);
  if nargout>1
      psi_dr = mvmK(alpha-logprob_dr); 
  end

%%IRLS加权迭代最小二乘算法  
%使用IRLS加权迭代最小二乘算法优化Psi及参数alpha
function alpha = irls(alpha, m,K,likfun, opt)
%% 基本参数设置
  if isfield(opt,'irls_maxit')
      maxiter = opt.irls_maxit;              %牛顿迭代算法最大步长
  else
      maxiter = 20;                              %maxit默认值为20
  end
  if isfield(opt,'irls_Wmin')
      Wmin = opt.irls_Wmin;                %似然函数迭代的最小曲率
  else
      Wmin = 0.0;                                      %默认值为0
  end
  if isfield(opt,'irls_tol')
      tol = opt.irls_tol;                        %停止迭代时的取值
  else
      tol = 1e-6;                                   %默认值为1e-6
  end
  
  smin_line = 0; smax_line = 2;                %步长最大最小值设置
  nmax_line = 10;                                       %最大设置
  threshold_line = 1e-4;                                %阈值设置
  Psi_line = @(s,alpha,dalpha) Psi(alpha+s*dalpha,m,K.mvm,likfun);
  paras_line = {smin_line,smax_line,nmax_line,threshold_line};
  search_line = @(alpha,dalpha) brentmin(paras_line{:},Psi_line,5,alpha,dalpha);
  f = K.mvm(alpha)+m; 
  [~,logprob_dr1,logprob_dr2] = likfun(f); 
  W = -logprob_dr2; 
  Psi_new = Psi(alpha,m,K.mvm,likfun);
  Psi_old = Inf;
  iter = 0;
  
%% 牛顿迭代方法
  while Psi_old - Psi_new > tol && iter < maxiter   %牛顿迭代开始
    Psi_old = Psi_new; 
    iter = iter+1;
    W = max(W,Wmin);                     %通过增加曲率减小迭代步长
    [~,solveKiW] = K.fun(W); b = W.*(f-m) + logprob_dr1;
    dalpha = b - solveKiW(K.mvm(b)) - alpha;        %牛顿迭代公式
    [~,Psi_new,~,~,f,alpha,logprob_dr1,W] = search_line(alpha,dalpha);
  end                                               %牛顿迭代结束