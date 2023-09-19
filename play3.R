buffer = 5
forecast = 3
initialBankroll = 1.
bet<-1. # ,25 seems to work
rake = .01
#
buy0 <- function(index, prices) {
    return(T)
}
run <- function(symbol, prices, buy) {
    bankroll <- initialBankroll
    boughtAt <- 0. # switch for buy and hold 
    totalRake<-0
    buys<-0
    wins<-0
    one <- function(i, boughtAt) {
        print(totalRake)
        sell<-function(amountBet) {
            print(sprintf("in sell, amount bet: %7.3f",amountBet))
            current<-prices[i]
            change<-current-boughtAt
            if(change>0) wins<-wins+1
            profit<-(current-boughtAt)/boughtAt # per share
            # hProfit().add(profit)
            delta<-amountBet*(1+profit)
            previous<-bankroll
            if(TRUE) bankroll<<-bankroll+delta
            else bankroll<<-bankroll+amountBet # pretend no gain or loss.
            # this is just to keep the bankroll constant.
            print(sprintf("in sell, previous bankroll: %7.3f, change: %7.3f,  delta: %7.3f",previous,change,delta))
            print(sprintf("end of sell, profit(b4): %6.3f, br %7.3f, bought at %6.3f, current %6.3f, $ %6.3f",
                profit,bankroll,boughtAt,current,current-boughtAt))
        } # end of sell
        if (boughtAt == 0.) { # new buy?
            if (buy(i, prices)) {
                boughtAt <- prices[i - 1]
                betAmount <- bankroll * bet
                bankroll <<- bankroll - betAmount
                rakeAmount <- betAmount * rake
                betAmount <- betAmount - rakeAmount
                totalRake <<- totalRake + rakeAmount
                buys <- buys + 1
                print(sprintf("bet amount: %7.3f, rake amount: %7.3f, total rake: %7.3f",betAmount,rakeAmount,totalRake))
                print(sprintf("before sell, bankroll: %7.3f",bankroll))
                sell( betAmount)
                print(sprintf("after sell, bankroll: %7.3f",bankroll))
                boughtAt = 0.
            } else {
                print("no buy")
            }
        } else {
            # we are holding some
            print("holding!")
        }
        return(boughtAt)
        
    }
    r <- (buffer+1):(length(prices) - forecast)
    print("------------------------------")
    for (i in r) {
        print(sprintf("index: %d, bankroll: %7.3f",i,bankroll))
        if (bankroll <= 0.) {
            print("broke!")
            return(NULL)
        }
        boughtAt <- one(i,boughtAt)
        print(sprintf("at end of loop, bankroll: %7.3f, total rake: %7.3f",bankroll,totalRake))
        print("------------------------------")
    }
    return(list(bankroll=bankroll,totalRake=totalRake))
}
test1<-function() {
    prices = c(1, 2, 3, 4, 5, 6, 7, 8, 9,10)
    prices = seq(1,10)
    symbol <- "ABCD"
    l<-run(symbol, prices,buy0)
    epsilon=1e-6
    expectedBankroll<-1.37214
    expectedTotalRake<-0.02188
    if(abs(l$bankroll-expectedBankroll)>=epsilon)
        print("fail 1") 
    if(abs(l$totalRake-expectedTotalRake)>=epsilon)
        print("fail 2")
}
test1()
