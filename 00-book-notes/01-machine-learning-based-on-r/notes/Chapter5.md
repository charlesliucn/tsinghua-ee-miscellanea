# 机器学习与R语言---Chapter 5:朴素贝叶斯分类
### 1. 朴素贝叶斯分类
+ 朴素贝叶斯算法是依照概率准则进行分类，应用先前事件的有关数据估计未来事件发生的概率。
+ 贝叶斯分类器广泛的应用：
	- 文本分类：垃圾邮件过滤、主题分类等
	- 计算机网络中入侵检测或者异常检测
	- 根据一组观察的症状进行身体状况的诊断
+ 朴素贝叶斯算法最常见的应用是：根据过去垃圾邮件中单词使用的频率来识别新的垃圾邮件。
+ 朴素贝叶斯算法的优缺点：
	- 优点
		* 需要训练的例子相对较少
	 	* 能处理好噪声数据和缺失数据
	- 缺点
		* 应用于含有大量数值特征数据集时不理想
		* 概率的估计值相对于预测的类更加不可靠
+ 朴素贝叶斯算法的通用性和准确性
	- 朴素贝叶斯算法假设数据集的所有特征具有相同的重要性和独立性，但是实际这个条件是基本不成立的。但是，即使朴素贝叶斯违背了真实情况，它仍然可以很好的应用。可以这么说，即使是在极端事件中，特征之间具有很强的依赖性时，朴素贝叶斯也适用。至于为什么在这种假设下，朴素贝叶斯还能有效应用，详见机器学习的相关文献[“On the Optimality of the Simple Bayesian Classifier under Zero-One Loss”](http://xueshu.baidu.com/s?wd=paperuri%3A%2838e409baf833d8e58913d1c57f6b77c3%29&filter=sc_long_sign&tn=SE_xueshusource_2kduw22v&sc_vurl=http%3A%2F%2Fciteseer.ist.psu.edu%2Fviewdoc%2Fdownload%3Bjsessionid%3D5970DBAAAF921251AF6B91C6FC538A50%3Fdoi%3D10.1.1.385.5272%26rep%3Drep1%26type%3Dpdf&ie=utf-8&sc_us=11751131592006101238)
	- 朴素贝叶斯具有很强的通用性和较高的准确性，因而在分类学习中，朴素贝叶斯往往是候选算法的第一个。

### 2. 相关基础知识
+ 朴素贝叶斯分类
	- 朴素贝叶斯假设类条件独立，意味着事件在相同类取值条件下是相互独立的。
+ 拉普拉斯估计
	- 在贝叶斯算法中，概率值是相乘的，概率为0的时间会导致概率结果为0。为了解决这一问题，需要使用**拉普拉斯估计**。
	- 拉普拉斯估计的本质：给概率表中每个计算加上一个较小的数，从而避免出现概率为0的时间。
	- 设定的数值也可以不为1，在实际应用中，在给定一个足够大的训练数据集时，概率为0的时间认为不存在，因而不需要考虑这一问题，而且几乎总是设定增加的数值为1。

### 3. 实例：基于贝叶斯算法的手机垃圾短信过滤
*----尚未进行整理归纳---*
```
library(tm)
library(wordcloud)
library(e1071)
library(gmodels)
sms_data = read.csv(file = "sms_spam.csv", stringsAsFactors = F,encoding = "UTF-8")
sms_data$type = factor(sms_data$type)
table(sms_data$type)
sms_corpus = Corpus(VectorSource(sms_data$text))
inspect(sms_corpus[1:5])
corpus_clean = tm_map(sms_corpus,tolower)
corpus_clean = tm_map(corpus_clean,removeNumbers)
inspect(corpus_clean[1:5])
corpus_clean = tm_map(corpus_clean,removeWords,stopwords())
corpus_clean = tm_map(corpus_clean,removePunctuation)
inspect(corpus_clean[1:5])
corpus_clean = tm_map(corpus_clean,stripWhitespace)
inspect(corpus_clean[1:5])
sms_dtm = DocumentTermMatrix(corpus_clean)

sms_data_train = sms_data[1:4169,]
sms_data_test = sms_data[4170:5559,]
sms_dtm_train = sms_dtm[1:4169,]
sms_dtm_train = sms_dtm[4170:5559,]
sms_corpus_train = corpus_clean[1:4169]
sms_corpus_test = corpus_clean[4170:5559]

prop.table(table(sms_data_test$type))
prop.table(table(sms_data_train$type))

# 可视化文本数据--词云
colors=brewer.pal(8,"Dark2")
wordcloud(sms_corpus_train,min.freq = 40,random.order = F,
          colors = colors,random.color = F)

spam = subset(sms_data_train,type == "spam")
ham = subset(sms_data_test,type == "ham")
wordcloud(spam$text,max.words = 40,random.order = F,random.color = F,colors = colors)
wordcloud(ham$tex,max.words = 40,random.order = F,colors = colors)

sms_dict = list(dictionary = findFreqTerms(sms_dtm_train,5))
sms_train = DocumentTermMatrix(sms_corpus_train,sms_dict)
sms_test = DocumentTermMatrix(sms_corpus_test,sms_dict)

convert_counts = function(x)
{
  x = ifelse(x>0,1,0)
  x = factor(x,levels = c(0,1),labels = c("No","Yes"))
  return(x)
}

sms_train = apply(sms_train,MARGIN = 2,convert_counts)
sms_test  = apply(sms_test,MARGIN = 2,convert_counts)

## 基于数据训练模型
sms_classifier = naiveBayes(sms_train,sms_data_train$type)
sms_test_pred = predict(sms_classifier,sms_test)
CrossTable(sms_test_pred,sms_data_test$type,prop.chisq = F,prop.t = F,dnn = c('predicted','actual'))
```
