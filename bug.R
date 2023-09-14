ids= 0
Play <- function(symbol = character(),
                 prices = numeric()) {
    ids <- ids + 1
    structure(list(bankroll = 1,
                   id = ids),
              class = "MyPlay")
}
sell.MyPlay <- function(o) {
    o$bankroll <- 1.234
    print(o$bankroll)
}

one.MyPlay <- function(o) {
    o$bankroll <- -2.
    print(sprintf("in one() before sell: %7.3f", o$bankroll))
    sell.MyPlay(o)
    print(sprintf("in one() after sell: %7.3f", o$bankroll))
}
play <- Play("abcd", NULL)
print(play)
play$bankroll <- -2.
print(sprintf("before sell: %7.3f", play$bankroll))
sell.MyPlay(play)
print(sprintf("after sell: %7.3f", play$bankroll))
