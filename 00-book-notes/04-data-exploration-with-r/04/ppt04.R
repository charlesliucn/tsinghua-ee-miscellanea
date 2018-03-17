# 1. 作出线图，并添加legend图例
rain = read.csv("cityrain.csv")
plot(rain$Tokyo,
     type = "b",
     lwd  = 2,
     xaxt = "n",
     ylim = c(0,300),
     col  = "black",
     xlab = "Month",
     ylab = "Rainfall (mm)",
     main = "Monthly Rainfall in major cities")
## 改变坐标轴
axis(1, at = 1:length(rain$Month),labels = rain$Month)
lines(rain$Berlin, col = "red",   type = "b", lwd = 2)
lines(rain$NewYork,col = "orange",type = "b", lwd = 2)
lines(rain$London, col = "purple",type = "b", lwd = 2)
## 增加图例
### 图例1
legend("topright", legend = c("Tokyo","Berlin","New York","London"),
       lty = 1,lwd = 2,pch = 21,
       col = c("black","red","orange","purple"),
       ncol= 2, bty = "n", cex = 0.8,
       text.col = c("black","red","orange","purple"),
       inset = 0.01)
### 图例2
legend(1,300,legend = c("Tokyo","Berlin","New York","London"),
       lty = 1,lwd = 2,pch = 21,
       col = c("black","red","orange","purple"),
       horiz = TRUE,bty = "n",bg = "yellow",cex = 1,
       text.col=c("black","red","orange","purple"))


# 2.用线图画出时间序列

gdp = read.table("gdp_long.txt", header = T)
library(RColorBrewer)
pal = brewer.pal(5,"Set1")
par(mar = par()$mar + c(0,0,0,2),bty = "l")
plot(Canada~Year,
     data= gdp,
     type= "l",
     lwd = 2,
     lty = 1,
     ylim= c(30,60),
     col = pal[1],
     main= "Percentage change in GDP",
     ylab= "") 
mtext(side = 4, at = gdp$Canada[length(gdp$Canada)],
      text = "Canada", col = pal[1],
      line = 0.3, las = 2)
## 增加法国
lines(gdp$France~gdp$Year, col = pal[2],lwd = 2)
mtext(side = 4, at = gdp$France[length(gdp$France)],
      text = "France", col = pal[2],
      line = 0.3, las = 2)
## 增加德国
lines(gdp$Germany~gdp$Year,col = pal[3],lwd = 2)
mtext(side = 4, at = gdp$Germany[length(gdp$Germany)],
      text = "Germany",col = pal[3],
      line = 0.3, las = 2)
## 增加英国
lines(gdp$Britain~gdp$Year,col = pal[4],lwd = 2)
mtext(side = 4, at = gdp$Britain[length(gdp$Britain)],
      text = "Britain",col = pal[4],
      line = 0.3, las = 2)
## 增加美国
lines(gdp$USA~gdp$Year,col = pal[5],lwd = 2)
mtext(side = 4, at = gdp$USA[length(gdp$USA)]-2,
      text = "USA",col = pal[5],
      line = 0.3, las = 2)


# 3. 画出底纹的格子
rain = read.csv("cityrain.csv")
plot(rain$Tokyo,
     type = "b",
     lwd  = 2,
     xaxt = "n",
     ylim = c(0,300),
     col  = "black",
     xlab = "Month",
     ylab = "Rainfall (mm)",
     main = "Monthly Rainfall in Tokyo")
axis(1, at = 1:length(rain$Month),
     labels = rain$Month)
grid() # 增加x和y方向的底纹
## x方向无底纹，y方向有8条，颜色为蓝色(水平线底纹)
grid(nx = NA, ny = 8,
     lwd = 1, lty = 2, col = "blue")
## 增加垂直线
rain = read.csv("cityrain.csv")
plot(rain$Tokyo,
     type = "b",
     lwd  = 2,
     xaxt = "n",
     ylim = c(0,300),
     col  = "black", 
     xlab = "Month",
     ylab = "Rainfall (mm)",
     main = "Monthly Rainfall in Tokyo")
axis(1,at = 1:length(rain$Month),labels = rain$Month)
abline(v = 9) # 增加垂直线
abline(h = 150,col = "red",lty = 2) # 增加水平线

# 5. 增加Sparkline
rain = read.csv("cityrain.csv")
par(mfrow= c(4,1),
    mar  = c(5,7,4,2),
    omi  = c(0.2,2,0.2,2)) 
for(i in 2:5) {
  plot(rain[,i],ann = FALSE, axes = FALSE,
       type = "l",col = "gray",lwd = 2) 
  mtext(side = 2,at  = mean(rain[,i]), names(rain[i]),
        las  = 2,col = "black")
  mtext(side = 4,at = mean(rain[,i]),mean(rain[i]),
        las  = 2,col= "black")
  points(which.min(rain[,i]),min(rain[,i]),pch = 19,col = "blue")
  points(which.max(rain[,i]),max(rain[,i]),pch = 19,col = "red")
}

