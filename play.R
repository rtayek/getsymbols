library(quantmod)
# https://saturncloud.io/blog/creating-an-s3-class-in-an-r-package-a-comprehensive-guide/
from<-Sys.Date()-365
to<-Sys.Date()
initialBankroll<-1
buffer<-5
forecast<-3
verbosity<-2
buy0<-function(index,prices) { return(T) }
buy1<-function(index,prices) {
    p1=prices[index-2]
    p2=prices[index-1]
    return(p1<=p2)
}
buy2<-function(index,prices) {
    p1=prices[index-3];
    p2=prices[index-2];
    p3=prices[index-1];
    # add a check for some mimimum increase? 
    return(p1<=p2&&p2<=p3)
}
buy3<-function(index,prices) {
    p1=prices[index-4]
    p2=prices[index-3]
    p3=prices[index-2]
    p4=prices[index-1]
    return(p1<=p2&&p2<=p3&&p3<=p4)
}
buy4<-function(index,prices) {
    p1=prices[index-4]
    p2=prices[index-3]
    p3=prices[index-2]
    p4=prices[index-1]
    dy2=p2-p1
    dy3=p3-p2
    dy4=p4-p3
    d2y3=dy3-dy2
    d2y4=dy4-dy3
    d3y4=d2y4-d2y3
    return(dy4>0&&d2y4>0)
}
Play <- function(symbol=character(),prices = numeric()) {
    structure(
        list(
            symbol = symbol,
            bankroll = initialBankroll,
            bet = 1,
            prices = prices,
            buys = 0,
            wins = 0,
            rake = 0,
            totalRake = 0
        ),
        class = "MyPlay"
    )
}
print.MyPlay <- function(o, ...) {
    cat("symbol: ", o$symbol,
        ", br: ",o$bankroll,
        ", bet: ",o$bet,
        ", buys: ",o$buys,
        ", wins: ",o$wins,
        ", rake: ",o$rake,
        ", totalRake: ",o$totalRake,
        " end\n")
    #cat(o$prices)
}
sell.MyPlay<-function(o,boughtAt,index,amountBet) {
    current=o$prices[index]
    change=current-boughtAt
    print(sprintf("sold at: %f, change: %f",current,change))
    if(change>0)
        o$wins=o$wins+1
    profit=(current-boughtAt)/boughtAt
    print(sprintf("profit: %f",profit))
    
    #hProfit().add(profit)
    delta=amountBet*(1+profit)
    previous=o$bankroll
    if(TRUE) o$bankroll=o$bankroll+delta
    else o$bankroll<-o$bankroll+amountBet # pretend no gain or loss.
    # this is just to keep the bankroll constant.
    if(verbosity>1) sprintf("profit %6.3f, br %17.3f, bought at %6.3f, current %6.3f, $ %6.3f\n",
        profit,o$bankroll,boughtAt,current,current-boughtAt);
    #if(verbosity>1) 
    #    print(index+", buys: "+buys+", wins: "+wins+", ties "+ties+", losses "+losses+", br: "+bankroll);
}

one.MyPlay<-function(o,buy,i, boughtAt) { # one day
    if(boughtAt==0) { # new buy?
        print("not holding")
        if(buy(i,o$prices)) { # use instace of  ptices?
            boughtAt=o$prices[i-1]
            print(sprintf("boughtAt: %f",boughtAt))
            betAmount=o$bankroll*o$bet
            bankroll<-betAmount #
            rakeAmount=betAmount*o$rake
            o$totalRake=o$totalRake+o$rakeAmount #
            betAmount=betAmount+o$rakeAmount
            o$buys=o$buys+1 #
            sell.MyPlay(o,boughtAt,i,betAmount)
            boughtAt=0
        } else {
            print("no buy");
        }
    } else { # we are holding some
        # this was never implemented
        print("holding")
    }
    return(boughtAt)
}

run.MyPlay<-function(play,buy) {
    boughtAt=0;
    for(i in buffer:length(play$prices)-forecast) {
        print(sprintf("index: %d",i))
        if(play$bankroll<0) { print("broke!"); break; }
        boughtAt<-one.MyPlay(play,buy,i,boughtAt);
        print(play)
    }
}
x=c(1.,2.,3.,4.,5.,6.,7.,8,9.)
play<-Play("abcd",x)
print(play)
run.MyPlay(play,buy0)

