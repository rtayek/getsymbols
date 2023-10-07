library(quantmod)
from <- "2016-01-01" # leap year
to <- "2017-01-01"
to <- "2016-01-7"
symbol <- "AAPL"
getSymbols(symbol, from=from, to=to)
a<-"a.xts"
write.zoo(AAPL, file=a,sep=",")
cat(paste0(readLines(a), collapse="\n"))
x <- read.zoo(a)
x

arn<-"arn.xts"
write.zoo(AAPL, file=arn, row.names=TRUE)
cat(paste0(readLines(arn), collapse="\n"))
xrn<-read.zoo(arn)
xrn

#x<-as.xts(x, RECLASS=TRUE)
file2<-"answer2again.txt"
write.zoo(y, file=file2)
