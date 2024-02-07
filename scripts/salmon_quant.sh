#!/usr/bin/env bash
#SBATCH -J salmon
#SBATCH --partition=long
#SBATCH --mem=2G
#SBATCH --cpus-per-task=4

# INPUTS
Read_F=$1
Read_R=$2
Index=$3

# OUTPUT PREFIX
Short=$(basename $1 _F_paired.fastq.gz)

# RUN SALMON QUANT
salmon quant \
    -i $Index \
    -l A \
    -1 $Read_F \
    -2 $Read_R \
    --validateMappings \
    -p 4 \
    --numBootstraps 1000 \
    --dumpEq \
    --seqBias \
    --gcBias \
    -o "$Short"_quant
