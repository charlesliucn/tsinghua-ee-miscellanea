# 数据展现，制图的各种参数

# 1. 设置图形要素颜色
plot(rnorm(1000), col = "red")
sales = read.csv("dailysales.csv", header = TRUE)
plot(sales$units~as.Date(sales$date,"%d/%m/%y"),
     type = "l",
     col  = "blue")
## 颜色的表达
colors()       # 可使用颜色名的所有颜色
heat.colors(5) # 热力图颜色表示
## 使用直观的调色板控制包RColorBrewer
## install.packages("RColorBrewer")
library(RColorBrewer)
display.brewer.all()
brewer.pal(7, "YlOrRd")
display.brewer.pal(7, "YlOrRd")
palette() # 调色板颜色
plot(rnorm(1000), col = "#AC5500BB") # 十六进制表示的颜色

sales = read.csv("citysales.csv", header = TRUE)
barplot(as.matrix(sales[,2:4]), beside = T,
        legend = sales$City,
        col    = c("red","blue","green","orange","pink"),
        border = "white")
barplot(as.matrix(sales[,2:4]), beside = T,
        legend = sales$City,
        col    = c("red","blue","green","orange"),
        border = "white")
## heat.colors()
barplot(as.matrix(sales[,2:4]), beside = T,
        legend = sales$City,
        col    = heat.colors(length(sales$City)),
        border = "white")
## rainbow()
barplot(as.matrix(sales[,2:4]), beside = T,
        legend = sales$City,
        col    = rainbow(length(sales$City)),
        border = "white")
## terrain.colors()
barplot(as.matrix(sales[,2:4]), beside = T,
        legend = sales$City,
        col    = terrain.colors(length(sales$City)),
        border = "white")
## cm.colors()
barplot(as.matrix(sales[,2:4]), beside = T,
        legend = sales$City,
        col    = cm.colors(length(sales$City)),
        border = "white")
## topo.colors()
barplot(as.matrix(sales[,2:4]), beside = T,
        legend = sales$City,
        col    = topo.colors(length(sales$City)),
        border = "white")

# 2. 设置坐标系的背景颜色
par(bg = "gray")
plot(rnorm(100))
plot(rnorm(1000),type = "n")
x = par("usr")
rect(x[1],x[3],x[2],x[4],col = "lightgray")
points(rnorm(1000))


# 3. 设置标题、坐标轴标号颜色
par(bg = "white")
plot(rnorm(100), 
     main = "Plot Title",
     col.axis = "blue",
     col.lab  = "red",
     col.main = "darkblue")
## 统一进行设置
## par()的作用直至下一条par()设置命令
## 或者重新开一个图形设备
par(col.axis = "black",
    col.lab  = "#444444",
    col.main = "darkblue")
plot(rnorm(100),main = "plot")
title("Sales Figures for 2010", col.main = "blue")
title(xlab = "Month",ylab = "Sales",col.lab = "red")
title(xlab = "X axis",col.lab = "red")
title(ylab = "Y axis",col.lab = "blue")

# 5. 字体设置
par(family = "serif",font = 2)
names(pdfFonts())

# 6. 设置散点的样式
rain = read.csv("cityrain.csv")
plot(rnorm(100),pch = 19,cex = 2)
plot(rain$Tokyo,
     ylim = c(0,250),
     main = "Monthly Rainfall in major cities",
     xlab = "Month of Year",
     ylab = "Rainfall (mm)",
     pch  = 1)
points(rain$NewYork,pch = 2)
points(rain$London, pch = 3)
points(rain$Berlin, pch = 4)
legend("top",
       legend = c("Tokyo","New York","London","Berlin"),
       ncol = 4,
       cex  = 0.8,
       bty  = "n",
       pch  = 1:4)

# 7. 设置线形与宽度
rain = read.csv("cityrain.csv")
plot(rain$Tokyo,
     ylim = c(0,250),
     main = "Monthly Rainfall in major cities",
     xlab = "Month of Year",
     ylab = "Rainfall (mm)",
     type = "l",
     lty  = 1,
     lwd  = 2)
lines(rain$NewYork,lty = 2,lwd = 2) 
lines(rain$London, lty = 3,lwd = 2)
lines(rain$Berlin, lty = 4,lwd = 2)
legend("top",
       legend = c("Tokyo","New York","London","Berlin"),
       ncol = 4,
       cex  = 0.8,
       bty  = "n",
       lty  = 1:4,
       lwd  = 2)

# 8. 设置参数控制坐标系的风格
par(bty = "l")
plot(rnorm(100))
par(bty = "7")
plot(rnorm(100))
par(bty = "c")
plot(rnorm(100))
par(bty = "u")
plot(rnorm(100))
## box函数
par(oma = c(1,1,1,1))
plot(rnorm(100),bty = "l")
box(which = "figure")

# 9. 设置坐标轴刻度
plot(rnorm(100),xaxp = c(0,100,10))

# 10. las设置刻度数字的方向
par(las = 3)
plot(rnorm(100),xaxp = c(0,100,10))
par(las = 2)
plot(rnorm(100),xaxp = c(0,100,10))
par(las = 1)
plot(rnorm(100),xaxp = c(0,100,10))

# 11. 设置画图区域大小及控制边缘
par(fin = c(5,5),
    pin = c(3,3))
par(mai = c(1,1,1,1), 
    omi = c(0.1,0.1,0.1,0.1))
plot(rnorm(100),xaxp = c(0,100,10))


