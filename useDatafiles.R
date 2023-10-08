# read in the files we made
rm(list = ls())
myReadCsv<-function(file) {
    if (file.exists(inputFile)) {
        result <- tryCatch(
            expr = {
                x <- read.csv(inputFile)
                good <- good + 1
                l[[good]] <- x
                x
            },
            error = function(e) {
                bad <<- bad + 1
                log_error(sprintf("error: %s", e$message))
                e
            },
            warning = function(w) {
                bad <<- bad + 1
                log_warn(sprintf("warning %s: ", w$message))
                w
            },
            finally = {
                # what gets returned here?
            }
        )
        return(result)
    } else {
        print(sprintf("file: %s does not exists!", inputFile))
        return(NULL)
    }
    
}
highestFile <- file.path("data", "yahoohighest.csv",  fsep = "\\")
y <- read.csv(highestFile)
print(sprintf("%s had %d rows.", highestFile, nrow(y)))
n <- nrow(y)
#n<-100
bad <- 0
good <- 0
# looks like i need a good index to make a list.
maxFiles <- 5
l <- list()
for (i in 1:n) {
    symbol <- y$Ticker[i]
    #print(y[i,])
    inputFile <-
        paste(file.path("data", "prices" , symbol, fsep = "\\"),
              ".csv",
              sep = "")
    if (file.exists(inputFile)) {
        print(sprintf("index: %d, symbol: %s, exchange: %s", i, symbol, y$Exchange[i]))
        x<-myReadCsv(inputFile)
        print(sprintf("process file: %s", inputFile))
    } else {
        print(sprintf("index: %d, files: %s does not exists!", i,  inputFile))
    }
    if (i > maxFiles) {
        print(sprintf("breaking out after: %d files.", maxFiles))
        break
    }
    
}
print("-----------")
print(sprintf("%d good", length(l)))
print(sprintf("%d bad.", bad))
print(head(l[[1]], 4))
print(head(l[[2]], 4))
