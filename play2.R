# this is play2!
library(quantmod)
buy0 <- function(index, prices) {
    return(T)
}
buy1 <- function(index, prices) {
    p1 = prices[index - 2]
    p2 = prices[index - 1]
    return(p1 <= p2)
}
buy2 <- function(index, prices) {
    p1 = prices[index - 3]
    
    p2 = prices[index - 2]
    
    p3 = prices[index - 1]
    
    # add a check for some mimimum increase?
    return(p1 <= p2 && p2 <= p3)
}
buy3 <- function(index, prices) {
    p1 = prices[index - 4]
    p2 = prices[index - 3]
    p3 = prices[index - 2]
    p4 = prices[index - 1]
    return(p1 <= p2 && p2 <= p3 && p3 <= p4)
}
buy4 <- function(index, prices) {
    p1 = prices[index - 4]
    p2 = prices[index - 3]
    p3 = prices[index - 2]
    p4 = prices[index - 1]
    dy2 = p2 - p1
    dy3 = p3 - p2
    dy4 = p4 - p3
    d2y3 = dy3 - dy2
    d2y4 = dy4 - dy3
    d3y4 = d2y4 - d2y3
    return(dy4 > 0 && d2y4 > 0)
}
newBroker <- function() {
    l <- list(
        initialBankroll = 1,
        bet = 1,
        rake = .01,
        buffer = 5,
        forecast = 3
    )
    return(l)
}
newTransaction <- function() {
    l <- list(bankroll=0,
              boughtAt=0,
              soldAt=0,
              betAmount=0,
              rake=0,
              change=0,
              profit=0
    )
    return(l)
}
newResult <- function(symbol, prices) {
    # uses global  broker
    l <- list(
        symbol = symbol,
        bankroll = broker$initialBankroll,
        #prices = prices, # creates many rows!
        # maybe not if it's a list?
        buys = 0,
        wins = 0,
        rake = broker$rake,
        totalRake = 0
    )
    return(l)
}
sell <- function(r, boughtAt, current, betAmount) {
    print("enter sell(): ")
    change = current - boughtAt
    if (change > 0) {
        r$wins = r$wins + 1
    }
    profit = (current - boughtAt) / boughtAt
    #hProfit().add(profit)
    delta = betAmount * (1. + profit)
    previous = r$bankroll # who's on first?
    if (TRUE)
        r$bankroll = r$bankroll + delta
    else
        r$bankroll <-
        r$bankroll + betAmount # pretend no gain or loss.  # this is just to keep the bankroll constant.
    print(
        sprintf(
            "id: %d, br: %7.3f, previous: %7.3f, change: %7.3f, delta: %7.3f",
            r$bankroll,
            previous,
            change,
            delta
        )
    )
    if (verbosity > 1)
        print(
            sprintf(
                "profit %6.3f, br %7.3f, bought at %6.3f, current %6.3f, $ %6.3f\n",
                profit,
                r$bankroll,
                boughtAt,
                current,
                current - boughtAt
            )
        )
    l <- list(bankroll=r$bankroll,
              boughtAt=boughtAt,
              soldAt=current,
              betAmount=betAmount,
              rake=0,
              change=change,
              profit=profit
    )
    print("exit sell()")
    return(l)
}
one <- function(r, buy, prices, i, boughtAt) { # one day
    print(sprintf("enter one(), bankroll: %7.3f, index: %d", r$bankroll, i))
    if (boughtAt == 0) {
        # new buy?
        if (buy(i, prices)) {
            bankroll<-r$bankroll[1] # use initial in result.
            # should be kept current
            # maybe do the calculation, the do the rbind at the bottom
            boughtAt = prices[i - 1]
            print("try to print bet")
            print(broker$bet)
            betAmount = bankroll * (broker$bet)
            print("try to print bet amount")
            print(sprintf("bet amount: %7.3f", betAmount))
            bankroll<- bankroll - betAmount 
            rakeAmount = betAmount * r$rake
            print("try to print rake amount.")
            print(sprintf("rake amount: %7.3f", rakeAmount))
            r$totalRake = r$totalRake + rakeAmount #
            print(sprintf("total rake: %7.3f", r$totalRake))
            betAmount = betAmount - rakeAmount
            print("try to print bet amount after rake")
            print(sprintf("bet amount: %7.3f", betAmount))
            r$buys = r$buys + 1 #
            print(sprintf("bought at: %7.3f", boughtAt))
            print(sprintf("in one() before sell, bankroll: %7.3f", bankroll))
            transaction<-sell(t, boughtAt, prices[i], betAmount)
            print(sprintf("in one() after sell, bankroll: %7.3f", t$bankroll[ts]))
            # set values in transaction
            #t <- rbind(t, list(bankroll,boughtAt,0,betAmount,0,0,0))
            t <- rbind(t, transaction)
            ts<-ts+1
            boughtAt = 0
            return(transaction)
        } else {
            print("no buy")
        }
    } else {
        # we are holding some
        # this was never implemented
        print("holding")
    }
    print("try to print total rake")
    print(o$totalRake)
    return(boughtAt)
}
run <- function(r, buy) {
    # uses global  broker
    boughtAt = 0
    transactions <-newTransaction()
    transactions<-data.frame(transactions)
    transactions<-transactions[-1,] # make it empty
    for (i in broker$buffer:(length(play$prices) - broker$forecast)) {
        print(
            sprintf(
                "in run(): buffer: %d, index: %d, bought at: %f",
                broker$buffer,
                i,
                boughtAt
            )
        )
        if (play$bankroll < 0) {
            print("broke!")
            break
        }
        print(r$totalRake)
        boughtAt <- one(transactions,r, buy, prices, i, boughtAt)
        print(r$totalRake)
        print(r)
        break # for debugging
    }
    return(transactions) # might have no rows
}
# looks like 2 lists and one data frame:
#   list  to initialize from (broker) - global for now
#   list for cumulative stuff (result) - one row. add to another table for many stocks.
#   make a data frame for a bunch of cumulative stuff
#   data frame that has profit and  bankroll for each transaction

symbol = "GOOG"
prices = c(1., 2., 3., 4., 5., 6., 7., 8, 9.)
broker <- newBroker()
broker
result <- newResult(symbol, prices)
result
transactions<-run(result, buy0)
result
