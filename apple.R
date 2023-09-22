# https://stackoverflow.com/questions/69563021/how-do-you-convert-r-models-to-raw-binary-or-string-buffer
# https://stackoverflow.com/a/69579689/51292
library(quantmod)
from<-Sys.Date()-365
library(quantmod)
from <- "2016-01-01" # leap year
to <- "2017-01-01"
symbol <- "AAPL"
getSymbols(symbol, from=from, to=to)
#[1] "AAPL"
class(AAPL)
#"xts" "zoo"
write.zoo(AAPL, file="newapple.txt")

