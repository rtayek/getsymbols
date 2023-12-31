library(quantmod)
source("strategy.R")
buffer <- 5
forecast <- 3
initialBankroll <- 1.
bet <- 1. # ,25 seems to work
rake <- .0
verbosity <- 0
runOneStock <- function(symbol, prices, buy) {
    # one stock
    symnol <- symbol
    bankroll <<- initialBankroll
    boughtAt <- 0. # switch for buy and hold
    totalRake <- 0
    buys <- 0
    wins <- 0
    prologue <- function() {
        print(sprintf("br: %7.2f, bet: %5.2f, rake: %.2f",
                      bankroll,
                      bet,
                      rake))
    }
    header <- function() {
        return("name, bankroll, winRate, buyRate")
    }
    toCSVLine <- function() {
        sprintf("%s, %7.3f, %7.3f, %7.3f",
                symbol,
                bankroll,
                wins / buys,
                buys / length(prices))
    }
    toString <- function() {
        sprintf(
            "name: %s, bankroll: %7.3f,, winRate %7.3f, buyRate: %7.3f",
            symbol,
            bankroll,
            wins / buys,
            buys / length(prices)
        )
    }
    
    oneDay <- function(i, boughtAt) {
        sell <- function(amountBet) {
            #print(sprintf("in sell, amount bet: %7.3f",amountBet))
            current <- prices[i]
            #print(sprintf("in sell, current: %7.3f",current))
            #print(sprintf("in sell, bought at: %7.3f",boughtAt))
            change <- current - boughtAt
            #print(sprintf("in sell, change: %7.3f",change))
            if (change > 0)
                wins <<- wins + 1
            profit <- (current - boughtAt) / boughtAt # per share
            # hProfit().add(profit)
            delta <- amountBet * (1 + profit)
            previous <- bankroll
            if (TRUE)
                bankroll <<- bankroll + delta
            else
                bankroll <<-
                bankroll + amountBet # pretend no gain or loss.
            # this is just to keep the bankroll constant.
            if (verbosity > 0)
                print(
                    sprintf(
                        "pr br:%7.3f, change:%7.3f, delta: %6.3f, br: %7.3f",
                        previous,
                        change,
                        delta,
                        bankroll
                    )
                )
            #print(sprintf("end of sell, profit(b4): %6.3f, br %7.3f, bought at %6.3f, current %6.3f, $ %6.3f",
            #    profit,bankroll,boughtAt,current,current-boughtAt))
        } # end of sell()
        if (boughtAt == 0.) {
            # new buy?
            if (buy(i, prices)) {
                buys <<- buys + 1
                boughtAt <- prices[i - 1]
                #print(sprintf("bought at: %7.3f",boughtAt))
                betAmount <- bankroll * bet
                bankroll <<- bankroll - betAmount
                rakeAmount <- betAmount * rake
                betAmount <- betAmount - rakeAmount
                totalRake <<- totalRake + rakeAmount
                if (verbosity > 0)
                    print(
                        sprintf(
                            "bet:%7.3f, rake: %6.3f, total rake: %7.3f",
                            betAmount,
                            rakeAmount,
                            totalRake
                        )
                    )
                #print(sprintf("before sell, bankroll: %7.3f",bankroll))
                sell(betAmount)
                #print(sprintf("after sell, bankroll: %7.3f",bankroll))
                boughtAt = 0.
            } else {
                if (verbosity > 1)
                    print("no buy")
            }
        } else {
            # we are holding some
            print("holding!")
        }
        return(boughtAt)
        
    } # end of oneDay()
    #prologue()
    r <- (buffer + 1):(length(prices) - forecast)
    if (verbosity > 0)
        print("------------------------------")
    for (i in r) {
        if (verbosity > 0)
            print(sprintf("index: %d, bankroll: %7.3f", i, bankroll))
        if (bankroll <= 0.) {
            print("broke!")
            return(NULL)
        }
        boughtAt <- oneDay(i, boughtAt)
        #print(sprintf("at bottom of loop, bankroll: %7.3f, total rake: %7.3f",bankroll,totalRake))
        if (verbosity > 0)
            print("------------------------------")
        if (FALSE)
            if (i >= buffer + 20) {
                print(sprintf("breaking out after %d", i))
                break
                
            }
        
    }
    if (verbosity > 0)
        print(
            sprintf(
                "at eol, br: %7.3f, total rake: %7.3f, wins: %d, buys: %d",
                bankroll,
                totalRake,
                wins,
                buys
            )
        )
    #print(toString()) # make one like this for writing file
    print(sprintf("csv: %s",toCSVLine()))
    l1<-list(bankroll = bankroll, totalRake = totalRake)
    l2<-list(symbol=symbol,bankroll=bankroll, winRate=wins / buys,  buyRate=buys / length(prices))
    return(list(l1,l2))
}
testAdjustBankrollForR <- function() {
    prices = c(1, 2, 3, 4, 5, 6, 7, 8, 9, 10)
    prices = seq(1, 10)
    symbol <- "ABCD"
    rake <<- .01 # changing a global value
    lists <- runOneStock(symbol, prices, buy0)
    l<-lists[[1]]
    epsilon = 1e-6
    expectedBankroll <- 1.37214
    expectedTotalRake <- 0.02188
    if (abs(l$bankroll - expectedBankroll) >= epsilon)
        print("fail 1")
    if (abs(l$totalRake - expectedTotalRake) >= epsilon)
        print("fail 2")
}
testAdjustBankrollForR() # agrees with PlayTestCase.testAsjustBankrollForR()
apple <- function() { # agrees with java code
    rake <<- 0.
    z <- read.csv.zoo("apple.csv")
    x <- as.xts(z)
    prices <- coredata(x$AAPL.Close)
    print(sprintf("%d prices.", length(prices)))
#    l <- runOneStock("apple", prices, buy0)
#    l
#    l <- runOneStock("apple", prices, buy1)
#    l
    l <- runOneStock("apple", prices, buy2) ## agrees with java play
    l
}
a<-apple()
# getting 1.1540557154982802 with new buy2 in the java version.
some <- function(symbols,from,to) {
    # some stocks
    print(sprintf("class: %s, %d rows", class(symbols), nrow(symbols)))
    print("--------------------------")
    for (i in 1:nrow(symbols)) {
        #for (i in 510:520) {
        row <- symbols[i, ]
        symbol <- row$Ticker
        if (FALSE && i == 1) {
            print(sprintf("row: %d", i))
            print(row)
            print(sprintf("index: %d, symbol: %s",i,symbol))
        }
        
        x <- getSymbols(
            symbol,
            src = "yahoo",
            from = from,
            to = to,
            env = NULL
        )
        if (any(is.na(x))) {
            print(sprintf("index: %d, symbol: %s, has NA's!",i,symbol))
            next
        }
        print(sprintf("index: %d, symbol: %s.",i,symbol))
        x <- as.data.frame(x)
        prices <- x[, 4]
        #print(head(prices))
        runOneStock(symbol, prices, buy1) # run with straregy
        
        #print("--------------------------")
        if (FALSE && i > 100)
            break
    }
}
runSome <- function() { # currently not useds
    symbols <- read.csv("newout.ystocks00.csv")
    print(sprintf("class: %s, %d rows", class(symbols), nrow(symbols)))
    if (nrow(symbols) == 0) {
        print("0 rows!")
        return(0)
    }
    df <- symbols[0, ] # copy header
    #verbosity<-1
    from = Sys.Date() - 365
    to = Sys.Date()
    some(symbols,from,to)
    
}
