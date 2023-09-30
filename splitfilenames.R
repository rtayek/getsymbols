s<-0:10
splits<-sprintf("%02d", s)
ins <- paste("ystocks",splits,".csv", sep = "")
outs <- paste("out.ystocks",splits,".csv", sep = "")
others <- paste("other.ystocks",splits,".csv", sep = "")
ins
outs
others
for(i in 1:length(s)) {
    print(s[i])
    print(ins[i])
    print(outs[i])
    print(others[i])
}

