# make the data files so java (and r) can just read them.
# read the highest.csv file from gather.R
# make a file like yahoosymbols.csv,
# but with just the stocks with the highest bankroll.
once <- FALSE
df <- NULL
from = "2000-01-01"
to = "2023-01-01"
inoputFile <- file.path("data", "yahoohighest.csv",  fsep = "\\")
y <- read.csv(inoutFile)
print(sprintf("%s had %d rows.", inputFile, nrow(y)))
n <- nrow(y)
bad<-0
for (i in 1:n) {
    symbol <- y$Ticker[i]
    print(sprintf("index: %d, symbol: %s", i,symbol))
    # read the data and write to a /csv file.
    ts <- getSymbol(symbol) # xts zoo time series
    if ("xts" %in% class(ts)) {
        outputFile <- paste(file.path("data", "prices" , symbol, fsep = "\\"),
                            ".csv",
                            sep = "")
        print(outputFile)
        write.zoo(ts, file = outputFile, sep = ",")
        print(sprintf("%s has %d rows", symbol, nrow(ts)))
    } else {
        bad<-bad+1
    }
}
print(sprintf("%d bad.",bad))
