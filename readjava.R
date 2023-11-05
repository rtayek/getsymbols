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
unique<-y[0,] # gasther unique symbols
for(i in 1:nrow(j)) {
    ticker<-j$ticker[i]
    ticker<-trimws(ticker)
    #print(sprintf("ticker: '%s'",ticker))
    w<-which(y$Ticker==ticker)
    if(length(w)==0) {
        print("length is 0")
        next
    }
    stock<-y[w,]
    df[nrow(df) + 1, ] <- stock
    #print(sprintf("which: '%s'",w))
    dup<-which(unique$Ticker==ticker) # unique?
    #print(sprintf("unique: '%s'",any(dup)))
    #print(dup)
    if(!any(dup)) {
        print(sprintf("adding : '%s'",ticker))
        unique[nrow(unique) + 1, ] <- stock
    }
    #print(stock)
}
nrow(df)
nrow(unique)
head(unique)
sorted<-unique[order(unique$Exchange,unique$Ticker),]
head(sorted)
write.csv(sorted,file="someunique.csv", row.names = FALSE)




