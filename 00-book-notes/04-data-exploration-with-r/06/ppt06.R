## 箱型图、热力图

# 1. 箱型图
air = read.csv("airpollution.csv")
boxplot(air, las = 1)
## 收窄箱体宽度
boxplot(air, boxwex = 0.2, las = 1)
par(las = 1)
## 指定箱体的宽度
boxplot(air,width = c(1,2))

# 2. 变量分组
metals = read.csv("metals.csv")
boxplot(Cu~Source, data = metals,
        main = "Summary of Copper (Cu) concentrations by Site")
boxplot(Cu~Source*Expt,data = metals,
        main = "Summary of Copper (Cu) concentrations by Site")

# 3. 根据观测值的数量决定箱体的宽度
metals = read.csv("metals.csv")
boxplot(Cu ~ Source, data = metals,
        varwidth = TRUE,
        main = "Summary of Copper concentrations by Site")

# 4. 创建带有槽口的箱型图
metals = read.csv("metals.csv")
boxplot(Cu ~ Source, data = metals,
        varwidth = TRUE,
        notch = TRUE,	
        main  = "Summary of Copper concentrations by Site")

# 5. 排除离群值(去野点)
metals = read.csv("metals.csv")
boxplot(metals[,-1], 
        outline = FALSE,
        main = "Summary of metal concentrations by Site \n (without outliers)")

# 6. 建立水平放置的箱型图
metals = read.csv("metals.csv")
boxplot(metals[,-1], 
        horizontal = TRUE,
        las  = 1,
        main = "Summary of metal concentrations by Site")

# 7. 改变箱型风格
metals = read.csv("metals.csv")
boxplot(metals[,-1],
        border = "white",
        col = "black",
        boxwex = 0.3,
        medlwd = 1,
        whiskcol = "black",
        staplecol = "black",
        outcol = "red",cex=0.3,outpch=19,
        main = "Summary of metal concentrations by Site")
grid(nx = NA,ny = NULL,col = "gray",lty = "dashed")

# 8. 延长箱型图的须线
metals = read.csv("metals.csv")
boxplot(metals[,-1],
        range = 1,
        border = "white",
        col = "black",
        boxwex = 0.3,
        medlwd = 1,
        whiskcol = "black",
        staplecol = "black",
        outcol = "red",
        cex = 0.3,
        outpch = 19,
        main = "Summary of metal concentrations by Site \n (range=1) ")
boxplot(metals[,-1],
        range = 0,
        border = "white",
        col = "black",
        boxwex = 0.3,
        medlwd = 1,
        whiskcol = "black",
        staplecol = "black",
        outcol = "red",
        cex = 0.3,
        outpch = 19,
        main = "Summary of metal concentrations by Site \n (range=0)")

# 9. 显示观测的数量
metals = read.csv("metals.csv")
b = boxplot(metals[,-1],
            xaxt="n",
            border = "white",
            col = "black",
            boxwex = 0.3,
            medlwd = 1,
            whiskcol = "black",
            staplecol = "black",
            outcol = "red",
            cex = 0.3,
            outpch = 19,
            main = "Summary of metal concentrations by Site")
axis(side = 1,at = 1:length(b$names),
     labels = paste(b$names,"\n(n=",b$n,")",sep=""),
     mgp = c(3,2,0))
## install.packages("gplots")
## 使用gplots包
library(gplots)
boxplot2( metals[,-1],
          border = "white",
          col = "black",
          boxwex = 0.3,
          medlwd = 1,
          whiskcol = "black",
          staplecol = "black",
          outcol = "red",
          cex = 0.3,
          outpch = 19,
          main = "Summary of metal concentrations by Site")

# 10. 将变量随机分成子集(分割数据)
metals = read.csv("metals.csv")
cuts = c(0,40,80)
Y = split(x = metals$Cu, f = findInterval(metals$Cu, cuts))
boxplot(Y,
        xaxt = "n",            
        border = "white",
        col = "black",
        boxwex = 0.3,
        medlwd = 1,           
        whiskcol = "black",
        staplecol = "black",
        outcol = "red",
        cex = 0.3,
        outpch = 19,
        main = "Summary of Copper concentrations",
        xlab = "Concentration ranges",
        las = 1)
