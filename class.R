foo <- list(x=0,y=0)
print(foo)
print(foo$x)
foo$x<-42
print(foo$x)
class(foo) <- "Foo"
print(foo)
print(foo$x)
