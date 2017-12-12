# EM算法估计GMM(高斯混合模型参数)
norm.mix = function(x, y, K = 2) {
	# 输入：x和y为向量
	#       K为设定的高斯分布的个数
	# 输出：一个列表，包含了估计得到的各参数值
	#				alpha: 常数，α值
	#				   mu: 均值向量，长度为K
	#				   pi: 先验分布概率，长度为K
	#				sigsq: 常数，σ^2值

	# 各参数初始化
  N = length(x)
  pik = rep(1/K, K)
  alpha = 0.1
  sigsq = var(x)
  mu = rep(mean(x),K)
  # z矩阵初始化
  prob = matrix(rep(0,N*K),ncol = K)
  # 迭代次数
  Iteration = 5

  # 逐次更新参数
  for (iter in 1:Iteration){
  	# 先求解概率矩阵
    for (i in 1:N){
      for (k in 1:K){
        prob[i,k] = sapply(x[i],dnorm,mu[k]-alpha*y[i],sqrt(sigsq))
      }
    }
    # 计算z的参数
    probsum = prob%*%pik
    for (i in 1:N){
       for (k in 1:K){
         prob[i,k] = prob[i,k]*pik[k]/probsum[k]
       }
    }
    z = prob
    
    # 保留原始参数
    old_mu = mu
    old_alpha = alpha
    old_sigsq = sigsq

    # 参数进行更新，根据作业中推导得到的公式
    mu_up = mu
    for (k in 1:K){
      zsum = sum(z[,k])
      pik[k] = zsum/N
      mu_up[k] = z[,k]%*%(x+old_alpha*y)
      mu[k] = mu_up[k]/sum(z[,k])
    }
    tmp1 = z
    tmp2 = z
    for (i in 1:N){
      for (k in 1:K){
        tmp1[i,k] = z[i,k]*(x[i]-old_mu[k]+alpha*y[i])^2
        tmp2[i,k] = z[i,k]*old_mu[k]*y[i]
      }
    }
    sigsq = sum(tmp1)/N
    alpha = -(t(x)%*%y-sum(tmp2))/sum(y*y)
  }
  # 迭代次数完成，返回结果
  res = list(alpha = alpha, pi = pik, mu = mu, sigsq = sigsq)
  print(res)
  return(res)
}

# ------------TEST---------------
# 参数初始化
mu1 = 3
mu2 = -2
sig0 = 2
pi1 = 0.4
pi2 = 0.6
alpha = 0.5
num = 5000
# 生成x和y
x = rep(0,num)
y = seq(1,num)*0.001
n1 = floor(num*pi1)
n2 = num - n1
x[1:n1] = rnorm(n1)*sig0 + mu1 - alpha*y[1:n1]
x[(n1+1):num] = rnorm(n2)*sig0 + mu2 - alpha*y[1:n2]
# 观察x的分布
hist(x, freq = F)
lines(density(x),col = "red")
# 获取返回值
res = norm.mix(x, y, K = 2)