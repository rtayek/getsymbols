# Define a function that mutates a list
mutateList <- function(myList) {
    # Modify the list inside the function
    myList$element1 <- "New Value"
    myList$element2 <- 100
}

# Create a list
myList <- list(element1 = "Old Value", element2 = 42)

# Call the function to mutate the list
mutateList(myList)

# Print the modified list
print(myList)

