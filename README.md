# Build Gwas Data Set
Objectif : using 1000 genomes and simulation process as [phenosim](append link), build gwas data set for qc, imputation, gwas and post analysis for [h3africa](append link) pipeline and script related for testing 
## Data set generation 
### General approach 
  * prepare data for simulation of phenotype and qc : 
    * Download file from 1000 Genomes project (release:20130502), transform data in plink format, change sex of participant in fam
  * Simulate phenotype using [h3agwas/assoc/simul-assoc.nf](append link) with [phenosim](), [plink]() ...
  * qc script to clean data (not in version 1) [h3agwas/qc/main.nf](append link)
  * imputed script to imputated data (not in version 1) [append link]()
  * gwas script for gwas  [h3agwas/assoc/main.nf](append link)
  * post gwas analysis [h3agwas/assoc/](append link)

### Version 2 
  * version 2 is in directory [V2](Append link) 
  * Improvment, fixed  :
      * V1, 1 chromosome have been generate,  doesn't work for bolt 
      * Look like roblem of I/D in fastlmm
      * check keep allele order for plink
      * append  : qc script, imputation script
### Version 1 
* Example of data set of chromosome 1 (subsample of 1000G : position on chromosome 1 for dna cheap h3africa 
* version 1 is in directory [V1](Append link) 
* folder description 
 * `extract_1000GAndPosChr1.bash`  : bash script to generate data and simulate phenotype, output :
  * simul.config : config file of h3agwas pipeline 
  * `plkfile` folder : contains for chromosome 1 plink file of 1000 genomes and position of h3africa array 
  * `Chr1Test/simul/` :
    * ̀ 1000G.h3aPos.1.vcf.ms.\_NumSimulation\_.pheno.pheno` : phenotype simulated for each individuals
    * `1000G.h3aPos.1.vcf.ms.\_NumSimulation\_.pheno.causal` : positions used to simulated phenotype with phenosim : 1000G.h3aPos.1.vcf.ms.\_NumSimulation\_.pheno.causal
* gwas : 
 * `gwas.config` : gwas config file for ha3gwas pipeline 
 * `gwas.bash` : bash to launch gwas config with slurm singularity

### how to use 
clone branch => todo 
"""
git clone jeantristanb/
"""
data of chromosome is already generated, but if you want generated again
```
profile= ##should be slurm, singularity, slurmSingularity => need to append default?
cd V1
rm -rf Chr1Test plkfile
bash extract_1000GAndPosChr1.bash $profile
do a gwas using singularity
```
nextflow -c launchgwas.config run h3abionet/h3agwas/assoc/main.nf -resume  -profile singularity -r hackathon
```

do a gwas using singularity
'''
nextflow -c launchgwas.config run h3abionet/h3agwas/assoc/main.nf -resume  -profile slurmSingularity -r hackathon
'''


## Data
* folder `data`
* ̀ integrated\_call\_samples_v2.20130502.ALL.ped` : information for 1000 genomes sample
* ̀ bim file for h3africa array`: to do
## Bin : 
* folder `bin`
* changesex.r : Rscript to change fam file and append sex
 

## General script 

## Requirements 
* shell/ bash
* [nextflow](Append Link) - launch  
* [plink](plink)
* [R]() R-project
* [singularity](Append Link) or install software dependency of pipeline :
  * [h3abionet/h3agwas]() branch hackathon at 9/08/19
  * [h3abionet/imputation]()

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).


## Authors

* **Brandenburg jean-tristan** 
* **Participant ha3bionet consortium, h3agwas, ha3imputation** 

## License

