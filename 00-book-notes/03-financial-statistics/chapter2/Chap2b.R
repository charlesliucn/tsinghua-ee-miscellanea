#===========================================
#================= Part 1 ==================
#===========================================
# ARMA模型:将AR和MA模型结合到一个紧凑的形式中
# ARMA模型的概念与波动率建模关系密切
# 广义自回归条件异方差
# (Generalized AutoRegressive Conditional Heteroscedastic)
# GARCH模型，可以认为是序列a_{t}^{2}的ARMA模型
#-------------------------------------------
# ARMA(1,1)模型的性质是AR(1)模型性质的推广
# 平稳性
# 自协方差函数
# ARMA(1,1)模型的ACF不能在任意有限间隔内截尾
#-------------------------------------------
# ARMA模型确定阶数：
# ACF和PACF都不能提供足够信息
# 使用新方法：拓展自相关函数(EACF, Extended...)
# example:

dat = read.table("ch2data/m-3m4608.txt",header = T)
head(data)
#install.packages("TSA")
library(TSA)
mmm = log(dat$rtn+1)
model = eacf(mmm, 6, 12)
names(model)
print(model$eacf, digits = 2)

#-------------------------------------------
# 用ARMA模型进行预测
# ARMA模型的三种表示方式
# 1. ARMA模型公式表示
# 2. AR表示
# 3. MA表示


#===========================================
#================== Part 2 =================
#===========================================
#1. 平稳的序列
#2. 利率、汇率和资产价格序列往往是非平稳的
# 非平稳序列(最常见的例子：随机游动模型)
# 在时间序列文献中叫做：单位根非平稳时间序列
# 随机游动序列(Random Walk), 不是弱平稳的
# 带漂移的随机游动，漂移是一个常数项
# 代表序列的时间斜率
#===========================================
# 一般单位根非平稳模型
# 自回归求和移动平均
# ARIMA(AutoRegressive Integrated Moving Average)
# 处理单位根非平稳性的惯用方法：差分方法
#===========================================
# 单位根检验
# 扩展DF单位根检验(Augmented Dickey-Fuller)

#install.packages("fUnitRoots")
library(fUnitRoots)
dat = read.table("ch2data/q-gdp4708.txt",header = T)
gdp = log(dat[,4])
model = ar(diff(gdp), method = "mle")
model$order
adfTest(gdp, lags = 10, type = c("c"))
# p值为0.4569,单位根假设不能被拒绝

#-------------------------------------------
library(fUnitRoots)
dat = read.table("ch2data/d-sp55008.txt", header = T)
sp5 = log(dat[,7])
model = ar(diff(sp5), method = "mle")
model$order
adfTest(sp5,lags = 2, type = c("ct") )
# p值为0.5708,单位根假设不能被拒绝

adfTest(sp5,lags = 15, type = c("ct") )

dsp5 = diff(sp5)
timeindex = c(1:length(dsp5))
model = arima(dsp5, order = c(2,0,0), xreg = timeindex)
model
model$coef
sqrt(diag(model$var.coef))
tratio = model$coef/sqrt(diag(model$var.coef))
tratio


#===========================================
#================== Part 3 =================
#===========================================
# 预测中经常使用指数平滑法
# 思想：数据越新，对预测值的影响越大
# 指数平滑法是ARIMA模型的特殊情形

dat = read.table("ch2data/d-vix0810.txt",header = T)
vix = log(dat$Close)
length(vix)
model = arima(vix, order = c(0,1,1))
model
test = Box.test(model$residuals, lag = 10, type = "Ljung")
test
pp = 1 - pchisq(test$statistic, 9)
pp
# 残差的Ljung-Box统计量表明拟合的ARIMA(0,1,1)模型是充分的


