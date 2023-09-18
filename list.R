f<-function(l) {
    l$a<-2
}
l<-data.frame(list(a=1,b="foo"))
l
f(l)
l
g<-function(l) {
    l$a[1]<-3
    return(l)
}
df<-data.frame(list(a=1,b="foo"))
df
df$a[1]<-2
df
df2<-g(df)
df2
