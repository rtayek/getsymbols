require(quantmod)
rm(list = ls())
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
            #print(e)
            print("error, retunring NULL")
            return(NULL)
        },
        warning = function(w) {
            #print(w)
            print("warning, retunring NULL")
            return(NULL)
        },
        finally = {
            # what gets returned here?
        }
    )
    return(result)
}
myGetSymbols <- function(filename) {
    symbols <- read.csv(filename)
    n<-nrow(symbols)
    print(sprintf("%5s has %d rows.", filename, n))
    good<-0
    for (i in 1:n) {
        row <- symbols[i, ]
        symbol <- row$Ticker
        print(sprintf("index: %d, symbol: %s", i, symbol))
        #getSymbol(symbol,from,to)
        ts <- getSymbol(symbol)
        if(!is.null(ts)) good<-good+1
        #if (i > 10) break
    }
    print(sprintf("good: %d, total: %d, rate: %7.3f",good,n,good/n))
}
f<-function(symbol) {
    x<-getSymbol(symbol)
    if(is.null(x)) print("is null!")
    return(x)
}
#x<-getSymbol("AAPL")
#x<-getSymbol("swksk9")
#x <- f("AAPL")
#x<- f("sdyqsduyqgg")
system.time(
    myGetSymbols("ystocks00.csv")
)

