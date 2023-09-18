Outer_func <- function(x) {
    z<-100
    Inner_func <- function(y) {
        a <- x + y +z
        return(a)
    }
    r<-Inner_func(1)    
    return (Inner_func)
}
output <- Outer_func(3) # To call the Outer_func
output(5)
