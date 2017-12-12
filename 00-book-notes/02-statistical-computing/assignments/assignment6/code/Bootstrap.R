# 刘前 2014011216 无47
# HW6 Bootstrap

library(MASS) # load package MASS
data(cats)    # load in the cat data

# the basic model of the cats
# linear regression of Heart Weight and Body Weight
basic.model = lm(Hwt~Bwt, data = cats)
# the model coefficients
basic.model.coefs = basic.model$coefficients
basic.model.coef1 = basic.model.coefs[1]
basic.model.coef2 = basic.model.coefs[2]

##-------------------------------------------------------
##-----------Without Using Bootstrap Package-------------
##-------------------------------------------------------
n = nrow(cats)  # the size of the dataset
B = 200         # the number of times of Bootstrapping
lm.coef1 = numeric(B)   # Intercept: the first coefficient
lm.coef2 = numeric(B)   # the second coefficient
for (b in 1:B){
  id = sample(1:n, n, replace = T)  # Sampling with replacement
  cats.samples = cats[id,]
  model = lm(Hwt~Bwt, data = cats.samples)  # linear regression
  model.coefs = model$coefficients  # model coefficients
  lm.coef1[b] = model.coefs[1]
  lm.coef2[b] = model.coefs[2]
}
# hist the coefficients
hist(lm.coef1,probability = T)
hist(lm.coef2,probability = T)

##--------------- A.  the standard error -----------------
# the standard error 
coef1.se = sd(lm.coef1)
coef2.se = sd(lm.coef2)

##---------------------- B.  the bias --------------------
# the bias of coefficients
coef1.bias = mean(lm.coef1) - basic.model.coef1
coef2.bias = mean(lm.coef2) - basic.model.coef2

##---------- C. 4 types of Confidence Intervals-----------

# 1a. normal confidence interval for the first coefficient (Intercept)
basic.model.coef1 - qnorm(0.975)*sd(lm.coef1)
basic.model.coef1 + qnorm(0.975)*sd(lm.coef1)
# 1b. normal confidence interval for the second coefficient
basic.model.coef2 - qnorm(0.975)*sd(lm.coef2)
basic.model.coef2 + qnorm(0.975)*sd(lm.coef2)

# 2a. basic confidence interval for the first coeeficient (Intercept)
2*basic.model.coef1 - quantile(lm.coef1,c(0.975,0.025))
# 2b. basic confidence interval for the first coeeficient (Intercept)
2*basic.model.coef2 - quantile(lm.coef2,c(0.975,0.025))

# 3a. confidence interval for the first coefficient (Intercept)
quantile(lm.coef1,c(0.025,0.975))
# 3b. quantile confidence interval for the second coefficient
quantile(lm.coef2,c(0.025,0.975))

# Bca confidence interval for the coefficients
# Jackknife
z1 = qnorm(mean(lm.coef1 < basic.model.coef1))
z2 = qnorm(mean(lm.coef2 < basic.model.coef2))
lm.coef1.jack = numeric(n)
lm.coef2.jack = numeric(n)
# JackKnife results
for (i in 1:n){
  model = lm(Hwt[-i]~Bwt[-i], data = cats)
  model.coefs = model$coefficients
  lm.coef1.jack[i] = model.coefs[1]
  lm.coef2.jack[i] = model.coefs[2]
}
# deviation
coef1.jack.dev = mean(lm.coef1.jack) - lm.coef1.jack
coef2.jack.dev = mean(lm.coef2.jack) - lm.coef2.jack
a1 = sum(coef1.jack.dev^3)/6/sum(coef1.jack.dev^2)^1.5
a2 = sum(coef2.jack.dev^3)/6/sum(coef2.jack.dev^2)^1.5
a11 = pnorm(z1 + (z1+qnorm(0.025))/(1-a1*(z1+qnorm(0.025))))
a12 = pnorm(z1 + (z1+qnorm(0.975))/(1-a1*(z1+qnorm(0.975))))
a21 = pnorm(z2 + (z2+qnorm(0.025))/(1-a2*(z2+qnorm(0.025))))
a22 = pnorm(z2 + (z2+qnorm(0.975))/(1-a2*(z2+qnorm(0.975))))
# 4a. Bca confidence interval for the first coefficient (Intercept)
quantile(lm.coef1,c(a11,a12))
# 4b. Bca confidence interval fot the second coefficient
quantile(lm.coef2,c(a21,a22))


##-------------------------------------------------------
##------------------- Using Boot Package ----------------
##-------------------------------------------------------
library(boot) # load boot package
#----------------------- Intercept ----------------------
# the function which is prepared for boot.ci function
lm.coef1.est = function(cats, id){
  cats.samples = cats[id,]
  model = lm(Hwt~Bwt, data = cats.samples)
  model.coefs = model$coefficients
  return(model.coefs[1]) # Intercept
}
# boot.obj for coef1
lm.coef1.obj = boot(cats,lm.coef1.est, B)
# type = "all" means all kinds of confidence intervals
boot.ci(lm.coef1.obj,conf = 0.975, type = "norm")
boot.ci(lm.coef1.obj,conf = 0.975, type = "basic")
boot.ci(lm.coef1.obj,conf = 0.975, type = "perc")
boot.ci(lm.coef1.obj,conf = 0.975, type = "bca")

#------------------- the second coefficient -------------
lm.coef2.est = function(cats, id){
  cats.samples = cats[id,]
  model = lm(Hwt~Bwt, data = cats.samples)
  model.coefs = model$coefficients
  return(model.coefs[2])
}
# boot.obj for coef2
lm.coef2.obj = boot(cats,lm.coef2.est, B)
# type = "all" means all kinds of confidence intervals
boot.ci(lm.coef2.obj, conf = 0.975, type = "norm")
boot.ci(lm.coef2.obj, conf = 0.975, type = "basic")
boot.ci(lm.coef2.obj, conf = 0.975, type = "perc")
boot.ci(lm.coef2.obj, conf = 0.975, type = "bca")
