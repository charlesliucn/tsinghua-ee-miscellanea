# 1. 使用chron包日历形式，展示时间序列数据
## install.packages("chron")
library("chron")
source("calendarHeat.R")
stock.data = read.csv("google.csv")
calendarHeat(dates = stock.data$Date, 
             values = stock.data$Adj.Close, 
             varname = "Google Adjusted Close")

# 2. 等高线图
contour(x = 10*1:nrow(volcano),
        y = 10*1:ncol(volcano),
        z = volcano,
        xlab = "Metres West",
        ylab = "Metres North", 
        main = "Topography of Maunga Whau Volcano")
## 润色等高线图
par(las = 1)
plot(0, 0,
     xlim = c(0,10*nrow(volcano)),
     ylim = c(0,10*ncol(volcano)),
     type = "n",
     xlab = "Metres West",
     ylab = "Metres North",
     main = "Topography of Maunga Whau Volcano")
u = par("usr")
rect(u[1],u[3],u[2],u[4],
     col = "lightgreen")
contour(x = 10*1:nrow(volcano),
        y = 10*1:ncol(volcano),
        z = volcano,
        col = "red",
        add = TRUE)

# 3. 创建填充颜色的等高图
filled.contour(x = 10*1:nrow(volcano), 
               y = 10*1:ncol(volcano), 
               z = volcano, color.palette = terrain.colors, 
               plot.title = title(main = "The Topography of Maunga Whau",
                                  xlab = "Meters North", 
                                  ylab = "Meters West"),
               plot.axes = {
                 axis(1, seq(100, 800, by = 100))
                 axis(2, seq(100, 600, by = 100))
               },
               key.title = title(main="Height\n(meters)"),
               key.axes = axis(4, seq(90, 190, by = 10))) 

# 4. 改善颜色过渡时的光滑程度
filled.contour(x = 10*1:nrow(volcano), 
               y = 10*1:ncol(volcano), 
               z = volcano, color.palette = terrain.colors, 
               plot.title = title(main = "The Topography of Maunga Whau",
                                  xlab = "Meters North", 
                                  ylab = "Meters West"),
               nlevels = 100, # nlevels表示平滑程度
               plot.axes = {
                 axis(1, seq(100, 800, by = 100))
                 axis(2, seq(100, 600, by = 100))
               },
               key.title = title(main="Height\n(meters)"),
               key.axes = axis(4, seq(90, 190, by = 10))) 

# 5. 使用rgl包制作三维曲面图
## install.packages("rgl")
library(rgl)
z = 2 * volcano
x = 10 * (1:nrow(z))
y = 10 * (1:ncol(z))
zlim = range(z)
zlen = zlim[2] - zlim[1] + 1
colorlut = terrain.colors(zlen) 
col = colorlut[z - zlim[1] + 1] 
rgl.open()
rgl.surface(x, y, z,
            color = col, back="lines")

# 6. 利用maps包画出地图
library(maps)
library(RColorBrewer)
x = map("state",plot = FALSE)
for(i in 1:length(rownames(USArrests))) {
  for(j in 1:length(x$names)) {
    if(grepl(rownames(USArrests)[i],x$names[j],ignore.case=T))
      x$measure[j] = as.double(USArrests$Murder[i])
  }
}
colours = brewer.pal(7,"Reds")
sd = data.frame(col=colours,
                values = seq(min(x$measure[!is.na(x$measure)]),
                             max(x$measure[!is.na(x$measure)])*1.0001, 
                             length.out = 7)
                )
breaks = sd$values
matchcol = function(y) {
  as.character(sd$col[findInterval(y,sd$values)])
}
layout(matrix(data = c(2,1), nrow = 1, ncol = 2), 
       widths = c(8,1), heights = c(8,1))
## 设定颜色范围
par(mar = c(20,1,20,7),
    oma = c(0.2,0.2,0.2,0.2),
    mex = 0.5)           
image(x = 1,
      y = 0:length(breaks),
      z = t(matrix(breaks))*1.001,
      col = colours[1:length(breaks)-1],
      axes = FALSE,
      breaks = breaks,
      xlab = "",
      ylab = "",
      xaxt = "n")
axis(4,at = 0:(length(breaks)-1),
     labels = round(breaks),
     col = "white",las = 1)
abline(h = c(1:length(breaks)),
       col = "white",
       lwd = 2,
       xpd = F)
