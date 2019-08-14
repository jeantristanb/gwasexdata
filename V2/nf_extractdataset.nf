#!/usr/bin/env nextflow
/*
 * Authors       :
 *
 *
 *      Jean-Tristan Brandenburg
 *
 *  On behalf of the H3ABionet Consortium
 *  2015-2019
 *
 *
 * Description  : Nextflow pipeline for extract dataset of 1000 genomes
 *
 */

//---- General definitions --------------------------------------------------//
def getlistchro(listchro){
 newlistchro=[]
 for(x in listchro.split(',')) {
  splx=x.split("-")
  if(splx.size()==2){
   r1=splx[0].toInteger()
   r2=splx[1].toInteger()
   for(chro in r1..r2){
    newlistchro.add(chro.toString())
   }
  }else if(splx.size()==1){
   newlistchro.add(x)
  }else{
    logger("problem with chro argument "+x+" "+listchro)
    System.exit(0) 
  }
 }
 return(newlistchro)
}



import java.nio.file.Paths

#params.listchro="21-22,X"
#params.fileplkout="res_2122X"
params.listchro="1-22,X"
params.fileplkout="1000G.h3aPos"
params.output_dir="data/"
params.bimf="../data/pos.bim"
params.plk_cpus=10
params.maf = 0.05
params.thin = 0.01
listchro=getlistchro(params.listchro)
listchro_ch=Channel.from(listchro)
listchro_ch2=Channel.from(listchro)
Dir1000G="ftp://ftp.1000genomes.ebi.ac.uk/vol1/ftp/release/20130502/"
//Pattern100G="ALL.chr${chro}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"



process Dl1000G{
   input :
      val(chro) from listchro_ch 
   output :
       set val(chro), file("${file1000G}") into file1000G
   script :
      file1000G= (chro=='X') ? "ALL.chrX.phase3_shapeit2_mvncall_integrated_v1b.20130502.genotypes.vcf.gz" : "ALL.chr${chro}.phase3_shapeit2_mvncall_integrated_v5a.20130502.genotypes.vcf.gz"
      """
      wget -c $Dir1000G/$file1000G
      """
}
bim_ch=Channel.fromPath(params.bimf)
process GetPosbyChro{
    input :
      file bim from bim_ch 
    each chro from listchro_ch2
    output :
      set chro, file(filebed) into bed_chro_ch
    script :
      filebed="chr"+chro+".bed"
      chro2 = (chro=="X") ? "23" : chro
      """
      awk -v chro=$chro2 '{if(\$1==chro)print \$1"\\t"\$4"\\t"\$4"\\t"\$2}' $bim > $filebed
      """
}
file1000G=file1000G.join(bed_chro_ch)

process transfvcfInBed1000G{
   cpus params.plk_cpus
   input :
     set val(chro), file(vcf1000), file(bedfile) from file1000G
     //set val(chro2), file(bedfile) from bed_chro_ch
   output :
     set val(chro), file("${out}.bim"), file("${out}.fam"), file("${out}.bed") into plk_chro
   script :
     //println chro+" "+chro2
     out="chrtmp_"+chro
     """
     plink --vcf $vcf1000  --keep-allele-order --extract range $bedfile  --make-bed -out $out --threads ${params.plk_cpus}
     """
}

process cleanPlinkFile{
    cpus params.plk_cpus
    input :
     set val(chro), file(bim), file(fam), file(bed) from plk_chro
    output : 
     set file("${out}.bim"), file("${out}.fam"), file("${out}.bed") into plk_chro_cl
    script :
     plk=bim.baseName
     out="chr_"+chro
     """
     cp "$bim" "${bim}.save"
     awk '{if(\$2=="."){\$2=\$1":"\$4};print \$0}' "${bim}.save" > "$bim"
     awk '{if(length(\$5)==1 && length(\$6)==1)print \$2}' $bim > ${bim}.wellpos.pos
     plink -bfile $plk  --keep-allele-order --extract  ${bim}.wellpos.pos --make-bed -out $out --threads ${params.plk_cpus}
     """
}
plk_chro_flt=plk_chro_cl.collect()

process mergePlinkFile{
   cpus params.plk_cpus
   input :
      val(allfile) from plk_chro_flt
   publishDir "${params.output_dir}/",  overwrite:true, mode:'copy'
   output :
     set file("${out}.bed"), file("${out}.bim"), file("${out}.fam") into  allplkres_ch
   script : 
     println allfile
     allfile2=allfile.toList().collect {it.toString().replaceFirst(~/\.[^\.]+$/, '')}
     //allfile2=allfile.toList().collect {it.baseName}
     allfile2=allfile2.unique()
     firstbed=allfile2[0]
     allfile2.remove(0)
     out=params.fileplkout
     """ 
     echo "${allfile2.join('\n')}" > listbedfile
     plink --bfile ${allfile2[0]}  --keep-allele-order --threads ${params.plk_cpus} --merge-list listbedfile --make-bed --out $out
     """
}

process thindata{
   cpus params.plk_cpus
   input :
     set file(bed), file(bim), file(fam) from allplkres_ch
   publishDir "${params.output_dir}/",  overwrite:true, mode:'copy'
   output :
     set file("${out}.bed"), file("${out}.bim"), file("${out}.fam") 
   script :
      basename=bed.baseName
      out=basename+"_"+params.thin+"_"+params.maf
      """
      plink --bfile $basename --thin ${params.thin} --maf ${params.maf} --keep-allele-order --make-bed --out $out
      """
}


