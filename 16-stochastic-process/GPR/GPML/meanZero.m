function [meanfunc,deriv] = meanZero(hyperpara, input)
% 函数：
%   零均值函数。
% 功能：
%   均值函数为0，不含任何参数(参数为空)
% 参数说明：
%   输入参数：
%       hyperpara：超参数(hyperparameter),此函数为空。
%       input    ：输入的
%   输出参数：
%       meanfunc ：均值函数
%       deriv    ：方向导数

    if nargin < 2
        meanfunc = '0';                       %均值函数为0
        return;
    end
    meanfunc = zeros(size(input,1),1);          % 均值函数
    deriv = @(q) zeros(0,1);                 	% 方向导数
end
