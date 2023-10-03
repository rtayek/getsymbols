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
                log_error(sprintf("error: %s", e$message))
                return(e)
            },
            warning = function(w) {
                log_warn(sprintf("warning %s: ", w$message))
                return(w)
            },
            finally = {
                # what gets returned here?
            }
        )
        #print(sprintf("in getSymbol(): result: %s",class(result)))
        return(result)
    }
getGoodSymbols <- function(symbols, max, buy) {
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
        row <- symbols[i, ]
        symbol <- row$Ticker
        if (!is.null(symbol)) {
            ts <- getSymbol(symbol, from, to) # xts zoo time series
            #print(sprintf("index: %d, ts: %s",i,class(ts)))
            if ("xts" %in% class(ts)) {
                print(sprintf("index: %d, symbol: %s", i, symbol))
                good <- good + 1
                df[nrow(df) + 1,] <- row # add good row
                x <- as.data.frame(ts) # why do i need this?
                prices <- x[, 4] # closing price
                l <-
                    run(symbol, prices, buy) # run with strategy buy
                line <- l[[2]]
                bankroll <- rbind(bankroll, line)
            } else {
                if ("error" %in% class(ts)) {
                    print(ts$message)
                    "Unable to import"
                    if (grepl("HTTP error 429", ts$message)) {
                        stop()
                    } else {
                        print("some other kind of error")
                    }
                    print(sprintf(
                        "index: %d, symbol: %s, has error or warning!",
                        i,
                        symbol
                    ))
                    log_warn(sprintf(
                        "index: %d, symbol: %s, has error or warning!",
                        i,
                        symbol
                    ))
                    
                }
            }
            
        } else {
            print("symbol is null!")
            log_warn(sprintf("index: %d, symbol: NULL", i))
            
        }
        period = 100
        if (i > 0 && i %% period == 0) {
            print("sleep")
            Sys.sleep(.01)
        }
        if (i > max)
            break
    }
    rate <- good / n
    print(sprintf("good: %d, processed: %d, rate: %7.3f", good, n, rate))
    return(list(df, bankroll))
}
dtrt <- function(symbols, csvFile, bankrollFile, max) {
    rows <- nrow(symbols)
    l <- getGoodSymbols(symbols, max, buy2)
    good <- l[[1]]
    print(sprintf("good data frame has %d rows.", nrow(good)))
    log_info(sprintf("good data frame has %d rows.", nrow(good)))
    bankroll <- l[[2]]
    print(sprintf("bankroll data frame has %d rows.",
                  nrow(bankroll)))
    log_info(sprintf("bankroll data frame has %d rows.",
                     nrow(bankroll)))
    write.csv(l[[1]], file = csvFile, row.names = FALSE)
    sorted <- bankroll[order(-bankroll$bankroll),]
    sorted <- format(sorted, digits = 3)
    write.csv(sorted, file = bankrollFile, row.names = FALSE)
    print("exit dtrt")
    return(l)
}
#log_threshold()
max <- 5000
p <- file.path("D:", "data", "yahoodata", fsep = "\\")
if (F) {
    logFile <- "big.log"
    file.remove(logFile)
    log_appender(appender_file(logFile))
    filename <- file.path(p, "yahoosymbols.csv", fsep = "\\")
    symbols <- read.csv(filename)
    rows <- nrow(symbols)
    print(sprintf("%5s has %d rows.", filename, rows))
    log_info(sprintf("%5s has %d rows.", filename, rows))
    dtrt(symbols, "big.csv", " bankroll.csv", max)
    stop()
}

s <- 0:212
s <- 192:212

splits <- sprintf("%03d", s)
logFiles <- paste(file.path("data", "log.",  fsep = "\\"),
                  splits, ".log", sep = "")
inputFiles <-
    paste(file.path(p, "split.", fsep = "\\"), splits, ".csv", sep = "")
goodFiles <- paste(file.path("data", "good.",  fsep = "\\"),
                   splits, ".csv", sep = "")
bankrollFiles <-
    paste(file.path("data", "bankroll.",  fsep = "\\"),
          splits, ".csv", sep = "")
for (i in 1:length(s)) {
    file.remove(logFiles[i])
    log_appender(appender_file(logFiles[i]))
    log_info("start.")
    
    filename <- inputFiles[i]
    print(
        sprintf(
            "filename: %s, %s, %s. %s",
            filename,
            goodFiles[i],
            bankrollFiles[i],
            logFiles[i]
        )
    )
    #qlog_info(sprintf("filename: %s", filename))
    symbols <- read.csv(filename)
    rows <- nrow(symbols)
    print(sprintf("%5s has %d rows.", filename, rows))
    log_info(sprintf("%5s has %d rows.", filename, rows))
    dtrt(symbols, goodFiles[i], bankrollFiles[i], max)
    print(sprintf("%5s had %d rows.", filename, rows))
    Sys.sleep(200)
    
}
log_info("end.")
