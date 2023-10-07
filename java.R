# make the data files so java (and r) can just read them.
# reads the highest.csv file made from gather.R
# writes price data. 
# lots of errors if we try to get a lot of data
# let's try since 2010 - gets about 50% errors on the firs 100.
# 2015 gets 66%, 2018 gets 70%, 2018 gets 84%.
`#require(quantmod)
#rm(list = ls())
source("get0.R")
once <- FALSE
df <- NULL
from <- "2018-01-01"
to <- "2023-01-01"
inputFile <- file.path("data", "yahoohighest.csv",  fsep = "\\")
y <- read.csv(inputFile)
print(sprintf("%s had %d rows.", inputFile, nrow(y)))
n <- nrow(y)
#n<-100
bad<-0
for (i in 1:n) {
    symbol <- y$Ticker[i]
    print(sprintf("index: %d, symbol: %s", i,symbol))
    # read the data and write to a .csv file.
    ts <- getSymbol(symbol,from=from,to=to) # xts zoo time series
    if ("xts" %in% class(ts)) {
        outputFile <- paste(file.path("data", "prices" , symbol, fsep = "\\"),
                            ".csv",
                            sep = "")
        print(outputFile)
        write.zoo(ts, file = outputFile, sep = ",")
        print(sprintf("%s has %d rows", symbol, nrow(ts)))
    } else {
        print(ts)
        bad<-bad+1
    }
}
print(sprintf("%d bad.",bad))
