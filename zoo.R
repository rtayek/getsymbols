library(quantmod)
from<-"2016-01-01" # leap year
to<-"2017-01-01"
symbol<-"AAPL"
getSymbols(symbol,from=from,to=to)
class(AAPL)
write.zoo(AAPL,file="newapple.txt",sep=",")
x<-read.zoo("newapple.txt")
class(x)
x<-as.xts(x,RECLASS=TRUE) # has errors
# write.zoo(x,file="newerapple.txt",sep=",") # crashes


