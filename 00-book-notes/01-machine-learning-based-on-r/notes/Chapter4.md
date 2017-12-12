# 机器学习与R语言---Chapter 4:懒惰学习——使用近邻分类
### 1. KNN算法
+ 基本原理：
	kNN算法针对于包含若干类别的数据集。对于测试数据集和训练数据集，两者具有完全相同的特征属性。对于测试数据集中的每一个记录，kNN算法通过确定训练数据集中与该记录相似度最近的k条记录，k为事先设定的整数值。在最相近的k条记录中，该测试数据被分到所占比例最大的类别中。

+ 算法优缺点：
	- 优点：
	简单有效；对数据分布无要求；训练阶段很快
	- 缺点：
	分类阶段很慢；需要大量内存；不产生模型(非参数模型)，发现特征之间关系的能力有限

### 2. 基础准备和说明：
+ 对于距离：
	kNN算法最关键的步骤是找到距离测试数据最近的训练数据。因而距离的衡量是该算法的重要概念之一。该算法常用的距离度量有两种，一种是传统意义上的欧氏距离，一种是曼哈顿距离(城区距离)。

+ 对于k:
	kNN算法中一个重要的参数为k，如何选择合适的k值显得尤为重要。k的选择问题可以归结为**偏差-方差权衡问题**，也就意味着要在过度拟合和低度拟合之和进行平衡。
	一般有以下几种方法选择k值：
	1. k选取3~10；
	2. 设置k等于训练数据数量的平方根；
	3. 基于各种测试数据测试多个k值，选择一个可以提供最好分类性能的k值。
	事实上，如果训练数据量足够大，足够具有代表性，k值的选择显得不是特别重要。

+ 对于kNN算法的数据：
	- kNN算法在分类时，一般不同的属性特征的取值范围是不同的，数据的大小也有很大的差异。为了避免其中某一个或多个特征(取值较大的特征)遮蔽范围较小的特征，需要对不同特征的距离衡量进行标准化(尺度调整)。常用的方法主要有：
		1. min-max标准化；
		2. z-score标准化(正态分布特征)；

	- 另外对于一些名义特征，也就是非数值型的属性，需要将其转化为数值型特征，典型的解决方法是**哑变量编码**(一种类似于示性函数的表示方法)。

### 4. 对**懒惰学习**的解释
+ 基于近邻的分类算法被认为是懒惰学习方法，主要体现于：
  - 高度依赖于训练案例，又被称为**基于实例的学习**或**机械学习**；
  - 训练阶段进行的很快，但是预测的过程变得相对较慢；
  - 基于实例的学习不会建立数学模型，被归为**非参数学习**方法。


### 5.实例：用kNN算法诊断乳腺癌
+ 实际操作的一般顺序和思路如下：
	- 准备数据：做一些基本的数据处理
		* 去除无关的变量，比如id特征等
		* R中机器学习分类器一般要求将目标属性编码为factor类型
		* kNN算法需要对数值型数据标准化：min-max或者z-score
		* 从已有的数据创建训练数据集和测试数据集
	- 使用kNN算法训练数据，创建分类器并进行预测
	- 使用CrossTable函数评估模型的性能(准确率和普适性等等)
	- 提高模型的性能
		* 尝试改变参数k值的大小
		* 使用其他标准化方法

+ 实例代码及相关说明：
```
  library(class)   # 其中包含knn函数
  library(gmodels) # 其中包含CrossTable函数得出对测试数据的准确性
  
  # 读入数据集数据的基本处理
  bc_data = read.csv(file = "wisc_bc_data.csv",stringsAsFactors = F)
  str(bc_data)
  bc_data = bc_data[-1]
  bc_data$diagnosis = factor(bc_data$diagnosis,levels = c("B","M"))
  
  # min-max标准化方法，使值均落在[0,1]之间
  min_max = function(x)
  {
    min_max = (x-min(x))/(max(x)-min(x))
  }
  bc_data_norm = as.data.frame(lapply(bc_data[2:31],min_max))

# ---------------------------------------------------
  #随机选取测试数据和训练数据，而不是按照角标顺序选择
  #index = c(1:576)
  #test_index = sort(sample(index,100))
  #train_index = sort(index[-test_index])
  #bc_train_labels = bc_data[train_index,1]
  #bc_test_labels = bc_data[test_index,1]
#----------------------------------------------------
  
  # 准备测试数据和训练数据
  bc_train = bc_data_norm[1:469,]
  bc_test = bc_data_norm[470:569,]
  
  # 训练数据和测试数据的目标输出
  # 包含数据每一行分类的因子向量
  bc_train_labels = bc_data[1:469,1]  # 用于训练，是knn的一个参数
  bc_test_labels = bc_data[470:569,1] # 用于结果的验证
  
  # 最核心的算法部分：kNN函数，注意k值的选取，一般为训练数据量的平方根
  bc_result = knn(train = bc_train,test = bc_test,cl = bc_train_labels,k = 5)
  
  # 使用CrossTable函数展示分类的结果
  CrossTable(bc_test_labels,bc_result,prop.chisq = F)


# -------------------------------------------------
  # 对之前模型性能的提高
  # 不使用min-max标准化方法，而是使用z-score方法
  bc_data_norm = as.data.frame(scale(bc_data[2:31]))
  # 准备测试数据和训练数据
  bc_train = bc_data_norm[1:469,]
  bc_test = bc_data_norm[470:569,]
  
  # 训练数据和测试数据的目标输出
  # 包含数据每一行分类的因子向量
  bc_train_labels = bc_data[1:469,1]  # 用于训练，是knn的一个参数
  bc_test_labels = bc_data[470:569,1] # 用于结果的验证
  
  # 最核心的算法部分：kNN函数，注意k值的选取，一般为训练数据量的平方根
  bc_result = knn(train = bc_train,test = bc_test,cl = bc_train_labels,k = 5)
  
  # 使用CrossTable函数展示分类的结果
  CrossTable(bc_test_labels,bc_result,prop.chisq = F)
```
+ 将预测结果与实际分类结果比较，发现预测率在该数据集上竟然可以达到惊人的98%。由此可见，kNN算法虽然简单，但是能处理复杂的任务。
