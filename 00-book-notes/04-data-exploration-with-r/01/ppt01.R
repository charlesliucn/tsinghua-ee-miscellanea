# 使用样例数据：汽车数据集作出各类基础图

# 1. 散点图
## 最基础的plot函数
plot(cars$dist,cars$speed)
## 学习plot()函数的各个参数
plot(cars$dist~cars$speed,
     main = "Relationship between car distance & speed",
     xlab = "Speed (miles per hour)",
     ylab = "Distance travelled (miles)",
     xlim = c(0,30),
     ylim = c(0,140),
     xaxs = "i",
     yaxs = "i",
     col  = "red",
     pch  = 19)

# 2. 线图
sales = read.csv("dailysales.csv", header = TRUE)
plot(sales$units~as.Date(sales$date, "%d/%m/%y"),
     type = "l",
     main = "Unit Scales in the month of January 2010",
     xlab = "Date",
     ylab = "Number of units sold",
     col  = "blue")
lines(sales$units~as.Date(sales$date, "%d/%m/%y"), col = "red")
## plot()函数属于高水平作图函数，可以独立绘图
## lines()函数属于低水平作图函数，必须加在高水平作图已有的图上


# 3. 柱形图 barplot
sales = read.csv("citysales.csv", header = TRUE)
## 垂直柱形图
barplot(sales$ProductA, names.arg = sales$City, col = "black")
## 水平柱形图
barplot(sales$ProductA, names.arg = sales$City, col = "black", horiz = TRUE)
## 彩色含图例的柱形图
barplot(as.matrix(sales[,2:4]),
        beside = TRUE,
        legend = sales$City,
        col = heat.colors(5),
        border = "white")
## 彩色含图例的水平柱形图
#Horizontal grouped bars with legend
barplot(as.matrix(sales[,2:4]),
        beside = TRUE,
        legend = sales$City,
        col = heat.colors(5),
        border = "white",
        horiz = TRUE)

# 4. 直方图和密度图
hist(rnorm(1000))
hist(islands)
plot(density(rnorm(1000)))

# 5. 箱型图
metals = read.csv("metals.csv", header = TRUE)
boxplot(metals,
        xlab = "Metals",
        ylab = "Atmospheric Concentration in ng per cubic metre",
        main = "Atmospheric Metal Concentrations in London")
copper = read.csv("copper_site.csv", header = TRUE)
boxplot(copper$Cu~copper$Source, 
        xlab = "Measurement Site",
        ylab = "Atmospheric Concentration of Copper in ng per cubic metre",
        main = "Atmospheric Copper Concentrations in London")

# 6. 限制x轴和y轴的范围
plot(cars$dist~cars$speed,
     xlim = c(0,30),
     ylim = c(0,150))
plot(cars$dist~cars$speed,
     xlim = c(0,30),
     ylim = c(0,150),
     xaxs = "i",
     yaxs = "i")
plot(cars$dist~cars$speed,
     xlim = c(30,0),
     ylim = c(0,150),
     xaxs = "i",
     yaxs = "i")

# 7. 创建热力图
heatmap(as.matrix(mtcars), 
        Rowv = NA, 
        Colv = NA, 
        col  = heat.colors(256), 
        scale   = "column",
        margins = c(2,8),
        main    = "Car characteristics by Model")
## 基因热力图
genes = read.csv("genes.csv", header=T)
rownames(genes) = colnames(genes)
image(x = 1:ncol(genes),
      y = 1:nrow(genes),
      z = t(as.matrix(genes)),
      axes = FALSE,
      xlab = "",
      ylab = "" ,
      main = "Gene Correlation Matrix")

axis(1,at = 1:ncol(genes),labels = colnames(genes),
     col = "white",las = 2,cex.axis = 0.8)           
axis(2,at = 1:nrow(genes),labels = rownames(genes),
     col = "white",las = 1,cex.axis = 0.8)

# 8. 创建相关系数矩阵图
pairs(iris[,1:4])
plot(iris[,1:4],
     main = "Relationships between characteristics of iris flowers",
     pch = 19,
     col = "blue",
     cex = 0.9)

