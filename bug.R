ids= 0
Play <- function(symbol = character(),
                 prices = numeric()) {
    ids <- ids + 1
    structure(list(bankroll = 1,
                   id = ids,
                   x=42),
              class = "MyPlay")
}
sell.MyPlay <- function(o) {
    o$bankroll <- 1.234
    o$x=o$x+1
    print(o$bankroll)
}
play <- Play("abcd", NULL)
print(play)
play$bankroll <- -2.
print(sprintf("before sell: %7.3f", play$bankroll))
sell.MyPlay(play)
print(sprintf("after sell: %7.3f", play$bankroll))
play
