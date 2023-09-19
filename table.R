df<-data.frame(a=1,b="foo",c=.2)
df
df$a=df$a+1
df$b="bar"
df
f<-function(df) {
    df$a<-123
    return(df)
}
df2<-f(df)
df
df2

