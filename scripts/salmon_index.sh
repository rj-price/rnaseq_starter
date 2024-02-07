#!/usr/bin/env bash
#SBATCH -J salmon
#SBATCH --partition=short
#SBATCH --mem=2G
#SBATCH --cpus-per-task=4

# INPUT
Transcriptome=$1

# OUTPUT PREFIX
Short=$(basename $1 .fasta)

# RUN SALMON INDEX
salmon index -t $Transcriptome -i "$Short"_index --keepDuplicates -k 27
