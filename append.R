mylist <- list()
tracemem(mylist)
for (i in 1:3) {
    df <- 1
    mylist <- append(mylist, df)
}
