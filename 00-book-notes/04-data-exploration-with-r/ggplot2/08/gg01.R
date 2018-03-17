library(ggplot2)
data(diamonds)
qplot(carat, price, data = diamonds)
## 对数变换
qplot(log(carat), log(price), data = diamonds)
## 体积与重量的关系
qplot(carat, x*y*z, data = diamonds)
## 装饰属性
set.seed(1410)
dsmall = diamonds[sample(nrow(diamonds), 100), ]
qplot(carat, price, data = dsmall, colour = color)
qplot(carat, price, data = dsmall, shape = cut)
## alpha值
qplot(carat, price, data = diamonds, alpha = I(1/10))
qplot(carat, price, data = diamonds, alpha = I(1/100))
qplot(carat, price, data = diamonds, alpha = I(1/200))
## 平滑曲线
qplot(carat, price, data = dsmall, 
      geom = c("point", "smooth"))
qplot(carat, price, data = diamonds, 
      geom = c("point", "smooth"))
## 多项式拟合
qplot(carat, price,
      data = dsmall, 
      geom = c("point", "smooth"),
      span = 0.2)
qplot(carat, price, 
      data = dsmall, 
      geom = c("point", "smooth"),
      span = 1)
## method = GAM
qplot(carat, price, data = dsmall, 
      geom = c("point", "smooth"),
      method = "gam", 
      formula = y ~ s(x))
qplot(carat, price, data = dsmall, 
      geom = c("point", "smooth"),
      method = "gam", 
      formula = y ~ s(x, bs = "cs"))
## 箱线图
qplot(color, price / carat, 
      data = diamonds, 
      geom = "boxplot")
## jitter 波动点
qplot(color, price / carat, 
      data = diamonds, 
      geom = "jitter")
## jitter 再加上alpha
qplot(color, price / carat, 
      data = diamonds, 
      geom = "jitter",
      alpha = I(1 / 5))
qplot(color, price / carat, 
      data = diamonds, 
      geom = "jitter",
      alpha = I(1 / 50))
qplot(color, price / carat, 
      data = diamonds, 
      geom = "jitter",
      alpha = I(1 / 200))
## 直方图
qplot(carat, data = diamonds, 
      geom = "histogram")
## 设置直方图的区间
qplot(carat, data = diamonds, 
      geom = "histogram", 
      binwidth = 1,
      xlim = c(0,3))
qplot(carat, data = diamonds, 
      geom = "histogram", 
      binwidth = 0.1,
      xlim = c(0,3))
qplot(carat, data = diamonds, 
      geom = "histogram", 
      binwidth = 0.01,
      xlim = c(0,3))
## 设置色彩
qplot(carat, data = diamonds, 
      geom = "histogram", 
      fill = color)
## 密度曲线图
qplot(carat, data = diamonds, 
      geom = "density")
## 设置密度曲线的彩色
qplot(carat, data = diamonds, 
      geom = "density", 
      colour = color)
## 柱状图
qplot(color, data = diamonds,
      geom = "bar")
## 求和
qplot(color, data = diamonds, 
      geom = "bar", weight = carat) 
+ scale_y_continuous("carat")

#=================
#=====时间序列====
#=================
data("economics")
## 连接线表示时间序列
qplot(date, unemploy / pop, 
      data = economics, 
      geom = "line")
## 路径表达方式
year = function(x) as.POSIXlt(x)$year + 1900
qplot(unemploy / pop, uempmed, 
      data = economics,
      geom = c("point", "path"))
## 彩色路径
qplot(unemploy / pop, uempmed, 
      data = economics,
      geom = "path", 
      colour = year(date)) 
## Facet面
qplot(carat, 
      data = diamonds, 
      facets = color ~ .,
      geom = "histogram", 
      binwidth = 0.1, 
      xlim = c(0, 3))
## x,y轴标记
qplot(carat, price, 
      data = dsmall,
      xlab = "Price ($)", 
      ylab = "Weight (carats)",
      main = "Price-weight relationship")
## x,y轴的限制范围
qplot(carat, price / carat, 
      data = dsmall,
      ylab = expression(frac(price,carat)),
      xlab = "Weight (carats)",
      main="Small diamonds",
      xlim = c(.2,1))
qplot(carat, price, 
      data = dsmall, 
      log = "xy")
