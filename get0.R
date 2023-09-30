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
                return(NULL)
            },
            warning = function(w) {
                log_warn(sprintf("warning: ", w$message))
                return(NULL)
            },
            finally = {
                # what gets returned here?
            }
        )
        return(result)
    }
getGoodSymbols <- function(symbols, max, buy) {
    rows <- nrow(symbols)
    from = "2022-01-01" # getting less data is faster
    to = "2023-01-01"
    df <- symbols[0, ] # copy cvs header
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
        row <- symbols[i,]
        symbol <- row$Ticker
        if (!is.null(symbol)) {
            print(sprintf("index: %d, symbol: %s", i, symbol))
            ts <- getSymbol(symbol, from, to) # xts zoo time series
            if (!is.null(ts)) {
                good <- good + 1
                df[nrow(df) + 1, ] <- row # add good row
                # add function or switch to run?
                # doig both now
                x <- as.data.frame(ts) # why do i need this?
                prices <- x[, 4]
                l <- run(symbol, prices, buy) # run with strategy
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
        period = 10
        if (i > 0 && i %% period == 0) {
            print("sleep")
            Sys.sleep(1)
        }
        
        if (i > max)
            break
    }
    rate <- good / n
    print(sprintf("good: %d, processed: %d, rate: %7.3f", good, n, rate))
    return(list(df, bankroll))
}
dtrt <- function(filename, csvFile, bankrollFile, max) {
    symbols <- read.csv(filename)
    rows <- nrow(symbols)
    print(sprintf("%5s has %d rows.", filename, rows))
    log_info(sprintf("%5s has %d rows.", filename, rows))
    l <- getGoodSymbols(symbols, max, buy2)
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
    write.csv(l[[1]], file = csvFile, row.names = FALSE)
    sorted <- bankroll[order(-bankroll$bankroll), ]
    sorted <- format(sorted, digits = 3)
    write.csv(sorted, file = bankrollFile, row.names = FALSE)
    print("exit dtrt")
    return(l)
}
#log_threshold()
s <- 0:10
s <- 4:4
splits <- sprintf("%02d", s)
logFiles <- paste("ystocks", splits, ".log", sep = "")
inputFiles <- paste("ystocks", splits, ".csv", sep = "")
goodFiles <- paste("good.ystocks", splits, ".csv", sep = "")
BankrollFiles <- paste("bankroll.ystocks", splits, ".csv", sep = "")
logFile <- "1.log"
max <- 10
for (i in 1:length(s)) {
    file.remove(logFiles[i])
    log_appender(appender_file(logFiles[i]))
    log_info("start.")
    
    filename <- inputFiles[i]
    print(sprintf("filename: %s, %s, %s. %s", filename, goodFiles[i], BankrollFiles[i],logFiles[i]))
    #qlog_info(sprintf("filename: %s", filename))
    dtrt(filename, goodFiles[i], BankrollFiles[i], max)
    Sys.sleep(1)
    
}
log_info("end.")
