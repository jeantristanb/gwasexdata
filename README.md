# gwasexdata
Example of data set of chromosome 1 (subsample of 1000G : position on chromosome 1 for dna cheap h3africa) for GWAS with phe
  * `simul.config`  : config file to simulate phenotype
  * `extract_1000GAndPosChr1.bash`  : bash script to generate data and simulate phenotype
  * Plink file of gwas :  directory `plkfile`
  * Phenotype simulated is in Chr1Test/simul/ :
    * phenotype simulated with phenosim : 1000G.h3aPos.1.vcf.ms._NumSimulation_.pheno.pheno
    * positions used to simulated phenotype with phenosim : 1000G.h3aPos.1.vcf.ms._NumSimulation_.pheno.causal
