library(quantmod)
from=Sys.Date()-365
to=Sys.Date()
readOne<-function(filename) {
    symbols<-read.csv(filename)
    print(nrow(symbols))
    if(nrow(symbols)==0) {
        print("0 rows!")
        return(0)
    }
    for(i in 1:nrow(symbols)) {
        row<-symbols[i,]
        symbol<-row[[1]]
        if(n>5) break
        tryCatch(
            expr = {
                getSymbols(symbol,src="yahoo",from=from,to=to)
                good=good+1
                print(sprintf("good: %s %d %d",symbol,good,n))
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
    print(sprintf("%d %d",good,n))
    print("df")
    print(df)
    outputFile<-paste("out.",filename,sep="")
    write.csv(df,file=outputFile)
    newDf<-read.csv(outputFile)
    print(names(symbols))
    print(names(df))
    print(nrow(df))
    print(names(newDf))
    print(nrow(newDf))
    print(df==newDf)
}
readOne("ystocks00.csv")

