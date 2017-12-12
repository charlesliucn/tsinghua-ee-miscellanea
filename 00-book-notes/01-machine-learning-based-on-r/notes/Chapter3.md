# 机器学习与R语言---Chapter 3:回归方法预测数值型数据
### 1. 回归方法的分类：
 + 线性回归
 	+ 简单线性回归
 	+ 多元回归
 + 逻辑回归：对二元分类的结果建模
 + 泊松回归：对整型的计数数据建模

### 2. 线性回归示例：
```r
	launch = read.csv("challenger.csv")
	cor(launch$distress_ct,launch$temperature) #计算O型环失效次数与温度之间的相关性
	# 对相关系数的说明
	# 低于0.1 不具有相关性
	# 0.1 ~ 0.3 弱相关
	# 0.3 ~ 0.5 中相关
	# 0.5以上   强相关

	# 线性回归函数的拟合
	lm(formula = launch$distress_ct~launch$temperature)

	# 多元线性回归函数
	lm(formula = launch$distress_ct ~ launch$temperature + launch$pressure + launch$launch_id)

	# 自己编写多元线性回归
	multi_reg = function(y,x)
	{
	  x = as.matrix(x)
	  x = cbind(Intercept = 1,x)
	  solve(t(x) %*% x) %*% t(x) %*% y # 求解系数
	}
	multi_reg(launch$distress_ct,launch[3])
	multi_reg(launch$distress_ct,launch[3:5])
```

### 3. 应用线性回顾预测医疗费用
```r
# 读入数据
	insurance = read.csv("insurance.csv",stringsAsFactors = T)
	# 查看数据基本信息
	str(insurance)

	# 关于费用多少的分布
	summary(insurance$charges) # 平均值大于中位数，说明费用分布为右偏的
	# 分别用自带图和ggplot2作图查看费用分布
	hist(insurance$charges)
	library(ggplot2)
	ggplot(insurance,aes(x = charges)) +
	  geom_histogram(bins = 20,color = "purple",fill = "blue")+
	  labs(title = "The distribution of Insurance Charges",y = "Num of People") +
	  theme(plot.title = element_text(hjust = 0.5))

	summary(insurance$sex)
	summary(insurance$smoker)
	summary(insurance$region)

	# 获取insurance个变量之间的相关系数
	cor(insurance[c("age","bmi","children","charges")])

	# 散点图矩阵的不同画法
	pairs(insurance[c("age","bmi","children","charges")])
	library(psych)
	pairs.panels(insurance[c("age","bmi","children","charges")])
	library(car)
	attach(insurance)
	scatterplotMatrix(~age + bmi + children + charges)
	library(gpairs)
	gpairs(insurance[c("age","bmi","children","charges")])
	library(lattice)
	splom(insurance[c("age","bmi","children","charges")])

	## 从不同散点图能够获得哪些信息？


	## 基于数据训练模型
	ins_model = lm(charges~age + children + sex + smoker,data = insurance)
	ins_pred = predict(ins_model,insurance[101:150,])
	ins_model
	ins_model2 = lm(charges~.,data = insurance) # .表示数据框中除去已定义的所有变量

```

### 4. 关于虚拟编码
 + 在上面的例子中，虽然在模型公式中仅定义了6个因变量，但是输出的系数有8个(除去截距项)，这是由于lm()函数存在着一种虚拟编码技术，应用于模型中包含的每个factor类型的变量中。

 + 虚拟编码是将factor当作数值型变量处理，例如sex有male和female, R中将其命名为sexmale和sexfemale，相同的，smokeryes、smokerno以及region都进行了这样的处理。在最后的模型中属于同一个factor的数值型变量总有一个被排除在模型之外，作为参照类别。上面的例子中东北地区的女性非吸烟者就作为参照，输出的结果都是相对于这一参照组进行说明的。正值表明相对于参照组多，负值表示相对参照组少。

 + 一般将factor的第一个因子作为参照组，如果要改变，可以使用relevel函数改变。

### 5. 评估模型的性能
summary()函数的输出为评估模型的性能提供了3个关键的方面:

 + Residuals 残差提供了预测误差的主要统计量，残差表示真实值减去预测值
 + *号表示模型中每个特征的预测能力。其中三颗*的出现表示显著性水平为0，意味着该特征不可能是与因变量无关的量，一个常用的做法为使用0.05的显著性水平来表示统计意义上的显著变量。
 + 多元R方值(也成为判定系数)提供了一种度量模型性能的方式，值越接近于1.0，模型解释数据的性能越好，R=0.75可以认为75%的因变量的变化程度可以由该模型解释。 

### 6. 提高模型的性能
 + 模型的假定：增加非线性关系。
 	- 在线性回归中，自变量与因变量之间假定存在线性关系。事实上，在实际情况中，大多数关系都不是简单的线性，因而对于模型需要进行一定的修正。
 	- 此处，我们添加的非线性关系为二次项，如何对非线性关系进行回归呢？以下提供了一个思路。
        - 将非线性的变量(比如年龄age的平方)增加到模型之中，将该变量视作一个变量，然后使用多元的线性回归即可。
	```
	# 示例：仅对age变量添加非线性项
	insurance$agesq = insurance$age^2
	model_ori = lm(charges ~ age,data = insurance)
	summary(model_ori)
	model_fix = lm(charges ~ age + agesq, data = insurance)
	summary(model_fix)
	```

 + 数值转换——将数值型变量转换为二进制指标
	- 以预测医疗费用为例，对于正常体重范围内的个人来说，BMI对医疗费用的影响可以忽略不计，但是对于肥胖者(BMI指标大于30)的人来说，BMI对医疗费用可能具有很大的影响。
	- 因而可以创建一个表征是否肥胖的二进制特征，得到个人是否肥胖的结果。

   	```r
	# 将数值型bmi转换为表征是否肥胖的二进制指标
	insurance$thfat = ifelse(insurance$bmi > 30,1,0)
	## ifelse()函数，第一个参数为条件，成立则返回第二个参数值，否则返回第三个参数值
   	```

 + 加入相互作用的影响
 	以上模型建立的过程只考虑了每个过程对结果的单独影响。事实上，很容易想到，吸烟和肥胖可能对结果都有有害的影响，但是假设它们的共同的影响可能比每个单独的影响更糟糕。
 	因而增加一个表示相互作用的项。使用肥胖指标和吸烟指标的相互作用项。R语言中，运算符“:”表示变量之间的相互作用，也可以使用“*”，这样模型将自动包括*号两边的变量。
   ```r
	# 增加相互作用项
	model_nomutual = lm(charges~ thfat + smoker,data = insurance)
	summary(model_nomutual)
	model_mutual = lm(charges ~ thfat + smoker + thfat:smoker, data = insurance)
	summary(model_mutual)
   ```

 + 改进后的模型

	  + 增加了年龄的非线性项
	  + 为肥胖创建了二进制指标
	  + 增加了肥胖和吸烟之间的相互作用
```r
#最终模型
model_final = lm(charges ~ age + agesq + children + bmi 
                 + sex + thfat*smoker + region, data = insurance)
summary(model_final)
```
