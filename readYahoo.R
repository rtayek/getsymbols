rm(list = ls())
source("get0.R")
getYahooStocks <- function() {
    yahooFile <-
        file.path("d:", "data", "yahoodata", "yahoosymbols.csv",  fsep = "\\")
    y <- read.csv(yahooFile)
    return(y)
}
once <- FALSE
df <- NULL
y <- getYahooStocks()
print(sprintf("yahoo.csv has %d rows.", nrow(y)))
w3 <- which(nchar(y$Exchange) != 3)
print(sprintf("w3 has %d elements.", length(w3)))
w0 <- which(nchar(y$Exchange) == 0)
print(sprintf("w0 has %d elements.", length(w0)))
# looks like all of the exchanges are empty or have 3 characters.
names(y)
df <- y[0,]
outputDir<-file.path("d:", "ray", "rapps", "getSymbols", "data", "prices" , fsep = "\\")
if (file.exists(outputDir)) {
    print(sprintf("output dir %s exists.", outputDir))
} else {
    print(sprintf("output dir %s does not exists!", outputDir))
}
from <- "2018-01-01"
to <- "2023-01-01"
n <- nrow(y)
# 429 at index 2515
n <- 5000
found <- 0
notFound <- 0
ok <- 0
bad <- 0
n429<-0
for (i in 1:n) {
    if(i==1) next
    #print(sprintf("top of main for loop: index: %d.",i))
    symbol <- y$Ticker[i]
    if (!is.null(symbol)) { 
        outputFile<-paste(file.path(outputDir,symbol,fsep = "\\"),".csv",sep = "")
        # output dir d:\\ray\\rapps\\getSymbols\\data\\prices exists."
        #print(outputFile)
        if (file.exists(outputFile)) {
            found <- found + 1
            #print(sprintf("symbol: %s has file: %s", symbol, outputFile))
            df[nrow(df) + 1,] <- y[i,]
        } else {
            notFound <- notFound + 1
            #print(sprintf("symbol: %s has no file: %s", symbol, outputFile))
        }
        done <- FALSE
        count <- 0
        sleepTime<-2 # how to reset this
        while (!done) {
            ts <- getSymbol(symbol, from = from, to = to) # xts zoo time series
            #print(sprintf("index: %d, ts: %s",i,class(ts)))
            if ("xts" %in% class(ts)) {
                done <- TRUE
                #print(sprintf("index: %d, symbol: %s is a xts", i, symbol))
                ok <- ok + 1
                if(count>0)
                    print(sprintf("index: %d, symbol: %s recovered ok", i, symbol))
                #df[nrow(df) + 1, ] <- row # add good row
                #x <- as.data.frame(ts) # why do i need this?
            } else {
                bad <- bad + 1
                if ("error" %in% class(ts)) {
                    # "Unable to import"
                    if (grepl("HTTP error 429", ts$message)) {
                        print(ts$message)
                        if(count==0) n429<-n429+1 # only count as 1 occurrence
                        sleepTime<-2*sleepTime
                        print(sprintf("start sleep for %f seconds",sleepTime))
                        Sys.sleep(sleepTime)
                        print(sprintf("end sleep for %f seconds",sleepTime))
                        count <- count + 1
                        if (count > 3) {
                            done <- TRUE
                            print(sprintf("stopping sleep backoff"))
                        }
                        #stop()
                    } else {
                        done <- TRUE
                        # print("some other kind of error")
                        if(count>0)
                            print(sprintf("index: %d, symbol: %s recovered other", i, symbol))
                    }
                    print(sprintf("index: %d, symbol: %s, has error or warning!",i,symbol))
                    log_warn(sprintf("index: %d, symbol: %s, has error or warning!",i,symbol))
                    
                } else { # warning?
                    done <- TRUE
                    print(sprintf("index: %d, symbol: %s, has other error or warning!",i,symbol))
                    print(ts$message)
                    log_warn(sprintf("index: %d, symbol: %s, has other error or warning!",i,symbol))
                    if(count>0)
                        print(sprintf("index: %d, symbol: %s recovered warning", i, symbol))
                }
            }
            if(count>0)
                print(sprintf("bottom of while: index: %d, count: %d, done: %d, n429's: %d.",i,count,done,n429))
            if(n429>2) {
                print("toomany 429's.")
                print("stopping")
                stop;
            }
            
        } # end of while(!done)
    } else {
        bad <- bad + 1
        print("symbol is null!")
    }
    #print(sprintf("bottom of main for loop: index: %d, count: %d, done: %d, n429's: %d.",i,count,done,n429))
    if(n429>2) {
        print("toomany 429's.")
        break;
    }
}
print(sprintf("%d found: ", found))
print(sprintf("%d not found: ", notFound))
print(sprintf("%d ok: ", ok))
print(sprintf("%d bad", bad))
head(df)
tail(df)