## 作出地图(每个州的谋杀率)
map("state", boundary = FALSE, 
    col = matchcol(x$measure), 
    fill = TRUE,
    lty  = "blank")
map("state", col = "white",
    add = TRUE)
title("Murder Rates by US State in 1973 \n (arrests per 100,000 residents)", line=2)


# 7. 地图部分举例
library(maps)
library(RColorBrewer)
map("county", "new york")
map("state", region = c("california", "oregon", "nevada"))
map('italy', fill = TRUE, 
    col = brewer.pal(7,"Set1"))

# 8. 使用sp包画降雨量分布图
## install.packages("sp")
library(sp)
gadm = readRDS("FRA_adm1.rds")
gadm$rainfall = rnorm(length(gadm$NAME_1),
                      mean = 50,
                      sd = 15)
spplot(gadm, "rainfall",
       col.regions = rev(terrain.colors(gadm$rainfall)),
       main = "Rainfall (simulated) in French administrative regions")

# 9. 使用google地图包
## install.packages("rgdal")
## install.packages("RgoogleMaps")
library(rgdal)
library(RgoogleMaps)
air = read.csv("londonair.csv")
london = GetMap(center = c(51.51,-0.116), 
                zoom = 10,
                destfile = "London.png", 
                maptype = "mobile")
PlotOnStaticMap(london,
                lat = air$lat, 
                lon = air$lon, 
                cex = 2, 
                pch = 19,
                col = as.character(air$color))
## 卫星地图
london = GetMap(center = c(51.51,-0.116),
               zoom = 10, 
               destfile = "London_satellite.png", 
               maptype = "satellite")
PlotOnStaticMap(london,
                lat = air$lat,
                lon = air$lon,
                cex = 2,
                pch = 19,
                col = as.character(air$color))
## 把地图直接输出到图像文件
GetMap(center = c(40.714728,-73.99867), zoom =14, 
       destfile = "Manhattan.png", maptype = "hybrid")

# 10. 读取KML数据
## install.packages("rgdal")
library(rgdal)
cities = readOGR(system.file("vectors", package = "rgdal")[1], "cities")
writeOGR(cities, "cities.kml", "cities", driver = "KML")
df = readOGR("cities.kml", "cities")
df


# 11. ESRI形状文件
## install.packages("maptools")
library(maptools)
sfdata = readShapeSpatial(system.file("shapes/sids.shp", package="maptools")[1], 
                          proj4string = CRS("+proj=longlat"))
plot(sfdata, col = "orange", border = "white", axes = TRUE)
## 输出为shapefile文件
writeSpatialShape(sfdata, "xxpoly")


# 12. shapefiles包
##install.packages("shapefiles")
library(shapefiles)
sf = system.file("shapes/sids.shp", package = "maptools")[1]
sf = substr(sf,1,nchar(sf)-4)
sfdata = read.shapefile(sf)
write.shapefile(sfdata, "newsf")


# 13. 输出图像的一般方法
png("cars.png",res = 200,height = 600,width = 600)
plot(cars$dist~cars$speed,
     main = "Relationship between car distance and speed",
     xlab = "Speed (miles per hour)",
     ylab = "Distance travelled (miles)",
     xlim = c(0,30),
     ylim = c(0,140),
     xaxs = "i",
     yaxs = "i",
     col  = "red",
     pch  = 19)
dev.off()

# 14. 提高图像的精度
png("cars.png",res = 200,
    height = 600,width = 600)
par(mar = c(4,4,3,1),
    omi = c(0.1,0.1,0.1,0.1),
    mgp = c(3,0.5,0),
    las = 1,mex=0.5,
    cex.main = 0.6,
    cex.lab  = 0.5,
    cex.axis = 0.5)
plot(cars$dist ~ cars$speed,
     main = "Relationship between car distance and speed",
     xlab = "Speed (miles per hour)",
     ylab = "Distance travelled (miles)",
     xlim = c(0,30),
     ylim = c(0,140),
     xaxs = "i",
     yaxs = "i",
     col  = "red",
     pch  = 19,
     cex  = 0.5)
dev.off()

# 15. 保存矢量格式到PDF文件
pdf("cars.pdf")
plot(cars$dist ~ cars$speed,
     main = "Relationship between car distance and speed",
     xlab = "Speed (miles per hour)",
     ylab = "Distance travelled (miles)",
     xlim = c(0,30),
     ylim = c(0,140),
     xaxs = "i",
     yaxs = "i",
     col  = "red",
     pch  = 19,
     cex  = 0.5)
