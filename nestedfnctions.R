f<-function() {
    x<-1
    g <- function(y) {
        print(x)
        x<-x+1 # how to access aabove?
        return(x)
    }
    r<-g(1)
    print(x)
    print(r)
}
f()
