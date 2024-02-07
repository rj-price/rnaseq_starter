#!/usr/bin/env bash
#SBATCH -J trimmomatic
#SBATCH --partition=medium
#SBATCH --mem=1G
#SBATCH --cpus-per-task=8

# F reads = $1 
# R reads = $2

# CREATE SYMBOLIC LINKS TO READS
ln -s $1
ln -s $2

# INPUTS
F_Reads=$(basename $1)
R_Reads=$(basename $2)

# OUTPUT PREFIX
Short=$(basename $1 _1.f*q.gz)

# RUN TRIMMOMATIC
trimmomatic PE -threads 16 -phred33 $F_Reads $R_Reads \
    "$Short"_F_paired.fastq.gz "$Short"_F_unpaired.fastq.gz \
    "$Short"_R_paired.fastq.gz "$Short"_R_unpaired.fastq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:4:20 \
    HEADCROP:10 \
    MINLEN:80

# CLEANUP
rm $F_Reads
rm $R_Reads
rm "$Short"_F_unpaired.fastq.gz
rm "$Short"_R_unpaired.fastq.gz