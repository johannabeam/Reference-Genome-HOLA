# Reference-Genome-HOLA
https://evomics.org/2026-workshop-on-genomics/

Need CRAM (unaligned) for Hi-C (and maybe pacbio)

PacBio: 50-60Gb - save also as unaligned CRAM
Nanopore: 100-500Gb 
Hi-C: 120-130Gb

## Long- read data stats
Sample | Total Bases (G) | Read_Number |	Read_length(max) |Read_length(mean)	| Read_length(N50) |  Read_mean_quality | Read_quality > Q7 (%) | Read_quality > Q7 (%) |
|--- | --- | --- | --- | --- | --- | --- | --- | --- |
HOLA002 (Nanopore) | 41.3| 1,516,770 |  | 27,250.2 | 51,200 | 9.7 | 80.60% | 71.10% |
HOLA003 (PacBio) | 118.8 | 6,165,499	| 64,292 | 19,273	| 20,579 |   |  |  |

### PacBio distrubution
<img width="2100" height="1499" alt="HOLA003 HiFi_reads_frq" src="https://github.com/user-attachments/assets/a8a8bef5-ff48-43f7-b9db-a7e4629b2ac7" />

### Nanopore distribution
<img width="600" height="600" alt="newplot (2)" src="https://github.com/user-attachments/assets/29b6859c-6b06-40c8-8e32-28fdfe31c492" />


## Hi-C data stats 

Sample name	| library name	| Raw paired reads	| Raw Base(bp)	| Duplication rate(%)	| Effective Rate(%)	| Error Rate(%)	| Q20(%)	| Q30(%)	| GC Content(%) |
|--- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
HOLA_001	| FKDL260057058-1a_L1	| 15,010,383	| 4,503,114,900	| 29.61	| 66.70	| 0.01	| 99.05	| 96.00	| 41.18 |
HOLA_001	| FKDL260057058-1a_L2	| 289,650,255 |	86,895,076,500 |56.10	| 40.94	| 0.01	| 97.99	| 92.61	| 41.43 |
HOLA_001	| FKDL260057058-1a_L3 |	52,070,338	| 15,621,101,400	| 42.31	| 54.59	| 0.01 | 98.84 |	95.61 |	41.25 |
HOLA_001    | FKDL260057058-1a_L4 | 300,549,292 | 90,164,787,600 | 55.24 | 41.41 | 0.01 | 98.06 | 93.00 | 41.41 |
HOLA_001    | FKDL260057058-1a_L5 | 52,225,220 | 15,667,566,000 | 35.40 | 61.01 | 0.01 | 98.75	| 94.84 | 41.22 |

## Start here!
Below are all of the steps used in generating the new Horned Lark reference genome. All of the code/jobs run are in the code directory. Note that some jobs will be run more than once (BUSCO, quast, nucmer) so the numbering on each job script is not perfect, but will generally give you the steps in order. 


### 01_run_hifiasm.job
Run hifiasm with the Hi-C, PacBio, and ultra-long reads data. 

Below is the basic formula for running hifiasm, but the job I wrote and used is in the code folder. 
```
hifiasm -o NA12878.asm -t32 --ul ul.fq.gz --h1 read1.fq.gz --h2 read2.fq.gz HiFi-reads.fq.gz
```
Transform your gfas into fas:
```
awk '/^S/{print ">"$2"\n"$3}' HOLA001_amem.asm.hic.hap1.p_ctg.gfa > HOLA_hap1.fa
awk '/^S/{print ">"$2"\n"$3}' HOLA001_amem.asm.hic.hap2.p_ctg.gfa > HOLA_hap2.fa
```
### 02_run_quast.job
Look at the metrics for you two haplotypes and make sure that the estimates sizes of each haplotype are similar. One will be larger than the other - that's fine. This will give you your first look at scaffold N50, number of scaffolds, L50, etc.

### 03_jellyfish.job
Make K-mer plots - estimated genome size (genomescope2), heterozyg, and duplication rates. Check that the haplotypes made are of simialr size and have similar numbers of contigs/N50, etc. 

