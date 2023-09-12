library(quantmod)
# https://saturncloud.io/blog/creating-an-s3-class-in-an-r-package-a-comprehensive-guide/
from<-Sys.Date()-365
to<-Sys.Date()
initialBankroll<-1
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
        "\n")
}
x=c(1.,2.,3.)
play<-Play("abcd",x)
print(play)

one.MyPlay<-function(o,buy,i, boughtAt) { # one day
    if(boughtAt==0) { # new buy?
            if(buy(i,o$prices)) {
                buffer=3
                boughtAt=o$prices[i-1]
                betAmount=o$bankroll*o$bet
                bankroll<-betAmount #
                rakeAmount=betAmount*o$rake
                totalRake=totalRake+o$rakeAmount #
                betAmount=betAmount+o$rakeAmount
                o$buys=o$buys+1 #
                sell(boughtAt,i,betAmount);
                boughtAt=0
            } else {
                print("no buy");
            }
    } else { # we are holding some
        # this was never implemented
    }
    return(boughtAt)
}

run.MyPlay<-function(play) {
    boughtAt=0;
    for(i in 1:length(play$prices)) {
        if(bankroll<0) { System.out.println("broke!"); break; }
        boughtAt=one(buy,i,boughtAt);
        print(play)
    }
}
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

run<-function(buy,prices) {
    boughtAt<-0
    for(price in prices) {
        if(bankroll<=0) {
            print("broke!")
            return(1)
        }
        boughtAt<-one(buy,i,boughtAt)
    }
}

