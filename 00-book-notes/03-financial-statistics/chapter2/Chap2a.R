#============================================
#================== Part 1 ==================
#============================================
# two correlation coefficients
data = read.table("ch2data/m-ibmsp6709.txt",header = T)
head(data)
ibm = data$ibm
sp5 = data$sp
cor(sp5, ibm, method = "spearman") # Spearman Correlation
cor(sp5, ibm, method = "kendall")  # Kendall Correlation

#============================================
#================== Part 2 ==================
#============================================
# auto correlation (lag-k autocorrelation)
data = read.table("ch2data/m-dec12910.txt", header = T)
head(data)
d10 = data$dec10
dec10 = ts(d10, frequency = 12, start = c(1967,1))
par(mfcol = c(2,1))
plot(dec10, xlab = "year", ylab = "returns")
title(main = "(a): Simple Returns")
acf(d10, lag = 24) # Obtain sample ACF of the data

#============================================
#================== Part 3 ==================
#============================================
# Single ACF Testing
par(mfcol = c(1,1))
T0 = length(d10)
f1 = acf(d10, lag = 24)
f1$acf
tt = f1$acf[13]*sqrt(T0)
print(tt)
qnorm(0.975)  # tt>qnorm(0.975)


#============================================
#================== Part 4 ==================
#============================================
#混成统计量(Portmanteau Statistic)
# Testing a few autocorrelation (whether equals to 0)
# Ljung-BOx Testing
data = read.table("ch2data/m-ibmsp6709.txt",header = T)
ibm = data$ibm
logibm = log(ibm+1)
par(mfcol = c(2,1))
# f1 = acf(ibm, lag = 100)
# f2 = acf(logibm, lag = 100)
Box.test(ibm, lag = 12, type = "Ljung")
Box.test(logibm, lag = 12, type = "Ljung")


#============================================
#================== Part 5 ==================
#============================================
# AR (Auto Regression) Model
data = read.table("ch2data/q-gnp4710.txt", header = T)
head(data)
G = data$VALUE
logG = log(G)
gnp = diff(logG)
dim(data)
timeindex = c(1:253)
par(mfcol = c(2,1))
plot(timeindex, logG, xlab = "year", ylab = "GNP", type = "l")
plot(timeindex[2:253], gnp, type = "l", xlab = "year", ylab = "growth")
acf(gnp,lag = 12)   # ACF
pacf(gnp, lag = 12) # PACF(Partial ACF)

# model
model = arima(gnp,order = c(3,0,0))
model
tsdiag(model, gof = 12) # model checking
poly = c(1, -model$coef[1:3])
roots = polyroot(poly) # solve polynomial equation
Mod(roots) # compute abs values
period_len = 2*pi/(acos(1.616116/1.832674))
period_len
#AR(2)时间序列的平稳性条件是它的两个特征根的
#绝对值都小于1,或者说它的两个特征根的模小于1


#============================================
#================== Part 6 ==================
#============================================
# recognize the order p or AR(p) model
# (order determination)
# 1. PACF(Partial AutoCorrelation Function)
# 准则：AR(p)序列的偏自相关函数是p步截尾的


# 2. Information Criteria
# AIC(Akike Information Criterion)
# BIC(Bayesian Information Criterion)
# 当样本容量较大时，BIC比AIC更倾向于选择一个低阶的AR模型
# 目标：选择不同的阶数，找出使得AIC/BIC最小的阶数
data = read.table("ch2data/q-gnp4710.txt", header = T)
head(data)
G = data$VALUE
logG = log(G)
gnp = diff(logG)
mm1 = ar(gnp, method = "mle")
mm1$order
names(mm1)
print(mm1$aic, digits = 3)
aic = mm1$aic
length(aic)
# plot and mark the x/y axes.
plot(c(0:12),aic, type = "h", xlab = "order", ylab = "aic")
lines(0:12,aic,lty = 2)

#============================================
#================== Part 7 ==================
#============================================
# Parameter Estimation
# 最小二乘法和条件高斯最大似然方法方差估计不同
# 平均年度简单毛收益率
data = read.table("ch2data/m-ibm3dx2608.txt",header = T)
vw = data[,3]
L =  length(vw)
t1 = prod(vw+1)
print(t1)
print(t1^(12/L) - 1)  # compute Annual Simple Return

#============================================
#================== Part 8 ==================
#============================================
# Model Testing
# check the fitted model (residuals are white noise)
# the autocorrelation funtion of the residuals will be
# tested by Ljung-Box
# arima: fit the model
# tsdiag: diagnois the model
data = read.table("ch2data/m-ibm3dx2608.txt",header = T)
vw = data[,3]
model = arima(vw, order = c(3,0,0))
ar1 = model$coef[1]
ar2 = model$coef[2]
ar3 = model$coef[3]
# compute the intercept phi(0)
(1 - ar1 - ar2 - ar3)*mean(vw)
# compute the standard error of residuals
sqrt(model$sigma2)
# Box-Ljung Test
test = Box.test(model$residuals, lag = 12, type = "Ljung")
print(test)
x.squared = test$statistic
p.value = 1 - pchisq(x.squared, 9)

### fix AR(2) coefficient to zero:
model = arima(vw, order = c(3,0,0), fixed = c(NA,0,NA,NA))
model
ar1 = model$coef[1]
ar2 = model$coef[2]
ar3 = model$coef[3]
# compute the intercept phi(0)
(1 - ar1 - ar2 - ar3)*mean(vw)
# compute the standard error of residuals
sqrt(model$sigma2)
# Box-Ljung Test
test = Box.test(model$residuals, lag = 12, type = "Ljung")
print(test)
x.squared = test$statistic
p.value = 1 - pchisq(x.squared, 10)


#============================================
#================== Part 9 ==================
#============================================
# Goddness of Fit
# 1. R^2
# The larger R^2 is , the better the model fits
# 2. Adjusted-R^2
# 调整后的R^2将拟合模型用到的参数个数也考虑在内
# 超前预测
# 超前1步--超前2步--超前多步


# (MA model) moving average model
# MA模型可以理解为：参数收到某种限制的无穷阶AR模型
# MA模型的性质：
# 1. 平稳性 2. 自相关函数 3. 可逆性

# MA模型定阶(order determination): 自相关函数ACF法
# MA模型估计: 条件似然法和精确似然法
# R用精确似然法估计

# MA模型预测: 超前1步/2步/多步预测

data = read.table("ch2data/m-ibm3dx2608.txt",header = T)
head(data)
ew = data$ewrtn
# an unrestricted model
model = arima(ew, order = c(0,0,9))
model
# restricted model
model = arima(ew, order = c(0,0,9), fixed = c(NA,0,NA,0,0,0,0,0,NA,NA))
model
# compute the standard error
sqrt(model$sigma2)

test = Box.test(model$residuals, lag = 12, type = "Ljung")
test
p.value = 1- pchisq(test$statistic,9)
p.value

### To perform out of sample prediction at forecast origin 986
model = arima(ew[1:986], order = c(0,0,9), fixed = c(NA,0,NA,0,0,0,0,0,NA,NA))
model
predict(model, 10)

## 对MA模型: ACF对模型的定阶是有用的;ACF是q步截尾的
## 对AR模型:PACF对模型的定阶是有用的;PACF是p步截尾的
## MA序列总是平稳的。而对AR序列, 当其特征根的模都小于1时才是平稳的#
## 对一个平稳序列,超前多步预测收敛于序列的均值,预测误差的方差收敛于序列的方差




