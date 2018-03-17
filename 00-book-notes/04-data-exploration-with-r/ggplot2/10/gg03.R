library(ggplot2)
## 传统ggplot2风格
ggplot(mtcars,aes(x = mpg,y = wt,size = cyl,colour = factor(gear)))+
  geom_point(alpha=.5)+ #透明度
  scale_size_area()+ #区域和数值成比例
  scale_colour_brewer(palette="Set1")+
  ggtitle("Motor Trend Car Road Tests")
## Excel风格
### theme_excel()
## Economist风格
### theme_economist()
## 深色风格
### theme_solarized()

## ggsave()输出到文件
qplot(mpg, wt, data = mtcars)
ggsave(file = "output.pdf")
pdf(file = "output.pdf", width = 6, height = 6)
qplot(mpg, wt, data = mtcars)
qplot(wt, mpg, data = mtcars)
dev.off()
## 在同一页面上画多幅图片
a = qplot(date, unemploy, data = economics, geom = "line")
b = qplot(uempmed, unemploy, data = economics) +
    geom_smooth(se = F)
c = qplot(uempmed, unemploy, data = economics, geom="path")

library(grid)
## 一个viewport占用1个图
vp1 = viewport(width = 1, height = 1, x = 0.5, y = 0.5)
vp1 = viewport()
vp2 = viewport(width = 0.5, height = 0.5, x = 0.5, y = 0.5)
vp2 = viewport(width = 0.5, height = 0.5)
vp3 = viewport(width = unit(2, "cm"), height = unit(3, "cm"))

pdf("polishing-subplot-1.pdf", width = 4, height = 4)
subvp = viewport(width = 0.4, height = 0.4, x = 0.75, y = 0.35)
b
print(c, vp = subvp)
dev.off()

## 改进版
csmall = c +
  theme_gray(9) +
  labs(x = NULL, y = NULL) +
  theme(plot.margin = unit(rep(0, 4), "lines"))
pdf("polishing-subplot-2.pdf", width = 4, height = 4)
b
print(csmall, vp = subvp)
dev.off()

## 指定比例
pdf("polishing-layout.pdf", width = 8, height = 6)
grid.newpage()
pushViewport(viewport(layout = grid.layout(2, 2)))
vplayout = function(x, y)
  viewport(layout.pos.row = x, layout.pos.col = y)
print(a, vp = vplayout(1, 1:2))
print(b, vp = vplayout(2, 1))
print(c, vp = vplayout(2, 2))
dev.off()

## 画函数图像
p = ggplot(data.frame(x = c(-3,3)), aes(x = x))
p + stat_function(fun = dnorm)

myfun = function(xvar) {
  1/(1 + exp(-xvar + 10))
}
ggplot(data.frame(x = c(0, 20)), aes(x = x)) +
  stat_function(fun = myfun)

## 画微积分学中常见的曲边梯形
# Return dnorm(x) for 0 < x < 2, and NA for all other x
dnorm_limit = function(x) {
  y = dnorm(x)
  y[x < 0 | x > 2] <- NA
  return(y)
}
# ggplot() with dummy data
p = ggplot(data.frame(x = c(-3, 3)), aes(x = x))
p + stat_function(fun = dnorm_limit, 
                  geom = "area", 
                  fill = "blue", 
                  alpha = 0.2) +
  stat_function(fun=dnorm)

## 让图形动起来
library(rgl)
plot3d(mtcars$wt, 
       mtcars$disp, 
       mtcars$mpg, 
       type = "s",
       size = 0.75, 
       lit  = FALSE)
play3d(spin3d())
