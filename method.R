br0<-1
play <- list(symbol=NULL,br=br0,bet=1,prices=NULL,buys=0,wins=0)
class(play) <- "Play"
print.Play<-function(obj) {
    cat("symbol: ", obj$symbol, ", br: ",obj$br, "\n")
}
play
print(play)
