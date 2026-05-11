#!/bin/bash
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=64G
#SBATCH --time=12:00:00
#SBATCH -p amilan
#SBATCH --qos=normal
#SBATCH --account=csu116_alpine1
#SBATCH --mail-type=end
#SBATCH --mail-user=c838062464@colostate.edu
#SBATCH --job-name=jellyfish_HOLA
#SBATCH --output=/projects/c838062464@colostate.edu/code/HOLA-genoscape/jellyfish.out
#SBATCH --error=/projects/c838062464@colostate.edu/code/HOLA-genoscape/jellyfish.err

module load miniforge
mamba activate assembly
RAW_PB=/scratch/alpine/c838062464@colostate.edu/HOLA/ref_raw_data/rawdata/Data-X202SC26024927-Z01-F001/HOLA003/Sequel-Revio/FPAC260157265-1A
JELLY_DIR=/scratch/alpine/c838062464@colostate.edu/HOLA/jellyfish
mkdir -p $JELLY_DIR


# Count k-mers
jellyfish count -C -m 21 -s 5G -t 16 \
    -o /scratch/alpine/c838062464@colostate.edu/HOLA/jellyfish/HOLA003.jf \
    <(zcat $RAW_PB/HOLA003.hifi_reads.fastq.gz)

# Generate histogram for genomescope2
jellyfish histo -t 16 \
    /scratch/alpine/c838062464@colostate.edu/HOLA/jellyfish/HOLA003.jf \
    > /scratch/alpine/c838062464@colostate.edu/HOLA/jellyfish/HOLA003.histo

