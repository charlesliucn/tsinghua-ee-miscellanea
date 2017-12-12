library(rJava)
.jinit() #
wd = getwd() # get the current dir
.jaddClassPath(wd) # set the dir
# Create EdgeWeightedDigraph Class
EWD = .jnew("EdgeWeightedDigraph","10000EWD.txt")
# Create DijkstraSP Class
DSP = .jnew("DijkstraSP",EWD,as.integer(0))
# call the method
arrayPath = J(DSP,"arrayPathTo", as.integer(6))
# call the method
dist = J(DSP,"distTo", as.integer(6))
# print the array path
print(arrayPath)
# print the distance
sprintf("0→6 distace: %f", dist)