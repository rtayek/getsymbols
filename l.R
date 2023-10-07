f<-function(l) {
    l[1]<-0
}
g<-function() {
    l<-list(1,2,3)
    tracemem(l)
    f(l)
    print(l)
    l[[1]]<-l[[1]]+1
    print(l)
}
l<-list(1,2,3)
print(class(l))
print(class(l[[1]]))
print(class(l[1]))
l[[1]]<-4
l[1]<-5
g()