[Genomescope plots link](http://genomescope.org/genomescope2.0/analysis.php?code=yR2k1uRZyKFHM3er60Og)


### 07_run_busco.job
Yes, the numbering is out of order, but you can also run BUSCO now (you will run it later too) on your two haplotypes to make sure everything looks good. You can download different BUSCO gene sets. For songbirds, make sure to use the passeriformes set, not the aves set. 

## Hi-C scaffolding

### 04_chromap_index.job and 05_run_chromap.job
NOTE: the 05_run_chromap.job includes the indexing, so you don't have to run 04 first to index anymore. 

Align the Hi-C data to the contigs (chromap - map Hi-C short reads). Output the _pairs_ file, NOT the bed file. Include the -q 0 option to have all the contacts, not just the high quality ones. This is used as the input for yahs. 

### 06_run_yahs.job
Run yahs to get the scaffolds now (your contig/scaffold number will decrease now that you have scaffolded, particularly for haplotype1). Yahs uses Hi-C and will introduce gaps (Ns) into your files. It starts the manual curation process so that you don't have to do as much in the  later steps. 

Make your unaligned crams for each lane
```
samtools import -@12 -r ID:HiC -r CN:Novogene -r PU:L3 -r SM:HOLA HOLA_001_L3_1.clean.rd.fq.gz HOLA_001_L3_2.clean.rd.fq.gz -o HiC_L3_unaligned.cram
```
To merge the cram files: 
```
samtools cat -o HiC_merged_HOLA.cram HiC_L1_unaligned.cram HiC_L2_unaligned.cram HiC_L3_unaligned.cram
```
### 08_run_juicer.job
**Juicer** - creates contact maps plots for looking at genomes. A little easier and faster to run that starting with curation pretext

### 09_run_fcs_gx.job
*This is the job I could not get to run on the cluster and had to run on Galaxy instead.*

**FCS-gx** (from NCBI) - will look for contamination sequences in your assembly (will also look for mt genome as well as species that are not your study species). And remove any mt contigs because you'll assemble that later, and flag NUMTs. You can add it back in after curation. 

### 10_run_curpretext.job
**Curation pretext** (from Sanger - a nextflow pipeline) 

For manual curation, you can now curate both haplos at the same time. They should be interleaved together so that the fasta files go scaffold1_hap1, scaffold2_hap2, etc etc. 
Give it both assemblies: cat one fasta haplo onto the other fasta haplotype:
```
awk '/^>/{ count[$0]++ if(count[$0]==1) print $0 "_hap1" else print $0 "_hap2" next } {print}' HOLA_hap1_hap2_test_scaffolds_final.fa > HOLA_hap1_hap2_renamed.fa
```

You've run yahs and you've removed contamination already. CurationPretext will create all the tracts you will need for manual curation, which is using PretextView on your personal computer. 

Use the DToL naming system for CurationPretext. For a bird, use the prefix of 'b', then scientific species name, abreviated. So, something like bEreAlp1 for bird, species name, and 1 for the first assembly. (Or 2 because this is the second assembly!)

This will generate gaps, repeat files, telemere file, and all the other files needed for manual curation. 

Curation pretext using HiFi in fasta format:
Take bams and turn them into fasta
```
samtools fasta -@8 input.hifi_reads.bam | gzip > HOLA003_hifi.fasta.gz
```
And takes the Hi-C in cram format (and needs the indexed crai as well).

## Manual Curation
### Manual curation is done on a personal computer using PretextViewAI. 
_NOTE: I do not use any of the AI features of this program when manually curating a genome_

There are several [good tutorials online]([url](https://curation.tol.sanger.ac.uk/)) for curating a genome. It is recommended to use a mouse when manually curating, but you can just use your trackpad and keyboard as well. There is a document with keyboard shortcuts available in the code folder as well. 

For an experienced curator, manual curation can take 3 days. An unexperienced curator might take ... a month. :) 


## Sex chromosomes
### run_nucmer.job
Use the same cat'd haplos for running nucmer. Also rename the reference species' chromosomes so that they look nice and clean (1, 2, Z, etc). Query is haplotypes. Reference is reference. 
Run some nucmer alignments from the yahs output to identify the sex chromosomes (use, potentially, synteny from the zebra finch). Z chromosome can be easy (use coverge tracks), but W will may be super fragmented because it is chock full of repeats. For nucmer, do zebra finch, Gallus gallus (chicken), Barn Swallow, Great Tit, and House Sparrow for the Horned Lark genome. And also run one with the existing Horned Lark reference (scaffold level, highly fragmented).
```
nucmer -p genome_aligning_to merged_haplo 
```
Nucmer will give you the delta file, and use as input for py script (dot script). It takes the delta and makes new .coords and a coords.idx file. Go to dot.sandbox.bio. Load your coords and coords.idx into the website. Voila - look at your dot plot synteny comparison between the two species!

### 11_run_microfinder.job
**MicroFinder** This is a script for fishing out microchromosomes in bird genomes. It uses miniprot to find genes. Set aside scaffolds that don't have genes and look them later. Your fasta file will be ordered by genes and size (top left for potential micros). 


### 12_run_mitoHiFi.job
**Mitochondrial Genome**
mitoHiFi for finding the mt genome! Download your species' mt genome from NCBI (if available), or a closely related species. This program looks for circularized reads in your raw HiFi data to fish out the mitochondrial genome. Given the use of long reads, sometimes this means you have a more complete mt genome, and occasionally you see mt genomes with tandem repeats. 


## Annotation
Braker4 for doing the rna seq annotations.

## Repeats and Transposable Elements
Use EarlGrey for annotating TEs and repeats in your genome. I have used a custom repeat library from some unpublished work, but you can use dfam 4, or whatever Josie used for the King Penguin Genome. 

### This is the raw data from my mRNA seq data
Sample |	Raw reads |	Raw data	| Effective(%)	| Error(%)	| Q20(%) | Q30(%) | GC(%)
--- | --- | --- | --- | --- | --- | --- | --- |
HOLA_Ovary	| 85245630	| 12.8	| 96.67	| 0.01	| 99.07	| 96.19	| 46.74
HOLA_Liver	| 48341108	| 7.3	| 96.66	| 0.01	| 99.12	| 96.88	| 47.83
HOLA_Brain	| 44711556	| 6.7	| 97.43	| 0.01	| 99.13	| 96.87 | 	46.54
HOLA_Heart	| 60171752	| 9.0	| 98.29	| 0.01	| 99.14	| 96.89	| 48.49
HOLA_Kidney	| 51810156	| 7.8	| 97.34	| 0.01	| 99.11	| 96.80	| 47.95

