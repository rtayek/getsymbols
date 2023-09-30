list.files(pattern="ystocks.*.csv")
s<-7:12

sprintf("%02d", s)

idnamer<-function(x,y){#Alphabetical designation and number of integers required
    id<-c(1:y)
    for (i in 1:length(id)){
        if(nchar(id[i])<2){
            id[i]<-paste("0",id[i],sep="")
        }
    }
    id<-paste(x,id,sep="")
    return(id)
}
x<-idnamer("",10)

sprintf("%04d", 1)
# [1] "0001"
sprintf("%04d", 104)
# [1] "0104"
sprintf("%010d", 104)
# [1] "0000000104"

# needs string package
#anim = 25499:25504
#str_pad(anim, width=6, pad="0")
