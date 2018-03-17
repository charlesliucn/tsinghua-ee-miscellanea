library(ggplot2)
## 散点图
qplot(displ, hwy, 
      data = mpg, 
      colour = factor(cyl))
qplot(displ, hwy, 
      data = mpg, 
      facets = . ~ year) + geom_smooth()

#=================
#=====ggplot======
#=================
ggplot(msleep, aes(sleep_rem / sleep_total, awake)) +
  geom_point()
qplot(sleep_rem / sleep_total, 
      awake, data = msleep)
qplot(sleep_rem / sleep_total, 
      awake, data = msleep) + 
   geom_smooth()
qplot(sleep_rem / sleep_total, 
      awake, data = msleep,
      geom = c("point", "smooth"))
ggplot(msleep, aes(sleep_rem / sleep_total, awake)) +
  geom_point() + geom_smooth()

p = ggplot(mtcars, aes(mpg, wt, colour = cyl)) + 
  geom_point()
mtcars =  transform(mtcars, mpg = mpg ^ 2)
p %+% mtcars


## 组合geoms和stats
d = ggplot(diamonds, aes(carat)) + xlim(0, 3)
d + stat_bin(aes(ymax = ..count..), 
             binwidth = 0.1, 
             geom = "area")
d + stat_bin(
  aes(size = ..density..), 
  binwidth = 0.1,
  geom = "point", 
  position="identity"
)
d + stat_bin(
  aes(fill = ..count..), binwidth = 0.1,
  geom = "tile", position="identity"
)

## 一个复杂的例子
library(ggplot2)
#model = lme(height ~ age, 
#            data = Oxboys, 
#            random = ~ 1 + age | Subject)
#oplot = ggplot(Oxboys, aes(age, height, group = Subject)) + 
# geom_line()
#age_grid = seq(-1, 1, length = 10)
#subjects = unique(Oxboys$Subject)
#preds = expand.grid(age = age_grid, Subject = subjects)
#preds$height = predict(model, preds)
#oplot + geom_line(data = preds, 
#                  colour = "#3366FF", 
#                  size= 0.4)