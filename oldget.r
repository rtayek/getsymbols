library(quantmod)
from=Sys.Date()-365
to=Sys.Date()
getSymbols("F",src="yahoo",from=from,to=to)
View(`F`)
getSymbols("^GSPC",src="yahoo",from=from,to=to)
#View(`GSPC`)
getSymbols("GOOG",src="yahoo",from=from,to=to)
#View(`GOOG`)
F$F.return=diff(F$F.Adjusted)/lag(F$F.Adjusted)
GSPC$GSPC.return=diff(GSPC$GSPC.Adjusted)/lag(GSPC$GSPC.Adjusted)
plot(F$F.return)
lmCapm<-lm(F~GSPC$GSPC.return)
names(lmCapm)
str(lmCapm)
summary(lmCapm)