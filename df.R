f<-function(df) {
    tracemem(df)
    df[nrow(df)+1,]<-c(77,180,"M")  
    print("exit f")
    df
}
Sam <- c(22,150, 'M')
Frank <- c(25, 165, 'M')
Amy <- c(26, 120, 'F')
df <- as.data.frame(rbind(Sam, Frank, Amy), stringsAsFactors = FALSE)
names(df) <- c('Age' , 'weight', 'Sex')
print("after names()")
tracemem(df)
df
f(df)
df
