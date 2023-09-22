library(quantmod)
from<-Sys.Date()-365
to<-Sys.Date()
symbol<-"GOOG"
getSymbols(symbol,src="yahoo",from=from,to=to)
#getSymbols(symbol,src="yahoo")
# compare this data with the java/kaggle code.
# pick some date range in common.
# aapl.us.txt: 1984-09-07 2017-11-10
head(GOOG)
# 2007-01-03
tail(GOOG)
# 2023-09-1
# let's try 2008-01-01 - 2017-01-01
#from<-"2008-01-01"
from<-"2016-01-01" # leap year
to<-"2017-01-01"
getSymbols(symbol,src="yahoo",from=from,to=to)

