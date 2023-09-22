library(quantmod)
from <- "2016-01-01" # leap year
to <- "2017-01-01"
symbol <- "AAPL"
getSymbols(symbol, from=from, to=to)
class(AAPL)
file1="answer2.txt"
write.zoo(AAPL, file=file1, row.names=TRUE)
x <- read.zoo(file1)
class(x)
nrow(x)
y<-as.xts(x, RECLASS=TRUE)
class(y)
nrow(y)
file2="answer2again.txt"
write.zoo(y, file=file2, row.names=TRUE)
