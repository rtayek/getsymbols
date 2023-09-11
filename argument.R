x<-2
print(x)
f<-function(xx) {
    x<<-3
    print(x)
}
f(x)
print(x)

