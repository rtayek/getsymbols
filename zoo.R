library(xts)
ts <- xts(x = rnorm(n = 3),
           order.by = seq(as.Date("2016-01-01"), 
                          length = 3,
                          by = "days"))
print(ts)
class(ts)
write.zoo(ts, file="x.xts")
cat(paste0(readLines("x.xts"), collapse="\n"))
x <- read.zoo("x.xts")
x

write.zoo(ts, file="xrn.xts", row.names=TRUE)
cat(paste0(readLines("xrn.xts"), collapse="\n"))
xrn <- read.zoo("xrn.xts")
xrn
