rm(list = ls())
# this is old. working on a new version.
# no, working here for now.
# return a list of stocks that we have prices for.
# try and get prices for the ones we don not have.
source("get0.R")
getPrices<-function(y,outputDir) {
    df <- y[0,] # copy header
    from <- "2018-01-01"
    to <- "2023-01-01"
    n <- nrow(y)
    found <- 0
    notFound <- 0
    ok <- 0
    bad <- 0
    n429<-0
    for (i in 1:n) {
        #if(i==1) next
        if(i>5) break
        #print(sprintf("top of main for loop: index: %d.",i))
        print(ok)
        symbol <- y$Ticker[i]
        if (!is.null(symbol)) { 
            outputFile<-paste(file.path(outputDir,symbol,fsep = "\\"),".csv",sep = "")
            # output dir d:\\ray\\rapps\\getSymbols\\data\\prices exists."
            #print(outputFile)
            if (file.exists(outputFile)) {
                found <- found + 1
                print(sprintf("symbol: %s has file: %s", symbol, outputFile))
                df[nrow(df) + 1,] <- y[i,] #
            } else {
                notFound <- notFound + 1
                print(sprintf("symbol: %s has no file: %s", symbol, outputFile))
                done <- FALSE
                count <- 0
                sleepTime<-1 # how to reset this
                while (!done) {
                    #ts <- getSymbol(symbol, from = from, to = to) # xts zoo time series
                    ts <- getSymbol(symbol) # xts zoo time series
                    #print(sprintf("index: %d, ts: %s",i,class(ts)))
                    if ("xts" %in% class(ts)) {
                        write.zoo(ts, outputFile, sep = ",")
                        #stop()
                        done <- TRUE
                        print(sprintf("index: %d, symbol: %s is a xts", i, symbol))
                        print(nrow(ts))
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
    return(df)
}
once <- FALSE
y <- getYahooStocks()

outputDir<-file.path("d:", "ray", "rapps", "getSymbols", "data", "prices2" , fsep = "\\")
if (file.exists(outputDir)) {
    print(sprintf("output dir %s exists.", outputDir))
} else {
    print(sprintf("output dir %s does not exists!", outputDir))
}
df<-getPrices(y,outputDir)
head(df)
tail(df)
