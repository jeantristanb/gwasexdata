## take of position postion dna chip
DirData=data/
mkdir -p $DirData/
Chro=1
FileBimH3africa=""
## dpwload 1000G data
wget ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/"ALL.chr"$Chro".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
listposchip=$DirData/"lispos."$Chro".bed"
## extract positon of h3africa from a bim file  : bed output
if [ ! -f $listposchip ]
then
awk -v chro=$Chro '{if($1==chro)print $1"\t"$4"\t"$4"\t"$2}' $FileBimH3africa > $listposchip
fi

## build  plink file with vcf and position
if [ ! -f $DirData"/1000G.h3aPos."$Chro".vcf.bed" ]
then
plink --vcf ALL.chr"$Chro".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz --extract range $listposchip --make-bed -out $DirData"/1000G.h3aPos."$Chro".vcf"
fi
if [ ! -f plkfile/1000G.h3aPos.1.vcf.save.fam ]
then
cp plkfile/1000G.h3aPos.1.vcf.fam plkfile/1000G.h3aPos.1.vcf.save.fam
fi
Rscript changesex.r

## simulate phenotype with h3agwas pipleine
nextflow -c simul.config run h3agwas/assoc/simul-assoc.nf -r hackaton --input_dir $DirData --input_pat "1000G.h3aPos."$Chro".vcf"  --output_dir "Chr"$Chro"Test"/  --out "pheno."$Chro --profile $1 -resume
# delete  1000G file
rm -r "ALL.chr"$Chro".phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"

