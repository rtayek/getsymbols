rm(list = ls())
# this is old. working on a new version.
# no, working here for now.
# return a list of stocks that we have prices for.
# try and get prices for the ones we don not have.
# seems to be working. may require about 40 gb.
# ao maybe move to /e/data/stock.
# 11/28/23 moving to new pc.
# this reads a big list of stocks (100k) from a .csv file.
# 12/4/23 adding missing.csv from java plays.
# try to read this and get price data instead of reading the big yahoo file.
# got this to read the big list on the new pc.
# ...
source("get0.R")
getPrices<-function(y,outputDir,not429s,start=1,stop=nrow(y)) {
    if(is.null(not429s)) not429s <- y[0,] # copy header. should not happen
    newNot429s<- y[0,] # copy header
    from <- "2018-01-01"
    to <- "2023-01-01"
    found <- 0
    notFound <- 0
    ok <- 0
    bad <- 0 # errors and  warnings?
    n429<-0
    for (i in start:stop) {
        if(i==1) next
        #if(i>20) break
        #print(sprintf("top of main for loop: index: %d.",i))
        #print(sprintf("index %d, %d found, %d not found, %d ok, %d bad",i, found,notFound,ok,bad))
        symbol <- y$Ticker[i]
        if (!is.null(symbol)) { 
            outputFile<-paste(file.path(outputDir,symbol,fsep = "\\"),".csv",sep = "")
            # output dir d:\\ray\\rapps\\getSymbols\\data\\prices exists."
            #print(outputFile)
            if (file.exists(outputFile)) {
                found <- found + 1
                #print(sprintf("symbol: %s has file: %s", symbol, outputFile))
            } else {
                notFound <- notFound + 1
                print(sprintf("symbol: %s has no file: %s", symbol, outputFile))
                if(symbol %in% not429s$Ticker) {
                    print(sprintf("skip symbol: %s is not429's", symbol))
                    next;
                }
                done <- FALSE
                count <- 0
                sleepTime<-1 # how to reset this
                while (!done) {
                    #ts <- getSymbol(symbol, from = from, to = to) # xts zoo time series
                    ts <- getSymbol(symbol) # xts zoo time series
                    # print(sprintf("index: %d, ts: %s",i,class(ts))) # prints many lines
                    if ("xts" %in% class(ts)) {
                        write.zoo(ts, outputFile, sep = ",")
                        #stop()
                        done <- TRUE
                        print(sprintf("1 index: %d, symbol: %s is a xts", i, symbol))
                        print(nrow(ts))
                        ok <- ok + 1
                        if(count>0)
                            print(sprintf("index: %d, symbol: %s recovered ok", i, symbol))
                        #df[nrow(df) + 1, ] <- row # add good row
                        #x <- as.data.frame(ts) # why do i need this?
                    } else if ("error" %in% class(ts)) {
                        bad <- bad + 1
                        # "Unable to import"
                        if (grepl("HTTP error 429", ts$message)) {
                            #print(ts$message)
                            if (count == 0)
                                n429 <- n429 + 1 # only count as 1 occurrence
                            #sleepTime<-2*sleepTime
                            print(sprintf("start sleep for %f seconds", sleepTime))
                            Sys.sleep(sleepTime)
                            print(sprintf("end sleep for %f seconds", sleepTime))
                            count <- count + 1
                            if (count > 3) {
                                done <- TRUE
                                print(sprintf("stopping sleep backoff"))
                            }
                            #stop()
                        } else {
                            # not a 429
                            done <- TRUE
                            newNot429s[nrow(newNot429s) + 1, ] <-  y[i, ] # save errors
                            # print("some other kind of error")
                            if (count > 0)
                                print(sprintf("index: %d, symbol: %s recovered other", i, symbol))
                            print(sprintf("2 index: %d, symbol: %s, has error that is not a 429!", i, symbol))
                            log_warn(sprintf("index: %d, symbol: %s, has error that is not a 429!", i, symbol))
                        }
                        
                    }  else if ("warning" %in% class(ts)) {
                        bad <- bad + 1
                        print(sprintf("class: %s", class(ts)))
                        print(str(ts))
                        done <- TRUE
                        newNot429s[nrow(newNot429s) + 1, ] <-  y[i, ] # save warnings
                        print(sprintf("3 index: %d, symbol: %s, has other or warning!", i, symbol))
                        log_warn(sprintf("index: %d, symbol: %s, has other or warning!", i, symbol))
                        #print(ts$message)
                        if (count > 0)
                            print(sprintf("index: %d, symbol: %s recovered warning", i, symbol))
                    } else {
                        print("badness")
                        stop()
                    }
                    if(count>0)
                        print(sprintf("bottom of while: index: %d, count: %d, done: %d, n429's: %d.",i,count,done,n429))
                    if(n429>2) {
                        print("toomany 429's.")
                        print("stopping")
                        stop;
                    }
                    
                } # end of while(!done)
            } # end of not found
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
    return(newNot429s       )
}
logFile <- "readYahoo.log"
file.remove(logFile)
log_appender(appender_file(logFile))
once <- FALSE
dataFolder=file.path("c:","dfromrays8350", fsep = "\\")
if (file.exists(dataFolder)) {
    print(sprintf("output dir %s exists.", dataFolder))
} else {
    print(sprintf("output dir %s does not exists!", dataFolder))
}
y<-getYahooStocks(dataFolder) # works
print(sprintf("y has %s rows.", nrow(y)))
outputDir<-file.path("c:", "data", fsep = "\\")
if (file.exists(outputDir)) {
    print(sprintf("output dir %s exists.", outputDir))
} else {
    print(sprintf("output dir %s does not exists!", outputDir))
}
not429sFilename<-"not429s.csv"
not429s<- y[0,] # copy header
if(FALSE) # do not read it in now.
if(file.exists(not429sFilename)) {
    not429s<-read.csv(not429sFilename)
}
# 8850 prices now
nrow(not429s) 
# [1] "index 94372, 0 found, 33 not found, 8 ok, 25 bad"
# [1] "symbol: COM7.BK has no file: e:\\data\\COM7.BK.csv

df<-getPrices(y,outputDir,not429s,start=1,stop=100)
print(sprintf("new not249s: %d",nrow(df)))
# stop here!
stop()
if(FALSE)
if(nrow(df)>1) {
    not429s <- rbind(not429s, df)
    #file.copy(from = not429sFilename, to = "not429s.bak",overwrite = TRUE)
    #write.csv(not429s,file="not429s.csv", row.names = FALSE)
    last<-not429s$Ticker[nrow(not429s)] 
    newStart<-which(y$Ticker==last)+1
    print(sprintf("new start: %d",newStart))
}
head(df)
tail(df)
