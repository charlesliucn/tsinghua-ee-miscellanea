## R语言柱形图

# 1. 柱形图
## install.packages("RColorBrewer")
library(RColorBrewer) 
citysales = read.csv("citysales.csv")
barplot(as.matrix(citysales[,2:4]), 
        beside = TRUE,
        legend.text = citysales$City,
        args.legend = list(bty = "n",horiz = TRUE),
        col = brewer.pal(5, "Set1"),
        border = "white",
        ylim = c(0,100),
        ylab = "Sales Revenue (1,000's of USD)",
        main = "Sales Figures")
box(bty = "l")

# 2. 堆叠效果的柱形图
## install.packages("RColorBrewer")
library(RColorBrewer)
citysales = read.csv("citysales.csv")
barplot(as.matrix(citysales[,2:4]),  
        legend.text = citysales$City,
        args.legend = list(bty = "n",horiz = TRUE),
        col = brewer.pal(5,"Set1"),
        border = "white",
        ylim = c(0,200),
        ylab = "Sales Revenue (1,000's of USD)",
        main = "Sales Figures")
## 用堆叠效果表示百分比
citysalesperc = read.csv("citysalesperc.csv") 
par(mar = c(5,4,4,8),xpd = T)
barplot(as.matrix(citysalesperc[,2:4]), 
        col    = brewer.pal(5,"Set1"),
        border = "white",
        ylab   = "Sales Revenue (1,000's of USD)", 
        main   = "Percentage Sales Figures") 
legend("right",legend = citysalesperc$City,
       bty = "n",inset = c(-0.3,0),
       fill = brewer.pal(5,"Set1"))

# 3. 水平方向的柱形图
barplot(as.matrix(citysales[,2:4]), 
        beside = TRUE, horiz = TRUE,
        legend.text = citysales$City,
        args.legend = list(bty = "n"),
        col    = brewer.pal(5,"Set1"),
        border = "white",
        xlim   = c(0,100),
        xlab   = "Sales Revenue (1,000's of USD)",
        main   = "Sales Figures")
par(mar = c(5,4,4,8), xpd = T)
## 展示百分比的堆叠水平方向柱形图
barplot(as.matrix(citysalesperc[,2:4]),
        horiz = TRUE,
        col   = brewer.pal(5,"Set1"),
        border= "white",
        xlab  = "Percentage of Sales",
        main  = "Perecentage Sales Figures")
legend("right",legend = citysalesperc$City,bty="n",
       inset  = c(-0.3,0), fill = brewer.pal(5,"Set1"))

# 4. 调整柱形图的宽度间隔和颜色
barplot(as.matrix(citysales[,2:4]), 
        beside = TRUE,
        legend.text = citysales$City,
        args.legend = list(bty = "n",horiz = T),
        col   = c("#E5562A","#491A5B","#8C6CA8","#BD1B8A","#7CB6E4"),
        border= FALSE,
        space = c(0,5),
        ylim  = c(0,100),
        ylab  = "Sales Revenue (1,000's of USD)",
        main  = "Sales Figures")
barplot(as.matrix(citysales[,2:4]),
        beside = TRUE,
        legend.text = citysales$City,
        args.legend = list(bty = "n",horiz = T),
        ylim = c(0,100),
        ylab = "Sales Revenue (1,000's of USD)",
        main = "Sales Figures")

# 5. 在柱子顶端显示数据
x = barplot(as.matrix(citysales[,2:4]),
            beside = TRUE,
            legend.text = citysales$City,
            args.legend = list(bty = "n",horiz = TRUE),
            col = brewer.pal(5,"Set1"),
            border = "white",
            ylim = c(0,100),
            ylab = "Sales Revenue (1,000's of USD)",
            main = "Sales Figures")
y = as.matrix(citysales[,2:4])
text(x, y+2, labels = as.character(y))

## 水平柱子旁标注数据
y = barplot(as.matrix(citysales[,2:4]),
            beside = TRUE,
            horiz = TRUE,
            legend.text = citysales$City,
            args.legend = list(bty = "n"),
            col = brewer.pal(5,"Set1"),
            border = "white",
            xlim = c(0,100),
            xlab = "Sales Revenue (1,000's of USD)",
            main = "Sales Figures")
x = as.matrix(citysales[,2:4])
text(x+2,y,labels = as.character(x))

# 6. 在柱子里面进行标注
rain = read.csv("cityrain.csv")
y = barplot(as.matrix(rain[1,-1]),
            horiz = TRUE,
            col  = "white",
            yaxt = "n",
            main = "Monthly Rainfall in Major CitiesJanuary",
            xlab = "Rainfall (mm)")
x = 0.5*rain[1,-1] 
text(x,y,colnames(rain[-1]))

# 7. 垂直标注误差
sales = t(as.matrix(citysales[,-1]))
colnames(sales) = citysales[,1]
x = barplot(sales,
            beside = TRUE,
            legend.text = rownames(sales),
            args.legend = list(bty = "n",horiz = T),
            col = brewer.pal(3,"Set2"),
            border = "white",
            ylim = c(0,100),
            ylab = "Sales Revenue (1,000's of USD)",
            main = "Sales Figures")
arrows(x0 = x,
       y0 = sales*0.95,
       x1 = x,
       y1 = sales*1.05,
       angle = 90,
       code  = 3,
       length= 0.04,
       lwd   = 0.4)
