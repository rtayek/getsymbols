rm(list = ls())
require(logger)
require(quantmod)
source("strategy.R")
#source("get0.R")
source("play3.R")
getSymbol <-
    function(symbol, from = "1990-01-01", to = Sys.time()) {
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
                log_error(sprintf("error: %s",e$message))
                return(NULL)
            },
            warning = function(w) {
                log_warn(sprintf("warning: ",w$message))
                return(NULL)
            },
            finally = {
                # what gets returned here?
            }
        )
        return(result)
    }
getGoodSymbols <- function(symbols, max) {
    rows <- nrow(symbols)
    from = "2022-01-01" # getting less data is faster
    to = "2023-01-01"
    df <- symbols[0,] # copy cvs header
    bankroll <- data.frame(
        symbol = character(),
        bankroll = numeric(),
        winRate = numeric(),
        buyRate = numeric(),
        stringsAsFactors = F
    )
    good <- 0
    n <- 0
    for (i in 1:rows) {
        n <- n + 1
        print(sprintf("index: %d", i))
        log_info(sprintf("index: %d", i))
        row <- symbols[i, ]
        symbol <- row$Ticker
        if (!is.null(symbol)) {
            print(sprintf("index: %d, symbol: %s", i, symbol))
            ts <- getSymbol(symbol, from, to) # xts zoo time series
            if (!is.null(ts)) {
                good <- good + 1
                df[nrow(df) + 1,] <- row # add good row
                # add function or switch to run?
                # doig both now
                x <- as.data.frame(ts) # why do i need this?
                prices <- x[, 4]
                l <- run(symbol, prices, buy1) # run with strategy
                line <- l[[2]]
                bankroll <- rbind(bankroll, line)
            } else {
                print("time series is null!")
                log_warn("time series is null!")
            }
            
        } else {
            print("symbol is null!")
            log_warn("symbol is null!")
        }
        
        
        if (i > max)
            break
    }
    rate<-good/n
    print(sprintf("good: %d, processed: %d, rate: %7.3f", good, n, rate))
    return(list(df, bankroll))
}
dtrt <- function(filename) {
    max <- 10
    symbols <- read.csv(filename)
    rows <- nrow(symbols)
    print(sprintf("%5s has %d rows.", filename, rows))
    log_info(sprintf("%5s has %d rows.", filename, rows))
    l <- getGoodSymbols(symbols, max)
    good <- l[[1]]
    print(sprintf("good data frame for %s has %d rows.", filename, nrow(good)))
    log_info(sprintf("good data frame for %s has %d rows.", filename, nrow(good)))
    bankroll <- l[[2]]
    print(sprintf(
        "bankroll data frame for %s has %d rows.",
        filename,
        nrow(bankroll)
    ))
    log_info(sprintf(
        "bankroll data frame for %s has %d rows.",
        filename,
        nrow(bankroll)
    ))
    #write.csv(l[[1]],file="good.csv",row.names=FALSE)
    sorted <- bankroll[order(-bankroll$bankroll),]
    sorted <- format(sorted, digits = 3)
    #write.csv(sorted,file="bankroll.csv",row.names=FALSE)
    print("exit dtrt")
    return(l)
}
#log_threshold()
files = c(
    "ystocks00.csv",
    "ystocks01.csv",
    "ystocks02.csv",
    "ystocks03.csv",
    "ystocks04.csv",
    "ystocks05.csv",
    "ystocks06.csv",
    "ystocks07.csv",
    "ystocks08.csv",
    "ystocks09.csv",
    "ystocks10.csv"
)
logFile <- "1.log"
file.remove(logFile)
log_appender(appender_file(logFile))
log_info("start.")
if (F) {
    l <- dtrt("ystocks03.csv")
    print(class(l[[1]]))
    print(class(l[[2]]))
    
} else {
    for (filename in files) {
        print(sprintf("filename: %s", filename))
        #qlog_info(sprintf("filename: %s", filename))
        system.time(dtrt(filename))
        Sys.sleep(1)
    }
    
}
log_info("end.")
