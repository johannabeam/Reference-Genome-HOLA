## Using pretext for Hi-C data:

Files that Damon has sent:

Pretext:
```
penguin1_1.tar.gz - YAHS bed file, q=0
penguin1_2.tar.gz - YAHS bed file, q=0
penguin2_1.tar.gz - YAHS bam file, q=30
penguin2_2.tar.gz - YAHS bam file, q=30
```
```
KPenguin_1 | q=0 | YAHS Bed file | hap1.bed.yahs.out_scaffolds_final.fa
KPenguin_2 | q=0 | YAHS Bed file | hap2.bed.yahs.out_scaffolds_final.fa
KPenguin2_1 | q=30 | YAHS BAM | hap1.bam.yahs.out_scaffolds_final.fa
KPenguin2_2 | q=30 | YAHS BAM | hap2.bam.yahs.out_scaffolds_final.fa
```

Tips and videos for manual curation using Pretextview:

https://github.com/BGAcademy23/manual-curation 
https://www.youtube.com/watch?v=LWy6pwCQNDU 
https://www.youtube.com/watch?v=3IL2Q4f3k3I

Hi-C methodology:

- the name on the tube: APAT_I12
- buffer: TE buffer
- total amount: 19ul
- Volume (ul): 19ul
- concentration (nM or ng/ul): 2.5 ng/ul
- purification method: DNA purification beads (AMPure XP beads)
- Library prep kit used: ACCEL-NGS® 2S PLUS DNA LIBRARY KITS Single Indexing
- i7 index name: Index 12
- i7 index sequence (from 5’ to 3’, adapter sequences not needed): CTTGTA(AT)
- 150bp paired-end
- Library is 860bp long, including the adapters
- Do your libraries contain the Illumina adapter sequences? Yes. I have  used Swift bioscience index (index number 12) 
- Do your samples contain the standard Illumina sequencing primer binding 
site(s)? yes 
- Do your samples contain the standard Illumina indexing primer binding 
site(s)? yes 
- How long is each index? --> Its 8bp long
- here are the indexed used:
```
P5 TruSeq® Universal Adapter:
5’ AATGATACGGCGACCACCGAGATCTACACTCTTTCCCTACACGACGCTCTTCCGATCT 3’ 
P7 TruSeq LT Adapter:
5’ GATCGGAAGAGCACACGTCTGAACTCCAGTCAC*CTTGTA(AT*)CTCGTATGCCGTCTTCTGCTTG 3’
```
- peak of insert size was 980 bp
- "the library is slightly bigger than the usual ones 
(usually Hi-C libraries from Arima are around 750bp). Anyhow, this 
also means that in Arima Hi-C libraries forward and reverse reads 
never overlap. This is why in my opinion, even though the length, I 
dont think this would be any problem for sequencing."

Check the quality of the Hi-C libraries: https://github.com/cerebis/qc3C 

Hi-C data output:
```
29G Jan 24 19:09 HiC_unaligned.cram
24G Apr  1 19:26 HiC_B_unaligned.cram

Total Gb: 53 Gb
```

Damon (@ Sanger)
"We tend to aim for 50GB to get an average of 30x across the genome"
"We aim for 50x to take care of everything and ensure good signal, of course this isn't always possible. So 50 - 75 GB of data for you as an aim, potentially more as we know there is a bias already."

To make the cram files:
`samtools import -@12 -r ID:HiC -r CN:arima -r PU:22HM7CLT3.7.CTTGTAAT -r SM:KP HiC_B.R1.filt.fq.gz HiC_B.R2.filt.fq.gz -o HiC_B_unaligned.cram`

To merge the cram files:
`samtools cat -o HiC_merged.cram HiC_unaligned.cram HiC_B_unaligned.cram`

Download the release for PreTextView here: https://github.com/wtsi-hpag/PretextView/releases  (onto your local computer)

Here's the github for curation pretext: https://github.com/sanger-tol/curationpretext 

following the Sanger protocol as per: https://pipelines.tol.sanger.ac.uk/curationpretext/usage and https://pipelines.tol.sanger.ac.uk/curationpretext 

So the instructions on the website are confusing and wrong. Here's what you actually need to do:

1. Git clone for curation pretext to get a local copy of the pipeline:

