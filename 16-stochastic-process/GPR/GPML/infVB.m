function [posterior, logZ, logZ_dr] = infVB(hyperpara, meanfunc, kernel, likfunc, x, y, opt)
% 函数：
%   贝叶斯推断近似方法 之 变分贝叶斯方法(Variational Bayesian)
%
% 函数说明：
%   高斯过程后验分布的近似：变分贝叶斯近似。
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

n = size(x,1);                                                                          %输入列向量的长度
if nargin <= 6
    opt = [];                                                               %未给定参数opt时，opt设置为空
end            
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
if iscell(likfunc)
    likstr = likfunc{1}; 
else
    likstr = likfunc; 
end
if ~ischar(likstr)
    likstr = func2str(likstr);
end

if ~isfield(opt,'postL')
    opt.postL = false; 
end
if isfield(opt,'out_nmax')
    out_nmax = opt.out_nmax;
else
    out_nmax = 15;                                                                         %默认值设置
end
if isfield(opt,'out_tol')
    out_tol  = opt.out_tol;
else
    out_tol = 1e-5;                                                                        %默认值设置
end

sW = ones(n,1);                                                                                %初始化
opt.postL = false;
for i=1:out_nmax
  [~,~,Wdr] = K.fun(sW.*sW); v = 2*Wdr;
  [posterior,~,~,alpha] = infLaplace(hyperpara, meanfunc, K, {@varibayes,v,likfunc}, x, y, opt);
  sW_old = sW; f = K.mvm(alpha)+mean;
  [lp,~,~,sW,b,z] = feval(@varibayes,v,likfunc,hyperpara.lik,y,f);
  if max(abs(sW-sW_old)) < out_tol
      break;
  end
end

posterior.sW = sW;                                                                      %后验参数
[logdB2,KW,Wdr,hyp_dr] = K.fun(sW.*sW); 
posterior.L = @(r) -K.P(KW(K.Pt(r)));

gamma = 1./(sW.*sW); 
beta = b + z./gamma;
h = f.*(2*beta-f./gamma) - 2*lp - v./gamma; %计算公式：h(ga) = s*(2*b - f/ga)+ h*(s) - v*(1 / ga)
t = b.*gamma + z - mean; 
logZ = logdB2 + (sum(h)+ t'*KW(t) - (beta.*beta)'*gamma)/2;                             %方差界限

if nargout > 2                                                       %输入参数多于2个时需要计算导数
  logZ_dr = hyp_dr(alpha);                                                            % 协方差参数
  logZ_dr.lik = zeros(size(hyperpara.lik));                                               %初始化
  if ~strcmp(likstr,'likGauss')                                                      %高斯似然函数
    for j=1:length(hyperpara.lik)
      sign_fmz = 2*(f-z >= 0)-1;
      g = sign_fmz.*sqrt((f - z).^2 + v) + z;
      dhhyp = -2*feval(likfunc{:},hyperpara.lik,y,g,[],'infLaplace',j);
      logZ_dr.lik(j) = sum(dhhyp)/2;
    end  
  else                                                                       %高斯情形下的特殊处理
    sn2 = exp(2*hyperpara.lik); 
    logZ_dr.lik = - sn2*(alpha'*alpha) - 2*sum(Wdr)/sn2 + n;
  end
  logZ_dr.mean = - mean_dr(alpha);                                               %均值函数的超参数
end

function [varargout] = varibayes(var, likfunc, varargin)
% 函数：
%   变分贝叶斯似然函数
%   varibayes(f) = lik(..,g,..)*exp(b*(f - g))
%   g = sign(f - z)*sqrt((f - z)^2 + v) + z
%   p(y|f) \ge exp((b + z/ga)*f - f.^2/(2*ga) - h(ga)/2)
% 参数说明：
%   var    ：边缘似然的方差
%   likfunc：输入似然函数形式

  [b,z] = feval(likfunc{:},varargin{1:2},[],zeros(size(var)),'infVB');
  f = varargin{3};
  sign_fmz = 2*(f-z>=0)-1;
  g = sign_fmz.*sqrt((f-z).^2 + var) + z;
  varargin{3} = g;
  id = (var==0 | abs(f./sqrt(var+eps))>1e10);

  varargout = cell(nargout,1);                                      %初始化输出
  [varargout{1:min(nargout,3)}] = feval(likfunc{:},varargin{1:3},[],'infLaplace');
  if nargout > 0
    logprob = varargout{1}; 
    varargout{1} = logprob + b.*(f - g);
    varargout{1}(id) = logprob(id);
    if nargout > 1                                              %需要求一阶导数
      dg_df = (abs(f - z) + eps)./(abs(g - z)+eps);    %var=0,f=0时稳定化dg/df
      logprob_dr = varargout{2};
      varargout{2} = logprob_dr.*dg_df + b.*(1-dg_df);
      varargout{2}(id) = logprob_dr(id); 
      if nargout > 2                                           % 需要求二阶导数
        logprob_dr2 = varargout{3};
        g_e = g - z + sign_fmz*eps;
        v_g3  = var./(g_e.*g_e.*g_e);                             %稳定化v/g^3
        varargout{3} = (logprob_dr - b).*v_g3 + logprob_dr2.*dg_df.*dg_df;
        varargout{3}(id) = logprob_dr2(id);
        if nargout > 3
          W = abs((b - logprob_dr)./(g - z + sign_fmz/1.5e8));
          varargout{4} = sqrt(W);
          if nargout > 4
            varargout{5} = b;
            if nargout > 5
              varargout{6} = z;
            end
          end
        end
      end
    end
  end