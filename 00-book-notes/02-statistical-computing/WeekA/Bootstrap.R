# install.packages("bootstrap")
# install.packages("boot")
library(bootstrap)
data(law)
data(law82)
cor.hat = cor(law$LSAT,law$GPA)
cor.true = cor(law82$LSAT,law82$GPA)

## Bootstrap using the data in bootstrap package
n = nrow(law)
B = 200
cor.boot = numeric(B)
for (b in 1:B){
  id = sample(1:n, n, replace = T)
  cor.boot[b] = cor(law$LSAT[id],law$GPA[id])
}
hist(cor.boot)
sd(cor.boot)

# Bootstrap using boot function in boot package
library(boot)
cor.est = function(data, id){
  return(cor(data$LSAT[id],data$GPA[id]))
}
boot.res = boot(law, cor.est, B)
boot.res

# bias
mean(cor.boot) - cor.hat

#----------------------------------------
data("patch")
n = nrow(patch)
B = 200
ratio.hat = mean(patch$y)/mean(patch$z)
ratio.boot = numeric(B)
for(b in 1:B){
  id = sample(1:n, n, replace = T)
  ratio.boot[b] = mean(patch$y[id])/mean(patch$z[id])
}
bias = mean(ratio.boot) - ratio.hat
# Bootstrap using boot function in boot package
library(boot)
ratio.est = function(data, id){
  return(mean(data$y[id])/mean(data$z[id]))
}
ratio.res = boot(patch,ratio.est, B)
ratio.res

# normal confidence interval
ratio.hat - qnorm(0.975)*sd(ratio.boot)
ratio.hat + qnorm(0.975)*sd(ratio.boot)
# 
2*ratio.hat - quantile(ratio.boot,c(0.975,0.025))
quantile(ratio.boot,c(0.025,0.975))

boot.ci(ratio.res,type = "norm")

#---------------------------------------------------------
z0 = qnorm(mean(ratio.boot < ratio.hat))
ratio.jack = numeric(n)
for (i in 1:n){
  ratio.jack[i] = mean(patch$y[-i])/mean(patch$z[-i])
}
jack.dev = mean(ratio.jack) - ratio.jack
a = sum(jack.dev^3)/6/sum(jack.dev^2)^1.5
a1 = pnorm(z0 + (z0+qnorm(0.025))/(1-a*(z0+qnorm(0.025))))
a2 = pnorm(z0 + (z0+qnorm(0.975))/(1-a*(z0+qnorm(0.975))))
quantile(ratio.boot,c(a1,a2))

boot.ci(ratio.res,type = "bca")