# this broke for some unknown reason.
# switching to use get0 instead

# get a list of stocks that we can get some data from yahoo.
# then write a .csv file with those stocks.
# using ystocks00.csv to make out.ystocks00.csv
#
require(quantmod)
from<-Sys.Date()-365
to<-Sys.Date()
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
    stopAt<-1000 # slow, each ystocks file has 10k lines!
    for(i in 1:nrow(symbols)) {
        print(i)
        row<-symbols[i,]
        symbol<-row$Ticker
        print(symbol)
        if(n>stopAt) break
        result<-tryCatch(
            expr = {
                data<-getSymbols(symbol,src="yahoo",from=from,to=to,env=NULL)
                print("returning data")
                return(data)
            },
            error = function(e){ 
                print("caught:")
                print(e)
                return(NA)
            },
            warning = function(w){
                print("warning:",w)
                retunr(NA)
            },
            finally = {
                #
            }
        )
        print("result 1")
        print(result)
        if (!is.na(result)) {
            print("result")
            print(class(result))
            good=good+1
            print(sprintf("good: %15s %d %d",symbol,good,n))
            df[nrow(df)+1,]<-row
        } else print("bandess")
        n <- n + 1
        print("eol")
    }
    print(sprintf("%d good out of %d",good,n))
    print("df")
    print(df)
    outputFile<-paste("xout.",filename,sep="")
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
#readOne("out.ystocks00.csv") # eat our own dog food.



