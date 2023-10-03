# read the highest.csv file from gather.R
# make a file like yahoosymbols.csv,
# but with just the stocks with the highest bankroll.
once<-FALSE
df<-NULL
yahooFile<-file.path("d:","data","yahoodata", "yahoosymbols.csv",  fsep = "\\")
y<-read.csv(yahooFile)
print(sprintf("%s had %d rows.",yahooFile,nrow(y)))
highestFile<-file.path("data", "highest.csv",  fsep = "\\")
outputFile<-file.path("data", "yahoohighest.csv",  fsep = "\\")
x<-read.csv(highestFile) # shoule be able to read csv or just one column
print(sprintf("%s had %d rows.",highestFile,nrow(x)))
print(tail(head(x,500)))
df<-y[0,] # copy yahoo csv header
for(i in 1:500) {
    target<-x$symbol[i]
    found<-which(y$Ticker==target)
    df[nrow(df)+1,]<-y[found,]
}
write.csv(df,file=outputFile)