dev.off()

# 16. svg文件
svg("3067_10_03.svg")
plot(cars$dist ~ cars$speed,
     main = "Relationship between car distance and speed",
     xlab = "Speed (miles per hour)",
     ylab = "Distance travelled (miles)",
     xlim = c(0,30),
     ylim = c(0,140),
     xaxs = "i",
     yaxs = "i",
     col  = "red",
     pch  = 19,
     cex  = 0.5)
dev.off()

# 17. ps文件
postscript("3067_10_03.ps")
plot(cars$dist ~ cars$speed,
     main = "Relationship between car distance and speed",
     xlab = "Speed (miles per hour)",
     ylab = "Distance travelled (miles)",
     xlim = c(0,30),
     ylim = c(0,140),
     xaxs = "i",
     yaxs = "i",
     col  = "red",
     pch  = 19,
     cex  = 0.5)
dev.off()

# 18. svg文件
## install.packages("Cairo")
library(Cairo)
CairoSVG("3067_10_03.svg")
plot(cars$dist ~ cars$speed,
     main = "Relationship between car distance and speed",
     xlab = "Speed (miles per hour)",
     ylab = "Distance travelled (miles)",
     xlim = c(0,30),
     ylim = c(0,140),
     xaxs = "i",
     yaxs = "i",
     col  = "red",
     pch  = 19,
     cex  = 0.5)
dev.off()

# 19. 在一个pdf文件中输出多张图
pdf("multiple.pdf")
for(i in 1:3)
  plot(cars,pch = 19,col = i)
dev.off()

# 20. 改变色彩模式
pdf("multiple_colmdl.pdf",colormodel="cmyk")
for(i in 1:3)
  plot(cars,pch = 19,col = i)
dev.off()

# 21. 在输出中表现数学公式
air = read.csv("airpollution.csv")
plot(air,las = 1,
     main = expression(paste("Relationship between ",PM[10]," and ",NO[X])),
     xlab = expression(paste(NO[X]," concentrations (",mu*g^-3,")")),
     ylab = expression(paste(PM[10]," concentrations (",mu*g^-3,")")))
## 公式表达举例
demo(plotmath)

# 22. 给图片加上公式形式的文本注释
par(mar = c(12,4,3,2))
plot(rnorm(1000), main = "Random Normal Distribution")
desc = expression(paste("The normal distribution has density ",
                        f(x) == frac(1,sqrt(2*pi)*sigma)~ plain(e)^frac(-(x-mu)^2,2*sigma^2)))
mtext(desc, side = 1,
      line = 4,padj = 1,adj = 0)
mtext(expression(paste("where ", mu, " is the mean of the distribution and ",
                       sigma," the standard deviation.")
                 ),
      side = 1,
      line = 7,
      padj = 1,
      adj  = 0)

# 23. 使用不同的字体
par(mar = c(1,1,5,1))
plot(1:200, type = "n", main = "Fonts under Windows",
     axes = FALSE, xlab = "",ylab = "")
text(0,180,"Arial \n(family=\"sans\", font=1)", 
     family = "sans",font = 1,adj = 0)
text(0,140,"Arial Bold \n(family=\"sans\", font=2)", 
     family = "sans",font = 2,adj = 0)
text(0,100,"Arial Italic \n(family=\"sans\", font=3)", 
     family = "sans",font = 3,adj = 0)
text(0,60, "Arial Bold Italic \n(family=\"sans\", font=4)", 
     family = "sans",font = 4,adj = 0)

text(70,180,"Times \n(family=\"serif\", font=1)", 
     family = "serif",font = 1,adj = 0)
text(70,140,"Times Bold \n(family=\"serif\", font=2)", 
     family = "serif",font = 2,adj = 0)
text(70,100,"Times Italic \n(family=\"serif\", font=3)", 
     family = "serif",font = 3,adj = 0)
text(70,60,"Times Bold Italic \n(family=\"serif\", font=4)", 
     family = "serif",font = 4,adj = 0)

text(130,180,"Courier New\n(family=\"mono\", font=1)",
     family = "mono",font = 1,adj = 0)
text(130,140,"Courier New Bold \n(family=\"mono\", font=2)", 
     family = "mono",font = 2,adj = 0)
text(130,100,"Courier New Italic \n(family=\"mono\", font=3)",
     family = "mono",font = 3,adj = 0)
