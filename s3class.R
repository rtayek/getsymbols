new_myclass <- function(x = numeric()) {
    structure(list(data = x), class = "myclass")
}
# Create a print method for myclass objects
print.myclass <- function(x, ...) {
    print(x$data)
}
x<-1:5
mc=new_myclass(x)
print(mc)