## 使用函数，方便调用标注误差的函数
errorbars = function(x,y,upper,lower = upper,length = 0.04,lwd = 0.4,...) {
  arrows(x0 = x,
         y0 = y+upper,
         x1 = x,
         y1 = y - lower,
         angle = 90,
         code  = 3,
         length= length,
         lwd   = lwd)
}
errorbars(x, sales, 0.05*sales) 


# 8. 使用变量分类修改点图
## install.packages("reshape")
library(reshape)
sales = melt(citysales)
sales$color[sales[,2]=="ProductA"] =  "red"
sales$color[sales[,2]=="ProductB"] =  "blue"
sales$color[sales[,2]=="ProductC"] =  "violet"
dotchart(sales[,3],
         labels = sales$City,
         groups = sales[,2],
         col    = sales$color,
         pch    = 19,
         main   = "Sales Figures",
         xlab   = "Sales Revenue (1,000's of USD)")

# 9. 画饼图
browsers = read.table("browsers.txt", header = TRUE)
browsers = browsers[order(browsers[,2]),]
pie(browsers[,2],
    labels    = browsers[,1],
    clockwise = TRUE,
    radius    = 1,
    col       = brewer.pal(7,"Set1"),
    border    = "white",
    main      = "Percentage Share of Internet Browser usage")


# 10. 在饼图上标注百分比
browsers = read.table("browsers.txt",header = TRUE)
browsers = browsers[order(browsers[,2]),]
pielabels = sprintf("%s = %3.1f%s", browsers[,1],
                    100*browsers[,2]/sum(browsers[,2]), "%")
pie(browsers[,2],
    labels = NA,
    #labels = pielabels,
    clockwise = TRUE,
    radius = 1,
    col    = brewer.pal(7,"Set1"),
    border = "white",
    cex    = 0.8,
    main   = "Percentage Share of Internet Browser usage")

# 11. 饼图上增加图例
legend("bottomright",
       legend = pielabels,
       bty = "n",
       fill = brewer.pal(7,"Set1"))


# 12. 频率分布直方图
air = read.csv("airpollution.csv")
hist(air$Nitrogen.Oxides,
     xlab = "Nitrogen Oxide Concentrations",
     main = "Distribution of Nitrogen Oxide Concentrations")
## 以概率密度显示
hist(air$Nitrogen.Oxides,
     freq = FALSE,
     xlab = "Nitrogen Oxide Concentrations",
     main = "Distribution of Nitrogen Oxide Concentrations")

# 13. 增加breaks
air = read.csv("airpollution.csv")
hist(air$Nitrogen.Oxides,
     breaks = 20,
     xlab = "Nitrogen Oxide Concentrations",
     main = "Distribution of Nitrogen Oxide Concentrations")
hist(air$Nitrogen.Oxides,
     breaks = c(0,100,200,300,400,500,600),
     xlab = "Nitrogen Oxide Concentrations",
     main = "Distribution of Nitrogen Oxide Concentrations")

# 14. 用颜色美化、边界设置
air = read.csv("airpollution.csv")
hist(air$Respirable.Particles,
     prob = TRUE,
     col  = "black",
     border = "white",
     xlab = "Respirable Particle Concentrations",
     main = "Distribution of Respirable Particle Concentrations")
## 用线条美化
par(yaxs = "i",las = 1)
hist(air$Respirable.Particles,
     prob = TRUE,	
     col  = "black",
     border = "white",
     xlab = "Respirable Particle Concentrations",
     main = "Distribution of Respirable Particle Concentrations")
box(bty = "l")
grid(nx  = NA, ny = NULL,
     lty = 1, lwd = 1, col = "gray")

# 15. 标识密度函数
par(yaxs = "i",las = 1)
hist(air$Respirable.Particles,
     prob = TRUE,
     col  = "black",
     border = "white",
     xlab = "Respirable Particle Concentrations",
     main = "Distribution of Respirable Particle Concentrations")
box(bty = "l")
lines(density(air$Respirable.Particles,na.rm = T),
      col = "red",lwd = 4)
grid(nx = NA,ny = NULL,lty = 1,lwd = 1,col = "gray")

# 16. 一组直方图
panel.hist <- function(x, ...)
{
  par(usr = c(par("usr")[1:2], 0, 1.5))
  hist(x, prob = TRUE,
       add = TRUE,
       col = "black",
       border = "white")
}
plot(iris[,1:4],
     main = "Relationships between characteristics of iris flowers",
     pch  = 19,
     col  = "blue",
     cex  = 0.9,
     diag.panel = panel.hist)

# 17. 散点图加直方图
## 直方图在散点图的坐标对应处
air = read.csv("airpollution.csv")
## 设置
layout(matrix(c(2,0,1,3),2,2,byrow = TRUE), 
       widths = c(3,1), heights = c(1,3), TRUE)
# 画点图
par(mar=c(5.1,4.1,0.1,0))
plot(air$Respirable.Particles~air$Nitrogen.Oxides,
     pch  = 19,col = "black",
     xlim = c(0,600),ylim = c(0,80),
     xlab = "Nitrogen Oxides Concentrations",
     ylab = "Respirable Particle Concentrations")
# X变量的频率直方图
par(mar = c(0,4.1,3,0))
hist(air$Nitrogen.Oxides,
     breaks = seq(0,600,100),
     ann  = FALSE,
     axes = FALSE,
     col  = "black",
     border="white")
# Y变量的频率直方图
yhist = hist(air$Respirable.Particles,
             breaks = seq(0,80,10),
             plot = FALSE)
par(mar = c(5.1,0,0.1,1))
barplot(yhist$density,
        horiz = TRUE,
        space = 0,
        axes  = FALSE,
        col   = "black",
        border= "white")
