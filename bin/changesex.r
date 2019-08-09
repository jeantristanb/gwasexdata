datainfo=read.table("integrated_call_samples_v2.20130502.ALL.ped",sep="\t", header=T)
datafam=read.table("plkfile/1000G.h3aPos.1.vcf.save.fam", header=F)
datafam$pos<-1:nrow(datafam)
datafam2<-merge(datafam,datainfo[,c("Family.ID","Individual.ID","Gender")], by=c(2), all.x=T)
datafam2$V5<-datafam2$Gender
datafam2<-datafam2[order(datafam2$pos),]
write.table(datafam2[,1:6],file="plkfile/1000G.h3aPos.1.vcf.fam", row.names=F, col.names=F, sep="\t", quote=F)