text(130,60,"Courier New Bold Italic \n(family=\"mono\", font=4)", 
     family = "mono",font = 4,adj = 0)


# 24. 画联系图的例子
## install.packages("geosphere")
library(maps)
library(geosphere)
xlim = c(-171.738281, -56.601563)
ylim = c(12.039321, 71.856229)
map("world",
    col  = "#f2f2f2",
    fill = TRUE,
    bg   = "white",
    lwd  = 0.05,
    xlim = xlim,
    ylim = ylim )
airports = read.csv("http://datasets.flowingdata.com/tuts/maparcs/airports.csv", header = TRUE)
flights  = read.csv("http://datasets.flowingdata.com/tuts/maparcs/flights.csv",  header = TRUE, as.is = TRUE)
map("world",
    col  = "#f2f2f2",
    fill = TRUE,
    bg   = "white",
    lwd  = 0.05,
    xlim = xlim,
    ylim = ylim )
fsub = flights[flights$airline == "AA",]
for (j in 1:length(fsub$airline)) {
  air1 = airports[airports$iata == fsub[j,]$airport1,]
  air2 = airports[airports$iata == fsub[j,]$airport2,]
  inter = gcIntermediate(c(air1[1,]$long, air1[1,]$lat),
                         c(air2[1,]$long, air2[1,]$lat),
                         n = 100, addStartEnd = TRUE)
  lines(inter, col = "black", lwd = 0.8)
}

pal = colorRampPalette(c("#f2f2f2", "black"))
colors = pal(100)
map("world",
    col  = "#f2f2f2",
    fill = TRUE,
    bg   = "white",
    lwd  = 0.05,
    xlim = xlim,
    ylim = ylim)
fsub = flights[flights$airline == "AA",]
maxcnt = max(fsub$cnt)
for (j in 1:length(fsub$airline)) {
  air1 = airports[airports$iata == fsub[j,]$airport1,]
  air2 = airports[airports$iata == fsub[j,]$airport2,]
  inter = gcIntermediate(c(air1[1,]$long, air1[1,]$lat), c(air2[1,]$long, air2[1,]$lat), n=100, addStartEnd=TRUE)
  colindex = round((fsub[j,]$cnt / maxcnt) * length(colors) )
  lines(inter, col = colors[colindex], lwd = 0.8)
}

pal = colorRampPalette(c("#f2f2f2", "black"))
pal = colorRampPalette(c("#f2f2f2", "red"))
colors = pal(100)
map("world", col = "#f2f2f2", fill = TRUE,
    bg = "white", lwd = 0.05, 
    xlim = xlim, ylim = ylim)
fsub = flights[flights$airline == "AA",]
fsub = fsub[order(fsub$cnt),]
maxcnt = max(fsub$cnt)
for (j in 1:length(fsub$airline)) {
  air1 = airports[airports$iata == fsub[j,]$airport1,]
  air2 = airports[airports$iata == fsub[j,]$airport2,]
  inter = gcIntermediate(c(air1[1,]$long, air1[1,]$lat), c(air2[1,]$long, air2[1,]$lat), n=100, addStartEnd=TRUE)
  colindex = round( (fsub[j,]$cnt / maxcnt) * length(colors) )
  lines(inter, col = colors[colindex], lwd = 0.8)
}


pal = colorRampPalette(c("#f2f2f2", "red"))
carriers = unique(flights$airline)
pal = colorRampPalette(c("#333333", "white", "#1292db"))
colors = pal(100)
for (i in 1:length(carriers)) {
  pdf(paste("carrier", carriers[i], ".pdf", sep=""),
      width = 11, height = 7)
  map("world", col="#191919", fill=TRUE, 
      bg = "#000000", lwd = 0.05, 
      xlim = xlim, ylim = ylim)
  fsub = flights[flights$airline == carriers[i],]
  fsub = fsub[order(fsub$cnt),]
  maxcnt = max(fsub$cnt)
  for (j in 1:length(fsub$airline)) {
    air1 = airports[airports$iata == fsub[j,]$airport1,]
    air2 = airports[airports$iata == fsub[j,]$airport2,]
    inter = gcIntermediate(c(air1[1,]$long, air1[1,]$lat), c(air2[1,]$long, air2[1,]$lat), n=100, addStartEnd=TRUE)
    colindex = round( (fsub[j,]$cnt / maxcnt) * length(colors) )
    lines(inter, col=colors[colindex], lwd=0.6)
  }
  dev.off()
}
