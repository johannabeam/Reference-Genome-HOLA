# Reference-Genome-HOLA
https://evomics.org/2026-workshop-on-genomics/

Need CRAM (unaligned) for Hi-C (and maybe pacbio)
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
