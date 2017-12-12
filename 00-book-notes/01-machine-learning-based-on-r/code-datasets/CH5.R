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

