#===========================================
#================== Part 4 =================
#===========================================
#季节模型：一定的循环或周期性--->季节时间序列
#从时间序列中移除季节性的过程：季节调整
#对数变换在金融、经济时间序列中很常用
#样本自相关图可以看出序列的前后相关性
#处理前后相关性的常用方法：差分→得到平稳性
#-------------------------------------------
# 多重季节模型
# 序列的正规部分与季节部分的动态结构近似正交
# 航空模型：可认为作用于另一个指数平滑模型的
#           指数平滑模型
#-------------------------------------------
da = read.table("ch2data/q-ko-earns8309.txt",header = T)
head(da)
eps=log(da$value)
koeps=ts(eps,frequency=4,start=c(1983,1))
plot(koeps,type='l')
c1 = c("1","2","3","4")
points(koeps,pch=c1,cex=0.6)
par(mfcol=c(2,2))
koeps=log(da$value)
deps=diff(koeps)
sdeps=diff(koeps,4)
ddeps=diff(sdeps)
acf(koeps,lag=20)
acf(deps,lag=20)
acf(sdeps,lag=20)
acf(ddeps,lag=20)
# Obtain time plots
c1=c("2","3","4","1")
c2=c("1","2","3","4")
par(mfcol=c(3,1))
plot(deps,xlab='year',ylab='diff',type='l')
points(deps,pch=c1,cex=0.7)
plot(sdeps,xlab='year',ylab='sea-diff',type='l')
points(sdeps,pch=c2,cex=0.7)
plot(ddeps,xlab='year',ylab='dd',type='l')
points(ddeps,pch=c1,cex=0.7) 
#-------------------------------------------
#Estimation
m1=arima(koeps,order=c(0,1,1),seasonal=list(order=c(0,1,1),period=4))
m1
tsdiag(m1,gof=20)  # model checking
Box.test(m1$residuals,lag=12,type='Ljung')
pp=1-pchisq(13.30,10)
pp
koeps=log(da$value)
length(koeps)
y=koeps[1:100]
m1=arima(y,order=c(0,1,1),seasonal=list(order=c(0,1,1),period=4))
m1
pm1=predict(m1,7)
names(pm1)
pred=pm1$pred
se=pm1$se
ko=da$value
fore=exp(pred+se^2/2)
v1=exp(2*pred+se^2)*(exp(se^2)-1)
s1=sqrt(v1)
eps=ko[80:107]
length(eps)
tdx=(c(1:28)+3)/4+2002
upp=c(ko[100],fore+2*s1)
low=c(ko[100],fore-2*s1)
min(low,eps)
max(upp,eps)
par(mfcol=c(1,1))
plot(tdx,eps,xlab='year',ylab='earnings',type='l',ylim=c(0.35,1.3))
points(tdx[22:28],fore,pch='*')
lines(tdx[21:28],upp,lty=2)
lines(tdx[21:28],low,lty=2)
points(tdx[22:28],ko[101:107],pch='o',cex=0.7)

#===========================================
#================== Part 5 =================
#===========================================
#季节哑变量(dummy variable)用来指示
#一年中的春夏秋冬四季，其中三个用于分析。
da=read.table("ch2data/m-deciles08.txt",header = T)
d1=da[,2]
jan=rep(c(1,rep(0,11)),39) # Create January dummy.
m1=lm(d1~jan)
summary(m1)
m2=arima(d1,order=c(1,0,0),seasonal=list(order=c(1,0,1),period=12))
m2
tsdiag(m2,gof=36)  # plot not shown.
m2=arima(d1,order=c(1,0,0),seasonal=list(order=c(1,0,1), period=12),include.mean=F)
m2

#===========================================
#================== Part 6 =================
#===========================================
# regression models with time series errrors
r1=read.table("ch2data/w-gs1yr.txt",header=T)[,4]
r3=read.table("ch2data/w-gs3yr.txt",header=T)[,4]
m1=lm(r3~r1)
summary(m1)
plot(m1$residuals,type='l')
acf(m1$residuals,lag=36)
c1=diff(r1)
c3=diff(r3)
m2=lm(c3~-1+c1)
summary(m2)
acf(m2$residuals,lag=36)
m3=arima(c3,order=c(0,0,1),xreg=c1,include.mean=F)
m3
rsq=(sum(c3^2)-sum(m3$residuals^2))/sum(c3^2)
rsq

#===========================================
#================== Part 7 =================
#===========================================
#  Long memory
library(fracdiff)
da=read.table("ch2data/d-ibm3dx7008.txt",header=T)
head(da)
ew=abs(da$vwretd)

# obtain Geweke-Port-Hudak estimate using command fdGPH
m3=fdGPH(ew)
m3
m2=fracdiff(ew,nar=1,nma=1)
summary(m2)


# model comparison
da=read.table("ch2data/q-gdpc96.txt",header=T)
head(da)
gdp=log(da$gdp)
dgdp=diff(gdp)
m1=ar(dgdp,method='mle')
m1$order
m2=arima(dgdp,order=c(3,0,0))
m2
m3=arima(dgdp,order=c(3,0,0),season=list(order=c(1,0,1),period=4))
m3
source("backtest.R")    # Perform backtest
mm2=backtest(m2,dgdp,215,1)
mm3=backtest(m3,dgdp,215,1)