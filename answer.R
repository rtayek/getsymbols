library(quantmod)
library(tidyverse)
library(zoo)

from <- "2016-01-01" # leap year
to <- "2017-01-01"
symbol <- "AAPL"
getSymbols(symbol, from = from, to = to)
#> [1] "AAPL"
class(AAPL)
#> [1] "xts" "zoo"

AAPL |>
    as_tibble(rownames = "index") |>
    write_csv("newapple2.txt")

x <- read_csv("newapple2.txt")

class(x)
#> [1] "spec_tbl_df" "tbl_df"      "tbl"         "data.frame"

x2<-as.xts(x, RECLASS = TRUE)
class(x2)

write_csv("newapple3.txt")
