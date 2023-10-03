# files<-list.files(pattern=".\\data\\bankroll.*.csv") # does noy work!
# gather the bankroll files and sort descending.
files<-list.files("data")
once<-FALSE
df<-NULL
outputFile<-file.path("data", "highest.csv",  fsep = "\\")
for(file in files) {
    if(startsWith(file,"bankroll")) {
        print(file)
        p<-file.path("data", file,  fsep = "\\")
        x<-read.csv(p)
        print(nrow(x))
        if(!once) {
            df<-x[0,]
            once<-TRUE
        }
        df<-rbind(df,x)
    }
    print(nrow(df))
}
sorted <- df[order(-df$bankroll),]
print(head(sorted))
write.csv(sorted,file=outputFile,row.names=FALSE)