inside `/home/parisj/genomic/penguins/genome/pretext/test/`

`git clone https://github.com/sanger-tol/curationpretext.git`

This will create a directory called `curationpretext`, the contents should look like this:

```
total 88K
-rwxr-xr-x  1 parisj genomica 5.1K Jan 31 11:20 CITATIONS.md
-rwxr-xr-x  1 parisj genomica 2.8K Jan 31 11:20 CHANGELOG.md
-rwxr-xr-x  1 parisj genomica 6.7K Jan 31 11:20 README.md
-rwxr-xr-x  1 parisj genomica 1.1K Jan 31 11:20 LICENSE
-rwxr-xr-x  1 parisj genomica 8.9K Jan 31 11:20 CODE_OF_CONDUCT.md
drwxr-xr-x  2 parisj genomica  311 Jan 31 11:20 assets
drwxr-xr-x  2 parisj genomica  188 Jan 31 11:20 bin
drwxr-xr-x  3 parisj genomica   90 Jan 31 11:20 docs
drwxr-xr-x  2 parisj genomica  212 Jan 31 11:20 lib
-rwxr-xr-x  1 parisj genomica 5.5K Jan 31 11:20 modules.json
-rwxr-xr-x  1 parisj genomica 2.3K Jan 31 11:20 main.nf
drwxr-xr-x  4 parisj genomica   46 Jan 31 11:20 modules
-rwxr-xr-x  1 parisj genomica  165 Jan 31 11:20 tower.yml
drwxr-xr-x  3 parisj genomica   27 Jan 31 11:20 subworkflows
-rwxr-xr-x  1 parisj genomica  359 Jan 31 11:20 pyproject.toml
-rw-r--r--  1 parisj genomica   38 Jan 31 11:20 pipeline_template.yml
-rwxr-xr-x  1 parisj genomica  13K Jan 31 11:20 nextflow_schema.json
-rwxr-xr-x  1 parisj genomica 8.5K Jan 31 11:20 nextflow.config
drwxr-xr-x  2 parisj genomica   80 Jan 31 11:20 workflows
drwxr-xr-x  2 parisj genomica  137 Jan 31 15:03 conf
drwxr-xr-x  3 parisj genomica   35 Jan 31 16:09 results
drwxr-xr-x 11 parisj genomica  146 Jan 31 16:35 work
```

2. To test the pipeline, try using their testdata.
Set the directory as a variable:

`TREEVAL_TEST_DATA=/home/parisj/genomic/penguins/genome/pretext/test/`
`cd ${TREEVAL_TEST_DATA}`

Then you need to change the paths in a couple of the files:

`sed -i "s|/home/runner/work/treeval/treeval|${TREEVAL_TEST_DATA}|" TreeValTinyData/gene_alignment_data/fungi/csv_data/LaetiporusSulphureus.gfLaeSulp1-data.csv`

`cd curationpretext`

`sed -i'' -e "s|/home/runner/work/curationpretext/curationpretext|${TREEVAL_TEST_DATA}|" conf/test.config`


check the config file:

`cat conf/test.config`

set the variable for the library caches:
NB: the default is for these to go in ~/.nexflow but we have restrictions on the amount of space in our home directories:

`NXF_SINGULARITY_LIBRARYDIR=/home/parisj/genomic/penguins/genome/pretext/test/cache`

Now you can run:
NB: has to be run on the login node as otherwise singularity doesn't run
NB: you have to run this inside the curationpretext folder

`nextflow run main.nf -profile test,singularity --outdir /home/parisj/genomic/penguins/genome/pretext/test/output`



https://www.ncbi.nlm.nih.gov/datasets/genome/GCA_024206055.2/ 


## Running it on the penguin genome

There were some errors I had to fix to get this running. Should all be updated on the sanger-tol website and github now

Steps:

1. Git clone the sanger-tol/curationpretext into:

`/home/parisj/genomic/penguins/genome/sanger-tol/curationpretext`

2. Make a config file for disva cluster and store it in

`/home/parisj/genomic/penguins/genome/sanger-tol/curationpretext/conf/disva_univpm.config`

It looks like this:

