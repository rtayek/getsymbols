mutateList <- function(myList) {
    myList$element1 <- "New Value"
    myList$element2 <- 100
}
myList <- list(element1 = "Old Value", element2 = 42)
print(myList)
mutateList(myList)
print(myList)

