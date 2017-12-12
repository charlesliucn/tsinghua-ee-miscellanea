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
ins_model = lm(charges~age + children + sex + bmi + smoker + region,data = insurance)
ins_pred = predict(ins_model,insurance[101:150,])
ins_model
ins_model2 = lm(charges~.,data = insurance) # .表示数据框中除去已定义的所有变量
ins_model2
insurance$sex = relevel(insurance$sex,ref = "male")  # male作为参考组
ins_model3 = lm(charges~.,data = insurance)
ins_model3


#评估模型的性能
summary(ins_model)


# 示例：仅对age变量添加非线性项
insurance$agesq = insurance$age^2
model_ori = lm(charges ~ age,data = insurance)
summary(model_ori)
model_fix = lm(charges ~ age + agesq, data = insurance)
summary(model_fix)

# 将数值型bmi转换为表征是否肥胖的二进制指标
insurance$thfat = ifelse(insurance$bmi > 30,1,0)
## ifelse()函数，第一个参数为条件，成立则返回第二个参数值，否则返回第三个参数值

# 增加相互作用项
model_nomutual = lm(charges~ thfat + smoker,data = insurance)
summary(model_nomutual)
model_mutual = lm(charges ~ thfat + smoker + thfat:smoker, data = insurance)
summary(model_mutual)

#最终模型
model_final = lm(charges ~ age + agesq + children + bmi 
                 + sex + thfat*smoker + region, data = insurance)
summary(model_final)
