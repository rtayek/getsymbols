ids= 0
l<- list(bankroll=1,id=ids,x=42)
sell <- function(o) {
    o$bankroll <- 1.234
    o$x=o$x+1
    print(o$bankroll)
}
print(l)
l$bankroll <- -2.
print(sprintf("before sell: %7.3f", l$bankroll))
sell(l)
print(sprintf("after sell: %7.3f", l$bankroll))
l
