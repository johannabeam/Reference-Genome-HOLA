# Reference-Genome-HOLA
https://evomics.org/2026-workshop-on-genomics/

Need CRAM (unaligned) for Hi-C (and maybe pacbio)

PacBio: 50-60Gb - save also as unaligned CRAM
Nanopore: 100-500Gb 
Hi-C: 120-130Gb

## Long- read data stats
Sample | Total Bases (G) | Read_Number |	Read_length(max) |Read_length(mean)	| Read_length(N50) |  Read_mean_quality | Read_quality > Q7 (%) | Read_quality > Q7 (%) |
|--- | --- | --- | --- | --- | --- | --- | --- | --- |
HOLA001 (Nanopore) | 41.33235549 | 1,516,770 |  | 27,250.2 | 51,200 | 9.7 | 80.60% | 71.10% |
HOLA003 (PacBio) | 118.8 | 6,165,499	| 64,292 | 19,273	| 20,579 |   |  |  |

## Hi-C data stats 

Sample name	| library name	| Raw paired reads	| Raw Base(bp)	| Duplication rate(%)	| Effective Rate(%)	| Error Rate(%)	| Q20(%)	| Q30(%)	| GC Content(%) |
|--- | --- | --- | --- | --- | --- | --- | --- | --- | --- |
HOLA_001	| FKDL260057058-1a_L1	| 15,010,383	| 4,503,114,900	| 29.61	| 66.70	| 0.01	| 99.05	| 96.00	| 41.18 |
HOLA_001	| FKDL260057058-1a_L2	| 289,650,255 |	86,895,076,500 |56.10	| 40.94	| 0.01	| 97.99	| 92.61	| 41.43 |
HOLA_001	| FKDL260057058-1a_L3 |	52,070,338	| 15,621,101,400	| 42.31	| 54.59	| 0.01 |	98.84 |	95.61 |	41.25 |

<img width="2100" height="1499" alt="HOLA003 HiFi_reads_frq" src="https://github.com/user-attachments/assets/a8a8bef5-ff48-43f7-b9db-a7e4629b2ac7" />

## Step One
Run hifiasm with the Hi-C, pacbio, and UL data 
```
hifiasm -o NA12878.asm -t32 --ul ul.fq.gz --h1 read1.fq.gz --h2 read2.fq.gz HiFi-reads.fq.gz
```

Make K-mer plots - estimated genome size (genomescope2), heterozyg, and duplication rates. Check that the haplotypes made are of simialr size and have similar numbers of contigs/N50, etc. 

Quast - py script to run on the assembly - gives N50, bases, etc
BUSCO - against the bird dataset - see duplications, completeness with the genes

## Hi-C scaffolding

Align the Hi-C data to the contigs (chromap - map Hi-C short reads). Output the bed. Include the -q 0 option to have all the contacts, not just the high quality ones. This is used as the input for yahs. Run yahs to get the scaffolds now (your contig/scaffold number will decrease now that you have scaffolded, particularly for haplotype1). Yahs uses Hi-C and will introduce gaps (Ns) into your files. It starts the manual curation process so that you don't have to do as much in the  later steps. 

**Juicer** - creates contact maps plots for looking at genomes

**FCS-adaptor** (from NCBI) - will look for contamination sequences in your assembly (will also look for mt genome as well as species that are not your study species). And remove any mt contigs because you'll assemble that later, and flag NUMTs. You can add it back in after curation. 

**Curation pretext** (from Sanger - a nextflow pipeline) This is the program that requires having a computer mouse. 
Give it both assemblies (cat one fasta haplo onto the other haplo)
You've run yahs, you've removed contamination already. This will create all the tracts you will need for manual curation. Use the DToL naming system. So something like bEreAlp1 for bird, species name, and 1 for the first assembly. (or 2 because this is the second assembly!
This will generate gaps, repeat files, telemere file, and all the other files needed for manual curation. 

For manual curation, you can now curate both haplos at the same time. 

## Sex chromosomes
Use the same cat'd haplos for running nucmer. Also rename the reference species' chromosomes so that they look nice and clean (1, 2, Z, etc). Query is haplotypes. Reference is reference. 
Run some nucmer alignments from the yahs to identify the sex chromosomes (use, potentially, synteny from the zebra finch). Z chrom can be easy (use coverge tracks), but W will likely be super fragmented because it is chock full of repeats. For nucmer, do zebra finch, gallus, BARS, GRTI, and HOSP for HOLA. And potentially also run one with the existing HOLA reference. 
nucmer -p genome_aligning_to merged haplo 
Gives you delta file, and use as input for py script (dot script). Takes delta and makes new .coords file. Gives .coords and coords.idx. Go to dot.sandbox.bio. Load your coords and coords.idx into the website. 

**MicroFinder** script for birds. Uses miniprot to find genes. Set aside scaffolds that don't have genes and look them later. Your fasta file will be ordered by genes and size (top left for potential micros). 

For an experienced curator, manual curation can take 3 days. An unexperienced curator might take ... a month. :) 

## Annotation
Sample |	Raw reads |	Raw data	| Effective(%)	| Error(%)	| Q20(%) | Q30(%) | GC(%)
--- | --- | --- | --- | --- | --- | --- | --- |
HOLA_Ovary	| 85245630	| 12.8	| 96.67	| 0.01	| 99.07	| 96.19	| 46.74
HOLA_Liver	| 48341108	| 7.3	| 96.66	| 0.01	| 99.12	| 96.88	| 47.83
HOLA_Brain	| 44711556	| 6.7	| 97.43	| 0.01	| 99.13	| 96.87 | 	46.54
HOLA_Heart	| 60171752	| 9.0	| 98.29	| 0.01	| 99.14	| 96.89	| 48.49
HOLA_Kidney	| 51810156	| 7.8	| 97.34	| 0.01	| 99.11	| 96.80	| 47.95

