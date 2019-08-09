#version 8 august 19
# * by jean-tristan brandenburg
# * description : append sex to fam file in 1000 genomes
# * work : Rscript changesex.r filefamI filefamOut
# * input : 
#  * filefamI : initial fam file need to be change
#  * filefamO : file out with sex added

args = commandArgs(trailingOnly=TRUE)
datainfo=read.table("../data/integrated_call_samples_v2.20130502.ALL.ped",sep="\t", header=T)
datafam=read.table(args[1], header=F)
datafam$pos<-1:nrow(datafam)
datafam2<-merge(datafam,datainfo[,c("Family.ID","Individual.ID","Gender")], by=c(2), all.x=T)
datafam2$V5<-datafam2$Gender
datafam2<-datafam2[order(datafam2$pos),]
if(file.exits(args[2])){
	q(paste('file ',args[2], "exist\nexit"))
}
write.table(datafam2[,1:6],file=args[2], row.names=F, col.names=F, sep="\t", quote=F)



