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
if [[ -f "$F_Reads" && "$F_Reads" =~ \.(fq|fastq)\.gz$ && -f "$R_Reads" && "$R_Reads" =~ \.(fq|fastq)\.gz$ && -n "$OutDir" ]]; then
    # CREATE OUTPUT FOLDER
    mkdir -p "$OutDir"

    # OUTPUT PREFIX
    Prefix=$(basename "$F_Reads" | sed 's/_1.f.*q.gz$//g')

    # RUN TRIMMOMATIC
    trimmomatic PE -threads 16 -phred33 "$F_Reads" "$R_Reads" \
        "$OutDir/$Prefix"_trimmed_R1.fastq.gz "$OutDir/$Prefix"_unpaired_R1.fastq.gz \
        "$OutDir/$Prefix"_trimmed_R2.fastq.gz "$OutDir/$Prefix"_unpaired_R2.fastq.gz \
        ILLUMINACLIP:TruSeq3-PE.fa:2:30:10:2:keepBothReads LEADING:3 TRAILING:3 \
        SLIDINGWINDOW:4:20 \
        HEADCROP:10 \
        MINLEN:80
else
    # PRINT ERROR & USAGE MESSAGES
    echo -e "\nERROR: Expected inputs not found. Please provide forward and reverse FASTQ files (.fq.gz or .fastq.gz required) and an output directory. \n"
    echo -e "Usage: sbatch trimmomatic_pe.sh <fastq_file_1.fq.gz> <fastq_file_2.fq.gz> <output_directory> \n"
    exit 1
fi

# CLEANUP
if [[ -s "$OutDir/$Prefix"_trimmed_R1.fastq.gz && -s "$OutDir/$Prefix"_trimmed_R2.fastq.gz ]]; then
    rm "$OutDir/$Prefix"_unpaired_R1.fastq.gz
    rm "$OutDir/$Prefix"_unpaired_R2.fastq.gz
else
    echo "Output is empty or does not exist."
fi
