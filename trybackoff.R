require(quantmod)
retry <- 0
max_retries <- 3
n<-0
while(T) { # got to 70k
    df<-getSymbols("AAPL", env = NULL)
    print(sprintf("n: %d, %d",n,nrow(df)))
    if ("error" %in% class(response)) {
        break
    }
    n<-n+1
}
stop()
while (retry < max_retries) {
    response <- tryCatch(
        getSymbols("AAPL", env = NULL),
        error = function(e)
            e
    )
    if ("error" %in% class(response)) {
        if (grepl("HTTP error 429", response$message)) {
            wait_time <- 2 ^ retry
            cat("Retrying in", wait_time, "seconds...\n")
            Sys.sleep(wait_time)
            retry <- retry + 1
        } else {
            print("some other kind of error")
            print(response)
            break
        }
    } else {
        print("ok")
        break
    }
}

