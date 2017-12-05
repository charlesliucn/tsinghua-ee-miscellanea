function varargout = likGauss(hyperpara, y, mean, var, infmethod,i)
% 函数：
%   高斯似然函数(Gaussian Likelihood Function)，用于高斯过程回归(GPR).
%   
% 函数说明：
%   似然函数形式：
%       f(t) = exp(-(t-y)^2/(2*sn^2)) / sqrt(2*pi*sn^2)
%   其中，y对应高斯分布的均值参数μ，sn对应高斯分布的标准差sigma参数.
%   本函数提供了多种似然函数的使用方法，分别用于计算似然值、导数及矩。
%
% 超参数：
%   hyperpara = log(sn)
%
% 参数说明：
%   输入参数：
%       hyperpara：超参数
%       y        ：输入数据
%       mean     ：输入均值
%       var      ：输入方差
%       infmethod：推断方式：提供Laplace近似、期望传播(Expectation Propagation)
%                  方法及变分贝叶斯(Variational Bayesian)方法
%   输出参数：
%   a) Laplace Approximation  ：{logprob,loglike_dr1,loglike_dr2,loglike_dr3}
%                               {logprob_dhyp,logprob_dr1_dhyp,logprob_dr2_dhyp}
%   b) Expectation Propagation：{logZ,logZ_dr1,logZ_dr2}
%                               {logZ_dr1_hyp}
%   c) Variational Bayesian   ：{b,y}
%   d) Default                ：{logprob,y_mean,y_var}

if nargin <= 2                                                  %输入参数小于等于2
    varargout = {'1'};                           %未输入均值和方差时，超参数数目为1
    return;
end
sn2 = exp(2*hyperpara);                      %由hyperpara得到高斯似然函数的方差参数
if nargin <=4                                    %输入了均值和方差，但未指定推断方式
  if isempty(y)
      y = zeros(size(mean)); 
  end
  var_zero = 1; 
  if nargin > 3 && numel(var) > 0 && norm(var) > eps
      var_zero = 0; 
  end
  if var_zero
    logprob = -(y - mean).^2./sn2/2 - log(2*pi*sn2)/2;              %计算概率的log
    var = 0; 
  else
    logprob = likGauss(hyperpara, y, mean, var,'infEP');             %期望传播估计
  end
  y_mean = {}; y_var = {};
  if nargout > 1
    y_mean = mean;                                                 %y的一阶矩(期望)
    if nargout > 2
      y_var = var + sn2;                                                %y的二阶矩
    end
  end
  varargout = {logprob,y_mean,y_var};
else
  switch infmethod
  %*********Laplace方法*********%
  case 'infLaplace' 
	if nargin <= 5                                          %不需要计算超参数的倒数
        if isempty(y)
            y = 0; 
        end
        y_center = y - mean;                                               %中心化
        loglike_dr1 = {}; loglike_dr2 = {}; loglike_dr3 = {};%概率取log的一二三阶导
        logprob = - y_center.^2/(2*sn2) - log(2*pi*sn2)/2;              %概率取log
        if nargout > 1
            loglike_dr1 = y_center/sn2;                    %似然函数取log的一阶导数
            if nargout > 2                                 %似然函数取log的二阶导数
                loglike_dr2 = -ones(size(y_center))/sn2;
                if nargout > 3                             %似然函数取log的三阶导数
                loglike_dr3 = zeros(size(y_center));
                end
            end
        end
        varargout = {logprob,loglike_dr1,loglike_dr2,loglike_dr3};     %函数输出结果
    else                                                        %需要计算超参数的倒数
      	logprob_dhyp = (y - mean).^2/sn2 - 1;          %关于超参数的对数似然函数的导数
        logprob_dr1_dhyp = 2*(mean - y)/sn2;                               %一阶导数
        logprob_dr2_dhyp = 2*ones(size(mean))/sn2;                         %二阶导数
        varargout = {logprob_dhyp,logprob_dr1_dhyp,logprob_dr2_dhyp};   %函数输出结果
    end
  %***********期望传播方法************%
  case 'infEP'                                                         %期望传播方法
    if nargin <= 5                                            %不需要计算超参数的倒数
        logZ = -(y-mean).^2./(sn2 + var)/2 - log(2*pi*(sn2 + var))/2;%配分函数取对数
        logZ_dr1 = {}; logZ_dr2 = {};                             %配分函数的一二阶导
        if nargout > 1
            logZ_dr1  = (y - mean)./(sn2 + var);                           %一阶导数
            if nargout>2
                logZ_dr2 = -1./(sn2 + var);                                %二阶导数
            end
        end
        varargout = {logZ,logZ_dr1,logZ_dr2};                          %函数输出结果
    else                                                        %需要计算超参数的导数
     	logZ_dr1_hyp = ((y - mean).^2./(sn2 + var) - 1) ./ (1 + var./sn2);
        varargout = {logZ_dr1_hyp};                                     %函数输出结果
    end
  %***********变分贝叶斯方法***********%
  case 'infVB'  
    n = numel(var); 
    b = zeros(n,1); 
    y = y.*ones(n,1); 
    varargout = {b,y};
  end
end