```
// Nextflow config for running on the DiSVA-HPC at UNIVPM
params {
    config_profile_description = 'DiSVA-HPC at UNIVPM profile.'
    config_profile_contact = 'Josephine Paris (@josieparis)'
 }

singularity {
    enabled = true
    autoMounts = true
}

params {
    max_memory = 64.GB
    max_cpus = 16
    max_time = 12.h
}(base) [parisj@disva1 conf]$ emacs disva_univpm.config
(base) [parisj@disva1 conf]$ cat disva_univpm.config
// Nextflow config for running on the DiSVA-HPC at UNIVPM
params {
    config_profile_description = 'DiSVA-HPC at UNIVPM profile.'
    config_profile_contact = 'Josephine Paris (@josieparis)'
 }

singularity {
    enabled = true
    autoMounts = true
}

params {
    max_memory = 64.GB
    max_cpus = 16
    max_time = 12.h
}
```

Put all the files in a location that can be read, 

```
nextflow run sanger-tol/curationpretext \
  --input { input.fasta } \ ## note that this is the scaffolded (e.g. by yahs!) genome input (e.g. hap1)
  --cram { path/to/cram/ } \ ## note this is a path to the indexed cram file! Not the file itself. So it needs to be the only file in this directory
  --pacbio { path/to/pacbio/fasta/ } \ ## note this is a path to the indexed cram file! Not the file itself. So it needs to be the only file in this directory
  --sample { default is "pretext_rerun" } \ ## can be whatever you wish
  --teloseq {TTAGGG} \ ## standard teloseq for vertebrates 
  --outdir { OUTDIR } \
  -profile <docker/singularity/{institute}> \ ## if using a config file (see below), you don't need the institute config file
  -entry <NULL/MAPS_ONLY> \ ## don't use this parameter if you want it to do ALL_FILES, i.e. leave this blank. If you want maps only you can use this
```

3. Before running you need to set a couple of variables to stop nextflow / singularity filling up your home directory (due to reduced space here)
Either set these in your terminal or in your .bash_profile

`NXF_OPTS='-Xms1g -Xmx4g'` - this sets the memory usageof Java within nextflow

`NXF_SINGULARITY_LIBRARYDIR=/home/parisj/genomic/penguins/genome/pretext/test/cache` - this sets the path for the library cache

Also, by default, the .sif file for singularity will be installed in ~/.singularity 

To change this, make the file somewhere else where you have more space and then symlink it into your home, 

e..g I made it here: 
`/cluster_data/home/genomic/penguins/genome/.singularity/`

