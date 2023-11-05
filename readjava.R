rm(list = ls())
source("get0.R")
getJava <- function() {
    file <- file.path("d:", "ray", "stockApps", "play", "newbuyall.csv",  fsep = "\\")
    j <- read.csv(file)
    return(j)
}
y <- getYahooStocks()
j<-getJava()
df<-y[0,]
stocks<-y[0,] # gasther unique symbols
for(i in 1:5) {
    print("------------")
    ticker<-j$ticker[i]
    ticker<-trimws(ticker)
    print(sprintf("ticker: '%s'",ticker))
    w<-which(y$Ticker==ticker)
    if(length(w)==0) {
        print("length is 0")
        next
    }
    stock<-y[w,]
    df[nrow(df) + 1, ] <- stock
    #print(sprintf("which: '%s'",w))
    dup<-which(stocks$Ticker==ticker) # unique?
    print(sprintf("unique: '%s'",any(dup)))
    print(dup)
    if(!any(dup)) {
        stocks[nrow(stocks) + 1, ] <- stock
    }
    #print(stock)
}
nrow(df)
nrow(stocks)



