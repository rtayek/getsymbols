rm(list = ls())
require(quantmod)
source("strategy.R")
#source("get0.R")
source("play3.R")
getSymbol <- function(symbol, from = "1990-01-01", to = Sys.time()) {
    result <- tryCatch(
        expr = {
            return(getSymbols(
                symbol,
                src = "yahoo",
                from = from,
                to = to,
                env = NULL
            ))
        },
        error = function(e) {
            print(e)
            print("error, retunring NULL")
            return(NULL)
        },
        warning = function(w) {
            print(w)
            print("warning, retunring NULL")
            return(NULL)
        },
        finally = {
            # what gets returned here?
        }
    )
    return(result)
}
getGoodSymbols <- function(symbols) {
    rows<-nrow(symbols)
    from="2022-01-01" # getting less data is faster
    to="2023-01-01"
    df<-symbols[0,] # copy cvs header
    bankroll<-data.frame(
        symbol=character(),
        bankroll=numeric(),
        winRate=numeric(),
        buyRate=numeric(),        
        stringsAsFactors = F)
    good<-0
    n<-0
    for (i in 1:rows) {
        row <- symbols[i, ]
        symbol <- row$Ticker
        print(sprintf("index: %d, symbol: %s", i, symbol))
        ts <- getSymbol(symbol,from,to) # xts zoo time series
        n<-n+1
        if(!is.null(ts)) {
            good<-good+1
            df[nrow(df)+1,]<-row # add good row
            # add function or switch to run?
            # doig both now
            x <- as.data.frame(ts) # why do i need this?
            prices <- x[, 4]
            l<-run(symbol, prices, buy1) # run with strategy
            line<-l[[2]]
            bankroll<-rbind(bankroll,line)
        }
        if (i > 10) break
    }
    print(sprintf("good: %d, total: %d, rate: %7.3f",good,rows,good/n))
    return(list(df,bankroll))
}
dtrt<-function() {
    filename <- "ystocks02.csv"
    symbols <- read.csv(filename)
    rows<-nrow(symbols)
    print(sprintf("%5s has %d rows.", filename, rows))
    l<-getGoodSymbols(symbols)
    write.csv(l[[1]],file="good.csv",row.names=FALSE)
    bankroll<-l[[2]]
    sorted<- bankroll[order(-bankroll$bankroll),]
    sorted<-format(sorted, digits=3)
    write.csv(sorted,file="bankroll.csv",row.names=FALSE)
    return(l)
}
system.time(dtrt())

