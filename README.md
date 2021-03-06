# Introduction 
OPERA-MS is a long read metagenomic scaffolding pipline that takes in a set of contigs with a set of short and short long reads to output near-complete individual microbial genomes in your environmental sample. 

It uses the following strategy: a graph partitioning tool called Sigma is used to decompose the metagenomic scaffolding problem into distinct single genome scaffolding problems that are then solved by the single genome scaffolder [OPERA-LG](https://genomebiology.biomedcentral.com/articles/10.1186/s13059-016-0951-y).

The long reads are then used fill the gaps between contigs to produce a final set of scaffolds.

# Installation

### Requirements
- [blasr](https://github.com/PacificBiosciences/blasr) - (version 5.1 and above).
- [racon](https://github.com/isovic/racon) 

 blasr and racon must be in the user's PATH, or alternatively, one could specify the directory in which blasr/racon is contained by modifying the config file. See below for more information on the format of the config file.
 
 

#### Perl Modules
- [Switch](http://search.cpan.org/~chorny/Switch-2.17/Switch.pm)

- [Statistics::Basic](http://search.cpan.org/~jettero/Statistics-Basic-1.6611/lib/Statistics/Basic.pod)

To install OPERA-MS, download and unzip OPERA-MS to a specified directory or `git clone https://github.com/CSB5/OPERA-MS.git`.

All of the tools needed except for BLASR are distributed pre-built. See below for more information on dependencies.

~~~~
cd /path/to/OPERA-MS
make
~~~~

This will build SIGMA and OPERA-LG.

### Testing Installation

A set of test files and a sample configuration file is provided to allow the user to test out the OPERA-MS pipeline. To test it, simply : 
~~~~
cd /path/to/OPERA-MS
perl OPERA-MS.pl sample_config.config
~~~~
This will assemble a small mock-genome in the folder __OPERA-MS/sample_output__. One should see the following statistics after completion :

~~~~
Scaffold statistics:
	N50: 330.47 Kb
	Total length: 9.33 Mb
	Longest scaffold: 1.57 Mb
~~~~

# Running OPERA-MS

### Inputs
OPERA-MS takes in 3 inputs

1) An assembled contigs/scaffolds file in multi-fasta format (e.g. test_dataset/contigs.fa).
2) A long read file to be used in scaffolding (e.g. test_dataset/long_read_1.fa).
3) Paired end reads to be used in scaffolding (e.g. test_dataset/lib_1_1.fa, test_dataset/lib_1_2.fa).

### Executing OPERA-MS

OPERA-MS requires a config file. To run OPERA-MS, input `perl /path/to/OPERA-MS/OPERA-MS.pl <config file>`. 

### Specification for the Configuration file

Configuration files must be formatted in the form :

~~~~
#One space between OPTION and VALUE
<OPTION1> <VALUE1> 
<OPTION2> <VALUE2>
...
<OPTION2> <VALUE3>
~~~~

This is an example of a config file :

~~~~
#This is a comment. 
#We can use absolute or relative paths
CONTIGS_FILE /home/usr/OPERA-MS/test_files/final.contigs_soap.fa #This is an absolute path.
OUTPUT_DIR opera_ms_output/ #Relative path from current working directory.
LONG_READ_FILE test_files/POOL.fa
ILLUMINA_READ_1 test_files/mock1000.R1.fastq.gz
ILLUMINA_READ_2 test_files/mock1000.R2.fastq.gz

NUM_PROCESSOR 20
CONTIG_LEN_THR 500
CONTIG_EDGE_LEN 80
CONTIG_WINDOW_LEN 340
KMER_SIZE 60
~~~~

### Options 
All relative paths are relative to the current working directory of your terminal. All paths can be chosen to be either relative or absolute.

- **CONTIGS_FILE** : `path/to/contigs.fa` - A path to the contigs file.

- **OUTPUT_DIR** : `path/to/results` - Where the final results of OPERA-MS will go.

- **LONG_READ_FILE** : `path/to/long-read.fa` - A path to the long read file.

- **ILLUMINA_READ_1** : `path/to/illum_read1.fa` - A path to the first illumina read file.

- **ILLUMINA_READ_2** : `path/to/illum_read2.fa` - A path to the second complement illumina read file.

- **NUM_PROCESSOR** : `(positive integer)` - The number of processors that this pipeline will use.

- **CONTIG_LEN_THR** : `default : 500` - Threshold for contig clustering. Smaller contigs will not be considered for clustering.

- **CONTIG_EDGE_LEN** : `default : 80` - When calculating coverage of contigs using SIGMA, this number of bases will not be considered from each end of the contig. This is to remove to biases due to reads not matching the edges of contigs. 

- **CONTIG_WINDOW_LEN** : `340` - The window in which coverage is computed by SIGMA for clustering. We recommend using CONTIG_LEN_THR - 2 * CONTIG_EDGE_LEN as the value.

- **KMER_SIZE** : `(positive integer)` - The value of kmer used to produce the assembled contigs/scaffolds.


### Outputs

The outputs will be in OUTPUT_DIR. The scaffolds file before the secondary gap filling procedure is denoted __scaffoldSeq.fasta__. The scaffolds file after filling is denoted __scaffoldSeq.fasta.filled__. Intermediate files are are inside the folder __intermediate_files__. 

### Dependencies

We require the following dependencies:

1) [samtools](https://github.com/samtools/samtools) - (version 0.1.19 or below)
2) [bwa](https://github.com/lh3/bwa)
3) [blasr](https://github.com/PacificBiosciences/blasr) - (version 5.1 and above)
4) [EMBOSS Suite - water](http://emboss.sourceforge.net/)
5) [graphmap](https://github.com/isovic/graphmap) - (version 3.0 and above)
6) [racon](https://github.com/isovic/racon) 

These are pre-built and packaged with OPERA-MS except for blasr and racon. Each binary is placed inside of the __utils__ folder.

If the pre-built tools do not work on the user's machine then OPERA-MS will check the user's PATH for the tool. However, the version that the user is using may be different than the one packaged. Alternatively, to specify a different directory for the dependency, edit the config file and add the line `(tool)_DIR /path/to/dir` as shown below to your config file. Available options include BWA_DIR, BLASR_DIR, WATER_DIR, RACON_DIR, GRAPHMAP_DIR, SAMTOOLS_DIR.

- **(tool)_DIR** : `path/to/tool_directory` - A path to the __directory containing__ the executable file of the specific tool. Otherwise, the tool within the utils/ directory will be used. 

For example, `WATER_DIR /usr/home/water_dir/`. 
