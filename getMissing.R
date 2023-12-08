rm(list = ls())
require(logger)
require(quantmod)
source("strategy.R")
source("play3.R")
source("get0.R")
priceFileExists<-function(ticker)  {
    #oldDataPath
    filename=paste0(ticker,".csv")
    path=file.path("c:","data", filename, fsep = "\\")
    if (file.exists(path)) {
        #  print(sprintf("%s exists.", path))
        return(TRUE)
    } else {
        # print(sprintf("%s does not exists!", path))
        return(FALSE)
    }
}
path=file.path("c:","dfromrays8350","data", fsep = "\\")
if (file.exists(path)) {
    print(sprintf("%s exists.", path))
} else {
    print(sprintf("%s does not exists!", path))
}
javaPath=file.path("c:","dfromrays8350","ray","stockApps","play", fsep = "\\")
missingFiles=file.path(javaPath,"missing.csv", fsep = "\\")
m <- read.csv(missingFiles)
print(sprintf("m has %s rows.", nrow(m)))
outputDir<-file.path("c:", "data", fsep = "\\")
if (file.exists(outputDir)) {
    print(sprintf("output dir %s exists.", outputDir))
} else {
    print(sprintf("output dir %s does not exists!", outputDir))
}
priceFileExists("AAAP")
priceFileExists("AAPL")
priceFileExists("AAAW")
#priceFileExists("AA")
#head(m)
#if(FALSE)
index<-0
for(ticker in m$missing) {
    print(sprintf("index: %s, Ticker: %s",index,ticker))
    if( !priceFileExists(ticker)) {
        ts<-getSymbol(ticker)
        if(is.null(ts)) {
            print("NULL")
        } else if("xts" %in% class(ts))  {
            print(ticker)
            print(class(ts))
            print(nrow(ts))
        }  else if("warning" %in% class(ts)) {
            if (grepl("contains missing values", ts$message)) {
                print("contains missing values")
            } else {
                print("some other kind of warning")
                print(ts$message)
            }
        }  else if("error" %in% class(ts)) {
            if (grepl("Unable to import", ts$message)) {
                print("404")
            } else {
                print("some other kind of error")
                print(ts$message)
            }
            #stop()
        }
        else {
            stop()
        }
    } else {
        print(sprintf("price file exists for: index: %s, Ticker: %s",index,ticker))
    }
    print("------")
    index<-index+1
    if(index>25) break
}
#  getting missing warnings and 404 errors
head(m)

