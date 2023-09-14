library(quantmod)
# https://saturncloud.io/blog/creating-an-s3-class-in-an-r-package-a-comprehensive-guide/
from <- Sys.Date() - 365
to <- Sys.Date()
initialBankroll <- 1
buffer <- 5
forecast <- 3
verbosity <- 2
id=0
Play <- function(symbol = character(),
                 prices = numeric()) {
    id<-id+1
    structure(
        list(
            #symbol = symbol,
            bankroll = initialBankroll,
            #bet = 1,
            #prices = prices,
            #buys = 0,
            #wins = 0,
            #rake = 0,
            #totalRake = 0,
            id=id
        ),
        class = "MyPlay"
    )
}
sell.MyPlay <- function(o, boughtAt, index, betAmount) {
    o$bankroll<-1.234
    print(o$bankroll)
    print("exit sell()")
}

one.MyPlay <- function(o, buy, i, boughtAt) {
    o$bankroll<--2.
    print(sprintf("in one() before sell: %7.3f",o$bankroll))
    sell.MyPlay(o, boughtAt, i, betAmount)
    print(sprintf("in one() after sell: %7.3f",o$bankroll))
    return(boughtAt)
}

run.MyPlay <- function(play, buy) {
    boughtAt<-0
    boughtAt <- one.MyPlay(play, buy, 0, boughtAt)
    print("------------------------------------")
}
x = c(1., 2., 3., 4., 5., 6., 7., 8, 9.)
play <- Play("abcd", x)
print(play)
run.MyPlay(play, buy0)

