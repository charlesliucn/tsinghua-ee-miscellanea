# R语言作散点图

# 1. 利用xyplot()对散点分组
library(lattice)
data("mtcars")
xyplot(mpg~disp,
       data=mtcars,
       groups=cyl,
       auto.key=list(corner=c(1,1)))

## install.packages("ggplot2")
library(ggplot2)
qplot(disp, mpg, data = mtcars,col = as.factor(cyl))

# 2. 使用散点形状和大小表示分组
## 使用形状分组
qplot(disp, mpg, data = mtcars,
      shape = as.factor(cyl)) 
## 使用大小分组
qplot(disp, mpg, data = mtcars,
      size = as.factor(cyl))

# 3. 用文本标记点
plot(mpg~disp, data = mtcars)
text(258,22,"Hornet")
health = read.csv("HealthExpenditure.csv", header = TRUE)
plot(health$Expenditure, health$Life_Expectancy, type = "n")
text(health$Expenditure, health$Life_Expectancy, 
     health$Country)

# 4. pairs()散点图和相关系数
panel.cor <- function(x, y, ...)
{
  par(usr = c(0, 1, 0, 1))
  txt <- as.character(format(cor(x, y), digits=2))
  text(0.5, 0.5, txt,  cex = 6* abs(cor(x, y)))
}
pairs(iris[1:4], upper.panel = panel.cor)

# 5. 误差条bar
plot(mpg~disp, data = mtcars)
## 竖直误差条
arrows(x0 = mtcars$disp,
       y0 = mtcars$mpg*0.95,
       x1 = mtcars$disp,
       y1 = mtcars$mpg*1.05,
       angle = 90,
       code  = 3,
       length= 0.04,
       lwd   = 0.4)
## 水平误差条
arrows(x0 = mtcars$disp*0.95,
       y0 = mtcars$mpg,
       x1 = mtcars$disp*1.05,
       y1 = mtcars$mpg,
       angle = 90,
       code  = 3,
       length= 0.04,
       lwd   = 0.4)

# 6. jitter()函数给向量加上噪音
x = rbinom(1000, 10, 0.25)
y = rbinom(1000, 10, 0.25)
plot(x,y)
plot(jitter(x), jitter(y))

# 7. 线性模型：画回归直线
plot(mtcars$mpg ~ mtcars$disp)
lmfit = lm(mtcars$mpg ~ mtcars$disp)
abline(lmfit)

# 8. 非线性模型：拟合曲线
x = -(1:100)/10
y = 100 + 10 * exp(x / 2) + rnorm(x)/10
nlmod = nls(y ~  Const + A * exp(B * x), trace=TRUE)
plot(x,y)
lines(x, predict(nlmod), col = "red")

# 9. lowess:局部加权回归散点平滑法
plot(cars, main = "lowess(cars)")
lines(lowess(cars), col = "blue")	
lines(lowess(cars, f=0.3), col = "orange")

# 10. 三维散点图
## install.packages("scatterplot3d") 
library(scatterplot3d)
scatterplot3d(x = mtcars$wt,
              y = mtcars$disp,
              z = mtcars$mpg)
scatterplot3d(wt, disp, mpg,
              pch=16, highlight.3d=TRUE, angle=20,
              xlab="Weight",ylab="Displacement",zlab="Fuel Economy (mpg)",
              type="h", main="Relationships between car specifications")

# 11. QQ图
qqnorm(mtcars$mpg)
qqline(mtcars$mpg)
## 线性回归模型的检验
lmfit = lm(mtcars$mpg~mtcars$disp)
par(mfrow = c(2,2))
plot(lmfit)

# 12. 画密度函数
par(mfrow = c(1,1))
x = rnorm(1000)
plot(density(x),type = "l") 
rug(x)
## rug函数看分布
metals = read.csv("metals.csv")
plot(Ba~Cu,data = metals, xlim = c(0,100))
rug(metals$Cu)
rug(metals$Ba, side = 2,
    col = "red", ticksize = 0.02)

# 13 smoothScatter()函数
n = 10000
x = matrix(rnorm(n), ncol=2)
y = matrix(rnorm(n, mean=3, sd=1.5), ncol=2)
smoothScatter(x, y)

