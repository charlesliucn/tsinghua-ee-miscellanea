# 1. Daily Sales Trends
dailysales = read.csv("dailysales.csv")
par(mar = c(5,5,12,2))
plot(units~as.Date(date,"%d/%m/%y"),
     data = dailysales,
     type = "l",
     las  = 1,
     ylab = "Units Sold",
     xlab = "Date")
desc = "The graph below shows sales data for
Product A in the month of January 2010. 
There were a lot of ups and downs in the
number of units sold. The average number
of units sold was around 5000. The highest
sales were recorded on the 27th January, 
nearly 7000 units sold."
mtext(paste(strwrap(desc,width=80),collapse="\n"),
      side = 3,
      line = 3,
      padj = 0,
      adj  = 0)
title("Daily Sales Trends",
      line = 10,
      adj  = 0,
      font = 2)


# 2. ps或者pdf选择字体
pdf("fonts.pdf",family = "AvantGarde")
plot(rnorm(100), main = "Random Normal Distribution")
dev.off()

postscript("fonts.ps",family = "AvantGarde")
plot(rnorm(100),main = "Random Normal Distribution")
dev.off()
names(pdfFonts())

# 3. 世界地图上按照国家画出数据
## install.packages("maps")
## install.packages("WDI")
## install.packages("RColorBrewer")
library(maps)
library(WDI)
library(RColorBrewer)
colors = brewer.pal(7,"PuRd")
wgdp = WDIsearch("gdp")
w = WDI(country = "all", indicator = wgdp[4,1],
        start = 2005, end = 2005)

# 4. 日历图画出图
## install.packages("openair")
library(openair)
## calendarPlot(mydata)

