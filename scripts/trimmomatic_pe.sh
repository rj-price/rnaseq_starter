#!/usr/bin/env bash
#SBATCH -J trimmomatic
#SBATCH --partition=medium
#SBATCH --mem=1G
#SBATCH --cpus-per-task=8

# INPUT
F_Reads=$1 
R_Reads=$2
OutDir=$3

# CHECK INPUTS
if [[ ! -f "$F_Reads" || ! "$F_Reads" =~ \.(fq|fastq)\.gz$ || ! -f "$R_Reads" || ! "$R_Reads" =~ \.(fq|fastq)\.gz$ ]]; then
    echo -e "\nERROR: Input files don't exist or have invalid extension (.fq.gz or .fastq.gz required). \n"
    echo -e "Usage: sbatch trimmomatic_pe.sh <fastq_file_1.fq.gz> <fastq_file_2.fq.gz> <output_directory> \n"
    exit 1
fi

if [ -z "$OutDir" ]; then
    echo -e "\nERROR: Output directory argument is missing. \n"
    echo -e "Usage: sbatch trimmomatic_pe.sh <fastq_file_1.fq.gz> <fastq_file_2.fq.gz> <output_directory> \n"
    exit 1
fi

# CREATE OUTPUT FOLDER
mkdir -p "$OutDir"

# CREATE SYMBOLIC LINKS TO READS
ln -s "$F_Reads" "$OutDir"
ln -s "$R_Reads" "$OutDir"
symF_Reads=$(basename "$F_Reads")
symR_Reads=$(basename "$R_Reads")

# OUTPUT PREFIX
Prefix=$(basename "$F_Reads" _1.f*q.gz)

# RUN TRIMMOMATIC
trimmomatic PE -threads 16 -phred33 "$OutDir/$symF_Reads" "$OutDir/$symR_Reads" \
    "$OutDir/$Prefix"_paired_R1.fastq.gz "$OutDir/$Prefix"_unpaired_R1.fastq.gz \
    "$OutDir/$Prefix"_paired_R2.fastq.gz "$OutDir/$Prefix"_unpaired_R2.fastq.gz \
    ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 \
    SLIDINGWINDOW:4:20 \
    HEADCROP:10 \
    MINLEN:80

# CLEANUP
if [[ -s "$OutDir/$Prefix"_paired_R1.fastq.gz && -s "$OutDir/$Prefix"_paired_R2.fastq.gz ]]; then
    rm "$OutDir/$symF_Reads"
    rm "$OutDir/$symR_Reads"
    rm "$OutDir/$Prefix"_unpaired_R1.fastq.gz
    rm "$OutDir/$Prefix"_unpaired_R2.fastq.gz
else
    echo "Output is empty or does not exist."
fi