and symlinked it in home:
```
cd 
ln -s /cluster_data/home/genomic/penguins/genome/.singularity/ .`
```

4. Now you can run nextflow like so:


I am here:
`/cluster_data/home/genomic/penguins/genome`


```
nextflow run sanger-tol/curationpretext \
--input /cluster_data/home/genomic/penguins/genome/hi-C-map/output/run3/yahs/error_cor/hap1/yahs.out_scaffolds_final.fa \
--pacbio /cluster_data/home/genomic/penguins/genome/genomic_data/pacbio/ \
--cram /cluster_data/home/genomic/penguins/genome/genomic_data/hic-arima/ \
--sample "KP_hap1_pretext" \
--teloseq TTAGGG \
--outdir /cluster_data/home/genomic/penguins/genome/pretext \
-profile singularity -entry ALL_FILES \
-c /cluster_data/home/genomic/penguins/genome/sanger-tol/curationpretext/conf/disva_univpm.config
```

5. Check the progress with htop (as you are running on the login node)

Also check the .nextflow.log file, it's important to get the run information from here


6. I tried to stop and cancel the run to see if the `resume` parameter works:

https://www.nextflow.io/blog/2019/demystifying-nextflow-resume.html 

To check the run number of your nextflow, you can look at the .nextflow.log and get the name of the run, e.g.:sleepy_gutenberg, sick_brattain

Then check the SessionID assigned to this run:
run:
`nextflow log`

This will print something like:

```
TIMESTAMP          	DURATION	RUN NAME        	STATUS	REVISION ID	SESSION ID                          	COMMAND                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   
2024-02-13 11:50:14	2m 22s  	jovial_booth    	ERR   	ec8c7088e5 	54f93972-c326-40a5-9690-de88f25a1b53	nextflow run sanger-tol/curationpretext --input /cluster_data/home/genomic/penguins/genome/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap1.p_ctg.fa --pacbio /cluster_data/home/genomic/penguins/genome/genomic_data/pacbio/ --cram /cluster_data/home/genomic/penguins/genome/genomic_data/hic-arima/ --sample KP_hap1_pretext --teloseq TTAGGG --outdir /cluster_data/home/genomic/penguins/genome/pretext -profile singularity -c /cluster_data/home/genomic/penguins/genome/sanger-tol/curationpretext/conf/disva_univpm.config                     
2024-02-13 12:16:13	-       	sick_brattain   	-     	ec8c7088e5 	54f93972-c326-40a5-9690-de88f25a1b53	nextflow run sanger-tol/curationpretext/ -resume jovial_booth                                                                                                                                                                                                                                                                                                                                                                                                                                                                                             
2024-02-13 12:17:12	-       	sleepy_gutenberg	-     	ec8c7088e5 	54f93972-c326-40a5-9690-de88f25a1b53	nextflow run sanger-tol/curationpretext --input /cluster_data/home/genomic/penguins/genome/hi-C-map/genomes_indexed/AptPat.HiFi.asm.hic.hap1.p_ctg.fa --pacbio /cluster_data/home/genomic/penguins/genome/genomic_data/pacbio/ --cram /cluster_data/home/genomic/penguins/genome/genomic_data/hic-arima/ --sample KP_hap1_pretext --teloseq TTAGGG --outdir /cluster_data/home/genomic/penguins/genome/pretext -profile singularity -c /cluster_data/home/genomic/penguins/genome/sanger-tol/curationpretext/conf/disva_univpm.config -resume jovial_booth
```

To resume, you can do this (in theory, I can't get it to work!):


```
nextflow run -resume 54f93972-c326-40a5-9690-de88f25a1b53 --max_cpus 2 sanger-tol/curationpretext \
--input  /cluster_data/home/genomic/penguins/genome/hi-C-map/output/run3/yahs/error_cor/hap1/yahs.out_scaffolds_final.fa \
--pacbio /cluster_data/home/genomic/penguins/genome/genomic_data/pacbio/ \
--cram /cluster_data/home/genomic/penguins/genome/genomic_data/hic-arima/ \
--sample "KP_hap1_pretext" \
--teloseq TTAGGG \
--outdir /cluster_data/home/genomic/penguins/genome/pretext-hap1 \
-profile singularity -entry ALL_FILES \
-c /cluster_data/home/genomic/penguins/genome/sanger-tol/curationpretext/conf/disva_univpm.config \
```

NB: the number of cpus specified in the config file doesn't seem to be read properly. You need to specify this on the command line 

## Update
Damon is updating the branch as I go, to make fixes. 

Keep using this one for now: https://github.com/sanger-tol/curationpretext/tree/dp24_treeval_parity 

To update (inside the sanger-tol/curationpretext directory):

```
git branch dp24_treeval_parity
git fetch --all
git checkout dp24_treeval_parity
git pull
```

Then run:

```
nextflow run --max_cpus 8 sanger-tol/curationpretext \
--input  /cluster_data/home/genomic/penguins/genome/hi-C-map/output/run3/yahs/error_cor/hap1/yahs.out_scaffolds_final.fa \
--longread /cluster_data/home/genomic/penguins/genome/genomic_data/pacbio/ --longread_type hifi \
--cram /cluster_data/home/genomic/penguins/genome/genomic_data/hic-arima/ \
--sample "KP_hap1_pretext" \
--teloseq TTAGGG \
--outdir /cluster_data/home/genomic/penguins/genome/pretext-hap1 \
-profile singularity -c /cluster_data/home/genomic/penguins/genome/sanger-tol/curationpretext/conf/disva_univpm.config
```

FYI, Camilla was worried about contamination in the data stealing the Hi-C signal. So she ran both yahs scaffolded assemlies through ASCC:

"We have ASCC but it isn't really in a public state at the minute, it generates a bunch of plots and data that can be injected into Blob. I just have to finish writing the Nextflow version. One of the tools you could run is FCS - https://github.com/ncbi/fcs ASCC wraps around this. It is a memory hog though"

Camilla's response, "Josie, your assemblies are clean, no contamination. The only thing I found was mitochondrial DNA in hap2 (scaffold_598), which I removed. This is the decontaminated fasta, please use this hap2 fasta to generate the new map when you have the hic topup. Scaffold_598 is twice the size of the expected mitochondrial genome (around 34 Kb), so it might have assembled well (just guessing)"

The new decontaminated file is called, `hap2.bam.yahs.out_scaffolds_decont.final.fa.gz`

and it's in:

`/cluster_data/home/genomic/penguins/genome/hi-C-map/output/run3/yahs/error_cor/hap2`


## Curating in pretext View

Load the nucmer alignments here: https://dot.sandbox.bio/ 


## Curation update
We had an issue in Pretext View where some of the scaffolds couldn't be placed as they weren't loaded in the pretext map. 
When they didn't load they looked like hap1_xxx(0). If they can be placed they look like hap1_xxx(1). 

So I went through all the scaffolds on both haplotypes and ...




## Curation final notes

Files received from Camilla (August 2024) with the following files on Google drive

https://drive.google.com/drive/folders/1bvzHEoaixsrvzbyeAiYaLdygowdLiPLB :

<img width="1158" alt="Screenshot 2024-08-12 at 11 58 38" src="https://github.com/user-attachments/assets/afe6fa95-8019-4714-82fb-08f928956334">

They are here:

`/Users/josie/Dropbox/Penguins/genome_analysis/Camilla_curated_genome_files_August_2024`

```
KP.hap2.1.primary.curated.renamed.pretext
KP.micros_hap1.MicroFisher.order.tsv
KP.micros_hap2.MicroFisher.order.tsv
KP_hap1.1.primary.curated.fa
KP_hap1.1.primary.curated.pretext
KP_hap2.1.primary.curated.fa
```

For the MicroFisher files, the first column is the scaffold name and the second is the number of potential genes in it. 

In the end, Camilla made the final fastas for us. They can be found in the Google Drive too. I've made a local copy in the folder for the Genome Assembly on Google Drive. 

### Summary of fasta files for Hap1:

| File | No. of scaffolds | Notes|
| ------------- | ------------- | ------------- |
| hap1_yahs.final.raw.fasta   |  685 | raw yahs scaffold file |
| KP_hap1.1.primary.curated.fa   | 45 | curated scaffold file - contains only scaffolds with gene content  |
| KP_hap1.final.primary.curated.fa  | 659 | Final curated genome |


### Summary of fasta files for Hap2:

| File | No. of scaffolds | Notes|
| ------------- | ------------- | ------------- |
| hap2_yahs.final.raw.fasta   |  733 | raw yahs scaffold file |
| KP_hap1.1.primary.curated.fa   | 53 | curated scaffold file  - from Camilla  |
| KP_hap2.final.primary.curated.fa   | XX | curated scaffold file + scaffolds not present concatenated and final fasta file  |


## how to run juicer:

```
#!/bin/bash
#PBS -l select=1:ncpus=16:mpiprocs=16
#PBS -q workq

BAM=/cluster_data/home/genomic/zygaena/assembly/scaffolding/chromap/output/ZyTra.HiFi.asm.p_ctg.fa.pol.purged.bam
AGP=/cluster_data/home/genomic/zygaena/assembly/scaffolding/yahs/output/10k.correction/yahs.out_scaffolds_final.agp
REF=/cluster_data/home/genomic/zygaena/assembly/assembly_versions/hifiasm/run4/polished/1run/purged/ZyTra.HiFi.asm.p_ctg.fa.PolcaCorrected.purged.fa
SD1=/cluster_data/home/genomic/software/yahs
SD2=/cluster_data/home/genomic/software/juicertools
WD=/cluster_data/home/genomic/zygaena/assembly/scaffolding/yahs/output/10k.correction/juicer

#mkdir -p $WD
cd $WD

$SD2/juicer pre -a -o out_JBAT $BAM $AGP $REF.fai > out_JBAT.log 2>&1

(java -jar -Xmx70G $SD2/juicer_tools.1.9.9_jcuda.0.8.jar pre out_JBAT.txt out_JBAT.hic.part <(cat out_JBAT.log | grep PRE_C_SIZE | awk '{print $2" "$3}')) && (mv out_JBAT.hic.part out_JBAT.hic)
```





