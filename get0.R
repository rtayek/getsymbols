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
    rows<-nrow(symbols)
    print(sprintf("%5s has %d rows.", filename, rows))
    from="2022-01-01" # getting less data is faster
    to="2023-01-01"
    df<-symbols[0,] # copy cvs header
    good<-0
    n<-0
    for (i in 1:rows) {
        row <- symbols[i, ]
        symbol <- row$Ticker
        print(sprintf("index: %d, symbol: %s", i, symbol))
        ts <- getSymbol(symbol,from,to)
        n<-n+1
        if(!is.null(ts)) {
            good<-good+1
            df[nrow(df)+1,]<-row # add good row
        }
        if (i > 100) break
    }
    print(sprintf("good: %d, total: %d, rate: %7.3f",good,rows,good/n))
    return(df)
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
get<-function(filename) {
    system.time(
        df<-myGetSymbols(filename)
    )
    outputFile<-paste("newout.",filename,sep="")
    write.csv(df,file=outputFile,row.names=FALSE)
}
filename<-"ystocks00.csv"
get(filename)