axis(1, at = 1:4,
     labels = c("Below 0","0 to 40","40 to 80","Above 80"),      
     lwd = 0,lwd.ticks = 1,col = "gray")
## 函数化，将分割子集写成函数
boxplot.cuts = function(y, cuts) {
  Y = split(metals$Cu, f = findInterval(y, cuts))
  b = boxplot(Y,
              xaxt = "n",
              border = "white",
              col = "black",
              boxwex = 0.3,
              medlwd = 1,
              whiskcol = "black",
              staplecol = "black",
              outcol = "red",
              cex = 0.3,
              outpch = 19,
              main = "Summary of Copper concentrations",
              xlab = "Concentration ranges",
              las = 1)
  clabels = paste("Below",cuts[1])
  for(k in 1:(length(cuts)-1)) {
    clabels = c(clabels, 
                paste(as.character(cuts[k]),"to",as.character(cuts[k+1])))
  }
  clabels<-c(clabels, 
             paste("Above",as.character(cuts[length(cuts)])))
  axis(1,at = 1:length(clabels),
       labels = clabels,lwd = 0,
       lwd.ticks = 1,
       col = "gray")
}

boxplot.cuts(metals$Cu,c(0,30,60))
boxplot(Cu~Source,data = metals,subset = Cu > 40)

## boxplot.cuts()另一种函数形式
boxplot.cuts = function(y,cuts) {
  f = cut(y, c(min(y[!is.na(y)]),cuts,max(y[!is.na(y)])),
          ordered_results = TRUE);
  Y = split(y, f = f)
  b = boxplot(Y,
              xaxt = "n",
              border = "white",
              col = "black",
              boxwex = 0.3,
              medlwd = 1,
              whiskcol = "black",
              staplecol = "black",
              outcol = "red",
              cex = 0.3,
              outpch = 19,
              main = "Summary of Copper concentrations",
              xlab = "Concentration ranges",
              las  = 1)
  clabels = as.character(levels(f))
  axis(1,at = 1:length(clabels),
       labels = clabels,lwd = 0,
       lwd.ticks = 1,col = "gray")
}
boxplot.cuts(metals$Cu,c(0,40,80))

#==========================
#==========热力图==========
#==========================
# 1. 创建热力图
sales = read.csv("sales.csv")
## install.packages("RColorBrewer")
library(RColorBrewer)
rownames(sales) = sales[,1]
sales = sales[,-1]
data_matrix = data.matrix(sales)
pal = brewer.pal(7,"YlOrRd")
breaks = seq(3000,12000,1500)
## 改变版图的布局
layout(matrix(data = c(1,2), nrow = 1, ncol = 2),
       widths = c(8,1), heights = c(1,1))
## 设置热力图的边缘
par(mar = c(5,10,4,2),oma = c(0.2,0.2,0.2,0.2),
    mex = 0.5)
## 创建图片
image(x = 1:nrow(data_matrix),
      y = 1:ncol(data_matrix), 	
      z = data_matrix,
      axes = FALSE,
      xlab = "Month",
      ylab = "",
      col  = pal[1:(length(breaks)-1)], 
      breaks = breaks,
      main = "Sales Heat Map")
## 横轴的格式和标签
axis(1,at = 1:nrow(data_matrix),
     labels = rownames(data_matrix),
     col  = "white",
     las  = 1)
## 纵轴的格式和标签
axis(2,at = 1:ncol(data_matrix),
     labels = colnames(data_matrix),
     col  = "white",
     las  = 1)
abline(h = c(1:ncol(data_matrix))+0.5, 
       v = c(1:nrow(data_matrix))+0.5,
       col = "white",
       lwd = 2,
       xpd = FALSE)
breaks2 = breaks[-length(breaks)]
## 颜色范围
par(mar = c(5,1,4,7)) 
image(x = 1, 
      y = 0:length(breaks2),
      z = t(matrix(breaks2))*1.001,
      col  = pal[1:length(breaks)-1],
      axes = FALSE,
      breaks = breaks,
      xlab = "",
      ylab = "",
      xaxt = "n")
