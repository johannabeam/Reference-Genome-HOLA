#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH -p acpu
#SBATCH --qos=cpu-normal
#SBATCH --account=XXXXX
#SBATCH --mail-type=end
#SBATCH --mail-user=XXXXX
#SBATCH --job-name=jellyfish_HOLA
#SBATCH --output=code/HOLA-genoscape/jellyfish.out
#SBATCH --error=code/HOLA-genoscape/jellyfish.err

module load miniforge
mamba activate assembly

RAW_PB=/ref_raw_data/rawdata/Data-X202SC26024927-Z01-F001/HOLA003/Sequel-Revio/FPAC260157265-1A
JELLY_DIR=/HOLA/jellyfish
mkdir -p $JELLY_DIR


# Count k-mers
jellyfish count -C -m 21 -s 5G -t 16 \
    -o /HOLA003.jf \
    <(zcat $RAW_PB/HOLA003.hifi_reads.fastq.gz)

# Generate histogram for genomescope2
jellyfish histo -t 16 \
    /HOLA003.jf \
    > /HOLA003.histo

