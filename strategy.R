buy0 <- function(index, prices) {
    return(T)
}
buy1 <- function(index, prices) {
    p1 <- prices[index - 2]
    
    p2 <- prices[index - 1]
    
    return(p1 < p2)
    
}
buy2 <- function(index, prices) {
    p1 <- prices[index - 3]
    
    p2 <- prices[index - 2]
    
    p3 <- prices[index - 1]
    
    # add a check for some mimimum increase?
    return(p1 < p2 && p2 < p3)
}