# 9. 一张画板上画多个散点图
par(mfrow = c(2,3))
plot(rnorm(100),col = "blue",  main = "Plot No.1")
plot(rnorm(100),col = "blue",  main = "Plot No.2")
plot(rnorm(100),col = "green", main = "Plot No.3")
plot(rnorm(100),col = "black", main = "Plot No.4")
plot(rnorm(100),col = "green", main = "Plot No.5")
plot(rnorm(100),col = "orange",main = "Plot No.6")

par(mfcol = c(2,3))
plot(rnorm(100),col = "blue",  main = "Plot No.1")
plot(rnorm(100),col = "blue",  main = "Plot No.2")
plot(rnorm(100),col = "green", main = "Plot No.3")
plot(rnorm(100),col = "black", main = "Plot No.4")
plot(rnorm(100),col = "green", main = "Plot No.5")
plot(rnorm(100),col = "orange",main = "Plot No.6")

# 10. 市场数据作图
market = read.csv("dailymarket.csv", header = TRUE)
par(mfrow=c(3,1))
plot(market$revenue~as.Date(market$date,"%d/%m/%y"),
     type = "l",
     main = "Revenue",
     xlab = "Date",
     ylab = "US Dollars",
     col  = "blue")
plot(market$profits~as.Date(market$date,"%d/%m/%y"),
     type = "l",
     main = "Profits",
     xlab = "Date",
     ylab = "US Dollars",
     col  = "red")
plot(market$customers~as.Date(market$date,"%d/%m/%y"),
     type = "l",
     main = "Customer visits",
     xlab = "Date",
     ylab = "Number of people",
     col  = "black")

# 11. 降水量数据(增加图例说明)
rain = read.csv("cityrain.csv", header = TRUE)
par(mfrow=c(1,1))
plot(rain$Tokyo,
     type = "l",
     col  = "red",
     ylim = c(0,300),
     main = "Monthly Rainfall in major cities",
     xlab = "Month of Year",
     ylab = "Rainfall (mm)",
     lwd  = 2)
lines(rain$NewYork,type = "l",col = "blue",  lwd=2)
lines(rain$London,type  = "l",col = "green", lwd=2)
lines(rain$Berlin,type  = "l",col = "orange",lwd=2) 
## 增加图例说明
legend("topright",
       legend = c("Tokyo","New York","London","Berlin"),
       col = c("red","blue","green","orange"),
       lty = 1, lwd = 2)
## 方法二
plot(rain$Tokyo,
     type = "l",
     col  = "red",
     ylim = c(0,250),
     main = "Monthly Rainfall in major cities",
     xlab = "Month of Year",
     ylab = "Rainfall (mm)",
     lwd  = 2)
lines(rain$NewYork,type = "l",col = "blue",  lwd = 2)
lines(rain$London, type = "l",col = "green", lwd = 2)
lines(rain$Berlin, type = "l",col = "orange",lwd = 2)
## 增加图例的方法二
legend("top",
       legend = c("Tokyo","New York","London","Berlin"),
       ncol = 4,
       cex = 0.8,
       bty = "n",
       col = c("red","blue","green","orange"),
       lty = 1,
       lwd = 2)

# 12. 地图作图
##install.packages("maps")
library(maps)
map()
map('world', fill = TRUE, col = heat.colors(10))
## 美国各州地图
map("state", interior = FALSE)
map("state", boundary = FALSE, col="red", add = TRUE) 

# 13. 输出并保存图片文件
png("scatterplot.png")
plot(rnorm(1000))
dev.off()

png("scatterplot.png", height = 600, width = 600)
plot(rnorm(1000))
dev.off()

png("scatterplot.png", height = 4, width = 4, units = "in")
plot(rnorm(1000))
dev.off()

png("scatterplot.png",res = 600)
plot(rnorm(1000))
dev.off()

pdf("scatterplot.pdf")
plot(rnorm(1000))
dev.off()
