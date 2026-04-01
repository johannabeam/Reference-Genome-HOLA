# Reference-Genome-HOLA

Run hifiasm with the Hi-C, pacbio, and UL data 
```
hifiasm -o NA12878.asm -t32 --ul ul.fq.gz --h1 read1.fq.gz --h2 read2.fq.gz HiFi-reads.fq.gz
```

Make K-mer plots - estimated genome size (genomescope2), heterozyg, and duplication rates. Check that the haplotypes made are of simialr size and have similar numbers of contigs/N50, etc. 

Quast - py script to run on the assembly - gives N50, bases, etc
BUSCO - against the bird dataset - see duplications, completeness with the genes

## Hi-C scaffolding

Align the Hi-C data to the contigs (chromap - map Hi-C short reads). Output the bed. Include the -q 0 option to have all the contacts, not just the high quality ones. This is used as the input for yahs. 

