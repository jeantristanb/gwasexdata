# Build example of gwas data set
## Objectifs
Objectif : using 1000 genomes and simulation process, build gwas data set for qc, imputation, gwas and post analysis for h3africa pipeline see 


Example of data set of chromosome 1 (subsample of 1000G : position on chromosome 1 for dna cheap h3africa) for GWAS with phe
  * Todo for V2: 
      * 1 chromosome doesn't work for bolt 
      * problem of I/D in fastlmm
      * check keep allele order for plink
  * V1 : 
    * `simul.config`  : config file to simulate phenotype
    * `extract_1000GAndPosChr1.bash`  : bash script to generate data and simulate phenotype
    * Plink file of gwas :  directory `plkfile`
    * Phenotype simulated is in Chr1Test/simul/ :
      * phenotype simulated with phenosim : 1000G.h3aPos.1.vcf.ms._NumSimulation_.pheno.pheno
      * positions used to simulated phenotype with phenosim : 1000G.h3aPos.1.vcf.ms._NumSimulation_.pheno.causal


## Built With

* []() - The web framework used
* [Maven](https://maven.apache.org/) - Dependency Management
* [ROME](https://rometools.github.io/rome/) - Used to generate RSS Feeds

## Contributing

Please read [CONTRIBUTING.md](https://gist.github.com/PurpleBooth/b24679402957c63ec426) for details on our code of conduct, and the process for submitting pull requests to us.

## Versioning

We use [SemVer](http://semver.org/) for versioning. For the versions available, see the [tags on this repository](https://github.com/your/project/tags).


## Authors

* **Brandenburg ean-tristan** 
* **participant ha3bionet consortium** 

## License

