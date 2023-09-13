new_myclass <- function(x = numeric()) {
    structure(list(data = x), class = "myclass")
}
# Create a print method for myclass objects
print.myclass <- function(x, ...) {
    print(x$data)
}
f.myclass <- function(x, ...) {
    print("f")
}
g.myclass <- function(x, ...) {
    print("g")
    f.myclass(x)
}
h.myclass <- function(x, ...) {
    print("h")
    print(x$data)
    i.myclass(x,x$data)
}
i.myclass <- function(x,y) {
    print("i")
    print(y)
}

x<-1.:5.
mc=new_myclass(x)
print(mc)
print(is.atomic(mc$data))
print(mc$data)
f.myclass(mc)
g.myclass(mc)
h.myclass(mc)
