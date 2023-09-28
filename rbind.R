f <- function() {
    df <- data.frame(a = character(),
                     b = numeric(),
                     stringsAsFactors = F)
    l <- list(a = "a", b = 1.2)
    df <- rbind(df, l)
    return(df)
}
df<-f()
l <- list(a = "b", b = 4.5)
df <- rbind(df, l)
df
