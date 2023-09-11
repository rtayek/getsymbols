library(quantmod)
c1<- c("a1","b1","c1")
c2<- c("a2","b2","c2")
df <- data.frame(c1,c2)
df2<-df[0,]
for(i in 1:nrow(df)) {
    row<-df[i,]
    df2[nrow(df2)+1,]<-row
}
df==df2
