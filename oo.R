x1 <- 1
x2 <- NULL
x3 <- NULL
x4 <- NULL
f <- function() {
    x2 <<- x1 + 1
    x3 <<- 2
    g <- function() {
        x3 <<- x3 + 1
        h <- function() {
            x4 <- x3 + 1
            print(sprintf("%d %d %d %d", x1, x2, x3, x4))
        }
        h()
    }
    g()
}
f()
