## take of position postion dna chip
NbThread=3
DirDataTmp=dataTmp/
mkdir -p $DirDataTmp/
## TODO
FileBimH3africa="../data/pos.bim"
## chro list using to generate this data set
ListChro=(`seq 1 22`)

## download chromosome
for Chro in  ${ListChro[*]}
do
## dowload 1000G data
if [ ! -f "ALL.chr"$Chro".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz" ]
then 
wget -c ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/"ALL.chr"$Chro".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz" &
fi
# extract positon of h3africa from a bim file  : bed output by chromosme
listposchip=$DirDataTmp/"lispos."$Chro".bed"
if [ ! -f $listposchip ]
then
awk -v chro=$Chro '{if($1==chro)print $1"\t"$4"\t"$4"\t"$2}' $FileBimH3africa > $listposchip &
fi
done
## waiting until end
wait 


for Chro in  ${ListChro[*]}
do
#### Transform and clean data 
## build  plink file with vcf and position
if [ ! -f $DirDataTmp"/1000G.h3aPos."$Chro".tmp.bed" ]
then
listposchip=$DirDataTmp/"lispos."$Chro".bed"
plink --vcf ALL.chr"$Chro".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz  --keep-allele-order --extract range $listposchip --make-bed -out $DirDataTmp"/1000G.h3aPos."$Chro".tmp" & 
fi
done
wait
## deleted position where allele is not A,T,C,G
for Chro in  ${ListChro[*]}
do
if [ ! -f $DirDataTmp"/1000G.h3aPos."$Chro".bed" ]
then
awk '{if(length($5)==1 && length($6)==1)print $2}' $DirDataTmp"/1000G.h3aPos."$Chro".tmp.bim" > $DirDataTmp/goodpos.$Chro".pos"
plink -bfile $DirDataTmp"/1000G.h3aPos."$Chro".tmp" --keep-allele-order --extract  $DirDataTmp/goodpos.$Chro".pos" --make-bed -out $DirDataTmp"/1000G.h3aPos."$Chro &
fi
done 
wait

for Chro in  ${ListChro[*]}
do
if [ ! -f $DirDataTmp/1000G.h3aPos.$Chro".save.fam" ]
then
cp $DirDataTmp/1000G.h3aPos.$Chro".fam" $DirDataTmp/1000G.h3aPos.$Chro".save.fam"
fi
Rscript ../bin/changesex.r $DirDataTmp/1000G.h3aPos.$Chro".save.fam" $DirDataTmp/1000G.h3aPos.$Chro".fam" & 
done
wait
## merge bim
DirData=data/
EntFinal=$DirData//1000G.h3aPos
if [ ! -f $EntFinal".bed" ]
then
ls $DirDataTmp/1000G.h3aPos*.bed|grep -v ".tmp."|sed '1d'|sed 's/.bed//g'| awk '{print $1".bed "$1".bim "$1".fam"}'> allfiles.txt
FirstFile=`ls $DirDataTmp/1000G.h3aPos*.bed|grep -v ".tmp."|head -1|sed 's/.bed//g'`
plink --bfile $FirstFile  --keep-allele-order --threads $NbThread --merge-list allfiles.txt --make-bed --out $EntFinal
fi
### cleaning
#../../h3agwas/assoc/simul-assoc.nf
EntFinalSub=$DirData/1000G.h3aPos"_0.1_0.05"
if [ ! -f $EntFinalSub".bed" ]
then
plink --thin 0.1 --bfile $EntFinal --keep-allele-order --threads $NbThread --make-bed --out $EntFinalSub --maf 0.05
fi
#nextflow -c simul.config run /home/jeantristan/Travail/git/h3agwas/assoc/simul-assoc.nf  --input_dir $DirDataTmp --input_pat `basename $EntFinalSub`  --output_dir phenotype/  --out "pheno." -profile slurm -resume
#rm -rf $DirDataTmp *.vcf.gz 




###clean data 
## simulate phenotype with h3agwas pipleine
# delete  1000G file
#rm -r "ALL.chr"$Chro".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"