axis(4,
     at = 0:(length(breaks2)-1), 
     labels = breaks2,
     col = "white",
     las = 1)
abline(h = c(1:length(breaks2)),
       col = "white",
       lwd = 2,
       xpd = F)


# 2. 创建相关热力图
genes = read.csv("genes.csv")
rownames(genes) = genes[,1]
data_matrix = data.matrix(genes[,-1])
pal = heat.colors(5)
breaks = seq(0,1,0.2)
layout(matrix(data = c(1,2), nrow = 1, ncol = 2), 
       widths = c(8,1),
       heights = c(1,1))
par(mar = c(3,7,12,2),
    oma = c(0.2,0.2,0.2,0.2),
    mex = 0.5)
image(x = 1:nrow(data_matrix),
      y = 1:ncol(data_matrix),
      z = data_matrix,
      xlab = "",
      ylab = "",
      breaks = breaks,
      col  = pal,
      axes = FALSE)
## 加标注
text(x = 1:nrow(data_matrix)+0.75, 
     y = par("usr")[4] + 1.25, 
     srt = 45, adj = 1,
     labels = rownames(data_matrix), 
     xpd = TRUE)
axis(2, at = 1:ncol(data_matrix),
     labels = colnames(data_matrix),
     col = "white",
     las = 1)
abline(h = c(1:ncol(data_matrix))+0.5,
       v = c(1:nrow(data_matrix))+0.5,
       col = "white",
       lwd = 2,
       xpd = F)
title("Correlation between genes",
      line = 8,adj = 0)
breaks2 = breaks[-length(breaks)]

## 颜色范围
par(mar = c(25,1,25,7))
image(x = 1, 
      y = 0:length(breaks2),
      z = t(matrix(breaks2))*1.001,
      col = pal[1:length(breaks)-1],
      axes = FALSE,
      breaks = breaks,
      xlab = "",
      ylab = "",
      xaxt = "n")

axis(4,at=0:(length(breaks2)),labels=breaks,col="white",las=1)
abline(h=c(1:length(breaks2)),col="white",lwd=2,xpd=FALSE)


# 3. 展现多变量的数据
nba = read.csv("nba.csv")
library(RColorBrewer)
rownames(nba) = nba[,1]
data_matrix = t(scale(data.matrix(nba[,-1])))
pal = brewer.pal(6,"Blues")
statnames = c("Games Played", "Minutes Played",
              "Total Points", "Field Goals Made",
              "Field Goals Attempted",
              "Field Goal Percentage",
              "Free Throws Made",
              "Free Throws Attempted",
              "Free Throw Percentage",
              "Three Pointers Made",
              "Three Pointers Attempted",
              "Three Point Percentage",
              "Offensive Rebounds",
              "Defensive Rebounds",
              "Total Rebounds","Assists",
              "Steals","Blocks",
              "Turnovers", "Fouls")
par(mar = c(3,14,19,2),
    oma = c(0.2,0.2,0.2,0.2),
    mex = 0.5)

## 热力图      
image(x = 1:nrow(data_matrix),
      y = 1:ncol(data_matrix),
      z = data_matrix,
      xlab = "",
      ylab = "",
      col  = pal,
      axes = FALSE)
## X轴标签
text(1:nrow(data_matrix),
     par("usr")[4] + 1, 
     srt = 45, adj = 0, 
     labels = statnames,
     xpd = TRUE,
     cex = 0.85)
## Y轴标签
axis(side = 2,
     at   = 1:ncol(data_matrix),
     labels = colnames(data_matrix),
     col  = "white",
     las  = 1, 
     cex.axis = 0.85)
## 白色分割线
abline(h = c(1:ncol(data_matrix))+0.5,
       v = c(1:nrow(data_matrix))+0.5,
       col = "white",
       lwd = 1,
       xpd = F)
## 图的标题
text(par("usr")[1]+5,
     par("usr")[4] + 12,
     "NBA per game performance of top 50corers", 
     xpd = TRUE,
     font = 2,
     cex = 1.5)
