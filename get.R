# get a list of stocks that we can get 1 years worth of data from yahoo.
# the write a file file a list of those stocks.
library(quantmod)
from=Sys.Date()-365
to=Sys.Date()
#symbols<-read.csv("d:\\data\\yahoosymbols.csv")
readOne<-function(filename) {
    symbols<-read.csv(filename)
    print(nrow(symbols))
    if(nrow(symbols)==0) {
        print("0 rows!")
        return(0)
    }
    print(sprintf("%5s has %d rows.",filename,nrow(symbols)))
    df<-symbols[0,]
    good<-0
    n<-0
    stopAt<-10
    for(i in 1:nrow(symbols)) {
        row<-symbols[i,]
        symbol<-row$Ticker
        if(n>stopAt) break
        tryCatch(
            expr = {
                getSymbols(symbol,src="yahoo",from=from,to=to)
                good=good+1
                #print(sprintf("good: %15s %d %d",symbol,good,n))
                df[nrow(df)+1,]<-row
            },
            error = function(e){ 
                #print("caught:",e)
            },
            warning = function(w){
                #print("warning:",w)
            },
            finally = {
                #
            }
        )
        n<-n+1
    }
    print(sprintf("%d good out of %d",good,n))
    print("df")
    print(df)
    outputFile<-paste("out.",filename,sep="")
    write.csv(df,file=outputFile,row.names=FALSE)
    if(F) {
        newDf<-read.csv(outputFile)
        print(names(symbols))
        print(names(df))
        print(nrow(df))
        print(names(newDf))
        print(nrow(newDf))
        print(df==newDf)
    }
}
readOne("ystocks00.csv")
print("-----------------------")
readOne("out.ystocks00.csv")

