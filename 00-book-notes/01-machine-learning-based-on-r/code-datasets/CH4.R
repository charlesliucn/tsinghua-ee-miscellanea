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