# 6. 画出时间序列图
par(mfrow= c(1,1))
rain = read.csv("cityrain.csv")
plot(rain$Berlin - rain$London,
     type = "l",lwd = 2, 
     xaxt = "n",col = "blue",
     xlab = "Month",ylab = "Difference in Rainfall (mm)",
     main = "Difference in Rainfall between Berlin and London (Berlin-London)")
axis(1,at = 1:length(rain$Month),labels = rain$Month)
abline(h = 0,col = "red")
## 画出二次函数图像
x = 1:100
y = x^3-6*x^2+5*x+10
plot(y~x,type = "l",
     main = expression(f(x)==x^3-6*x^2+5*x+10))


# 7. 时间序列图
sales = read.csv("dailysales.csv")
d1 = as.Date(sales$date,"%d/%m/%y")
d2 =strptime(sales$date,"%d/%m/%Y")
## install.packages(zoo)
library(zoo) 
d3 = zoo(sales$units, as.Date(sales$date,"%d/%m/%y"))
plot(d3)

# 8. 作出时间序列图
sales = read.csv("dailysales.csv")
plot(sales$units~as.Date(sales$date,"%d/%m/%y"),
     type = "l", xlab = "Date",ylab = "Units Sold")
plot(strptime(sales$date,"%d/%m/%Y"),sales$units,
     type = "l", xlab = "Date",ylab = "Units Sold")
library(zoo)
plot(zoo(sales$units,as.Date(sales$date,"%d/%m/%y")))

## 数据较多的例子
air = read.csv("openair.csv")
plot(air$nox~as.Date(air$date,"%d/%m/%Y %H:%M"),
     type = "l", xlab = "Time", ylab = "Concentration (ppb)",
     main = "Time trend of Oxides of Nitrogen")
plot(zoo(air$nox,as.Date(air$date,"%d/%m/%Y %H:%M")),
     xlab = "Time", ylab = "Concentration (ppb)",
     main = "Time trend of Oxides of Nitrogen")


# 9. 时间刻度可读化
air = read.csv("openair.csv")
plot(air$nox~as.Date(air$date,"%d/%m/%Y %H:%M"),
     type = "l",xaxt = "n",
     xlab = "Time", ylab="Concentration (ppb)",
     main = "Time trend of Oxides of Nitrogen")
xlabels = strptime(air$date, format = "%d/%m/%Y %H:%M")
axis.Date(1, at = xlabels[xlabels$mday == 1],
          format = "%b-%Y")


# 10. 用垂直标线标定特定的时间事件
air = read.csv("openair.csv")
plot(air$nox~as.Date(air$date,"%d/%m/%Y %H:%M"),
     type = "l", xlab = "Time",
     ylab = "Concentration (ppb)",
     main = "Time trend of Oxides of Nitrogen")
abline(v = as.Date("25/12/2003","%d/%m/%Y"), col = "red")
markers = seq(from = as.Date("25/12/1998","%d/%m/%Y"),
              to   = as.Date("25/12/2004","%d/%m/%Y"),
              by   = "year")
abline(v = markers,col = "red")

# 11. 求出均值后画时间序列
air = read.csv("openair.csv")
air$date = as.POSIXct(strptime(air$date, format = "%d/%m/%Y %H:%M", "GMT"))
means = aggregate(air["nox"], format(air["date"],"%Y -%U"), mean, na.rm = TRUE)
means$date = seq(air$date[1], air$date[nrow(air)],length = nrow(means))
plot(means$date, means$nox, type = "l")

means = aggregate(air["nox"], format(air["date"],"%Y-%j"), mean, na.rm = TRUE)
means$date <- seq(air$date[1], air$date[nrow(air)],length = nrow(means))
plot(means$date, means$nox, type = "l",
     xlab = "Time", ylab = "Concentration (ppb)",
     main = "Daily  Average Concentrations of Oxides of Nitrogen")


# 12. 画出股票数据
## install.packages("tseries")
library(tseries)
## 抓取股票数据
aapl = get.hist.quote(instrument = "aapl", 
                      quote = c("Cl", "Vol"))
goog = get.hist.quote(instrument = "goog", 
                      quote = c("Cl", "Vol"))
msft = get.hist.quote(instrument = "msft", 
                      quote = c("Cl", "Vol"))
## 画出趋势图
plot(msft$Close, main = "Stock Price Comparison",
     ylim = c(0,800),col = "red",type = "l",lwd = 0.5,
     pch  = 19, cex = 0.6, xlab = "Date",
     ylab = "Stock Price (USD)")
lines(goog$Close, col = "blue", lwd = 0.5)
lines(aapl$Close, col = "gray", lwd = 0.5)
## 增加图例
legend("top", horiz = T, 
       legend = c("Microsoft","Google","Apple"),
       col = c("red","blue","gray"),
       lty = 1, bty = "n")

## 使用quantmod包的功能画图
## install.packages("quantmod")
library(quantmod)
getSymbols("AAPL", src = "yahoo") 
barChart(AAPL)
## 蜡烛图
candleChart(AAPL,theme = "white") 