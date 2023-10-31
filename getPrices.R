# just get prices for now.
# stop working in this and just hack at readYahoo.R
rm(list = ls())
require(logger)
require(quantmod)
source("get0.R")
# read yahoo file
# process some sumbols (get prices if price file is not found).
#filename <- file.path(p, "yahoosymbols.csv", fsep = "\\")
filename <- file.path("data", "yahoohighest.csv", fsep = "\\")
symbols <- read.csv(filename)
rows <- nrow(symbols)
print(sprintf("%5s has %d rows.", filename, rows))
log_info(sprintf("%5s has %d rows.", filename, rows))

