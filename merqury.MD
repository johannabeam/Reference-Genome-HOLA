#!/bin/bash
#SBATCH --get-user-env
#SBATCH --nodes=1
#SBATCH --time=24:00:00
#SBATCH --partition=amilan
#SBATCH --qos=normal
#SBATCH --ntasks=2
#SBATCH --mem=32G
#SBATCH --mail-type=end
#SBATCH --mail-user=josephine.paris@colostate.edu
#SBATCH --job-name=CCGP_meryl
#SBATCH --output=./logs/CCGP_meryl.out 
#SBATCH --error=./logs/CCGP_meryl.err


# initialise conda/mamba shell functions
source ~/.bashrc

export MERQURY=/projects/c838015410@colostate.edu/programs/merqury

CCGP_genome=/scratch/alpine/c838015410@colostate.edu/muleys/variant_calling/CCGP_test/GCA_042768445.1_mOdoHem1.0.p_genomic.fna
read1=/scratch/alpine/c838015410@colostate.edu/muleys/merqury/Hi-C_R1.fastq
read1=/scratch/alpine/c838015410@colostate.edu/muleys/merqury/Hi-C_R2.fastq

meryl count k=31 \
  output CCGP_reads.meryl \
  $read1 $read2

cd /scratch/alpine/c838015410@colostate.edu/muleys/merqury/CCGP_merqury_analysis

# merqury.sh [-c] <read-db.meryl> [<mat.meryl> <pat.meryl>] <asm1.fasta> [asm2.fasta] <out>

$MERQURY/merqury.sh CCGP_reads.meryl $CCGP_genome CCGP_k31 > CCGP_k31.log
