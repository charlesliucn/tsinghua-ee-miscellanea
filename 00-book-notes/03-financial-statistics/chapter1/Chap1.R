#===========================================
#================== Part 1==================
#===========================================
# first shot
#install.packages("quantmod")
#install.packages("TTR")
#install.packages("xts")
#install.packages("zoo")
library(quantmod)
getSymbols("AAPL")
dim(AAPL)
head(AAPL)
tail(AAPL)
chartSeries(AAPL)
chartSeries(AAPL, theme = "white")
getSymbols("UNRATE", src = "FRED")
chartSeries(UNRATE)
getSymbols("INTC",src = "google")
chartSeries(INTC)
getSymbols("^TNX")
chartSeries(TNX, theme = "white",TA = NULL)

#===========================================
#================ Part 2 ===================
#===========================================
# fBasics
# install.packages("fBasics")
library(fBasics)
data = read.table("ch1data/d-ibm-0110.txt",header = T)
head(data)
dim(data)

#===========================================
#================ Part 3 ===================
#===========================================
# Financial Data Examples
library(quantmod)
getSymbols("AAPL",from = "2007-01-03", to = "2011-12-02")
AAPL.return = diff(log(AAPL$AAPL.Adjusted))
chartSeries(AAPL.return,theme = "white")

getSymbols("^TNX",from = "2007-01-03", to = "2011-12-02")
TNX.return = diff(log(TNX$TNX.Adjusted))
chartSeries(TNX.return, theme = "white")

getSymbols("DEXUSEU", src = "FRED")
head(DEXUSEU)
tail(DEXUSEU)
USEU.return = diff(log(DEXUSEU$DEXUSEU))
chartSeries(DEXUSEU,theme = "white")
chartSeries(USEU.return,theme = "white")

#============================================
#================= Part 4 ===================
#============================================
# Hypotheses Testing
library(fBasics)
data = read.table("ch1data/d-mmm-0111.txt",header = T)
head(data)
mmm = data[,2]
print(mmm)
basicStats(mmm)
mean(mmm)
var(mmm)
stdev(mmm)
# simple tests
t.test(mmm)
s3 = skewness(mmm)
T = length(mmm)
t3 = s3/sqrt(6/T)
pp = 2*(1-pnorm(t3))
print(pp)
s4 = kurtosis(mmm)
t4 = s4/sqrt(24/T)
print(t4)
normalTest(mmm,method = "jb") # Jarque-Bera Test

#===========================================
#================== Part 5 =================
#===========================================
# Data Visualization
library(fBasics)
data = read.table("ch1data/d-mmm-0111.txt",header = T)
mmm = data[,2]
# histplot and smoothing density
hist(mmm, nclass = 30)
density_est = density(mmm)
range(mmm)
x = seq(-0.1,0.1,0.001)
y = dnorm(x, mean(mmm), stdev(mmm))
plot(density_est$x, density_est$y,xlab = "return",
     ylab = "density", type = "l")
lines(x,y,lty = 2)

# bar chart(ohlc)
library(quantmod)
getSymbols("AAPL",from = "2011-01-03", to = "2011-06-30")
X = AAPL[,1:4]
xx = cbind(as.numeric(X[,1]),as.numeric(X[,2]),
           as.numeric(X[,3]),as.numeric(X[,4]))
source("ohlc.R")
ohlc_plot(xx, xl = "days", yl = "price", title = "Apple Stock")  # xl not x-one

# moving average chart
source("ma.R")
getSymbols("AAPL",from = "2010-01-02", to = "2011-12-08")
x = as.numeric(AAPL$AAPL.Close)
ma(x,21)

# data by time
data = read.table("ch1data/m-ibmsp-2611.txt", header = T)
head(data)
ibm = log(data$ibm+1)
sp = log(data$sp+1)
timeindex = c(1:nrow(data))
par(mfcol = c(2,1))
plot(timeindex, ibm, xlab = "year", ylab = "log_return",type = "l")
title(main = "(a)  IBM returns")
plot(timeindex, sp, xlab = "year", ylab = "log_return", type = "l")
title(main = "(b)  SP index")

# scatter plot and least square
par(mfcol = c(1,1))
cor(ibm,sp)
model = lm(ibm~sp)
summary(model)
plot(sp, ibm , cex = 0.8) # scatterplot
abline(0.007768,0.806685)


#=============================================
#================== Part 6 ===================
#=============================================
# Testing bivariate normal distribution
# By Simulate the distribution by multivariate
# normal distribution (mean vector and cov matrix)
data = read.table("ch1data/m-ibmsp-2611.txt",header = T)
dim(data)
ibm = log(data$ibm+1)
sp = log(data$sp+1)
return = cbind(ibm, sp) # bivariate returns
means = apply(return,2,mean)
cov.matrix = cov(return)
print(means)
print(cov.matrix)
# install.packages("mnormt")
library(mnormt)
x = rmnorm(1029, mean = means, varcov = cov.matrix)
dim(x)
plot(x[,2],x[,1],xlab = "sim-sp", ylab = "sim-ibm", cex = 0.8)
















