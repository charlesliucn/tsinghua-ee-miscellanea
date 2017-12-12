# 机器学习与R语言---Chapter 2:数据的管理和理解
### 1. R管理数据
 + 保存和加载R数据结构：
```r	
	save(x, y, z, file = "mydata.RData") #保存
	load("mydata.RData") #加载
```
 + 保存成CSV文件：
```r
	write.csv(mydata, file = "mydata.csv")
```

 + 从SQL数据库导入数据：
```r
	library(RODBC)
	mydb = odbcConnect("mydsn",uid = "username",pwd = "password")
	# 使用sqlQuery执行SQL查询：
	patient_query = "select * from patienct_data"
	patient_data = sql(channel = mydb, query = patient_query)
	odbcClose(mydb)  # 关闭数据库
```

### 2. 对实际数据操作：
```r
usedcars = read.csv("usedcars.csv")
str(data)  # 显示数据框的基本信息
summary(usedcars$year) # 看看二手车数据的year的特征信息
range(usedcars$price)  # 查看数据的取值范围
diff(usedcars$price)   # 查看数据最大最小值之差
IRQ(usedcars$price)    # 查看数据的四分位距
quantile(usedcars$price) # 查看各四分位数
quantile(usedcars$price, probs = c(0.1,0.9))# 选择不同的分割点

boxplot(usedcars$price,main = "Boxplot of Used Cars Prices",ylab = "price($)")
# 作出箱图，箱图的宽度是任意的，不具有数字特征(notch和width可以修改形状和宽度)

hist(usedcars$mileage, main = "Histogram of Used Cars Mileage",xlab = "Mileage")
var(usedcars$price)  #方差函数
sd(usedcars$mileage) #标准差函数
# 正态分布的68-95-99.7准则

# 分类变量
table(usedcars$model)
tableA = table(usedcars$color)
table(usedcars$transmission)
# 以颜色为例
tablere = prop.table(tableA)*100
colorper = round(tablere,digits = 1) # 保留小数点后一位
sort(colorper)

mode(usedcars$year)  # 获得变量的类型

# 探究Price与Mileage之间的关系
library(ggplot2)
ggplot(usedcars,aes(x = mileage, y = price)) + geom_point() + 
  labs(title="Used Car Price v.s. Mileage", x="Used Car Mileage", y="Used Car Price")+
  theme(plot.title = element_text(hjust = 0.5))

# 双向交叉表，检验变量之间的关系
usedcars$conser = usedcars$color %in% c("Black","Gray","Silver","White")
# 将二手车color按照是否保守来分类
table(usedcars$conser)  #获取保守/不保守的数目
CrossTable(usedcars$model,usedcars$conser,chisq = T)  # 交叉表，分别为列和行
# 交叉表每个格子里的数据表示：
# 1. 该格子对应的数据数目
# 2. 该单元格的卡方统计量(皮尔森卡方独立性检验)，概率越低，表明两变量的相关性越大
# 3. 该单元格在行中所占的比例
# 4. 该单元格在列中所占的比例
# 5. 该单元格在整个表格中的比例
# 6. 最后的卡方检验p越大，表明相关性越弱，偶然的可能性越大。

```
