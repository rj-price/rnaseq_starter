#!/usr/bin/env bash
#SBATCH -J fastqc
#SBATCH --partition=short
#SBATCH --mem=1G
#SBATCH --cpus-per-task=2

# INPUT
Reads=$1
OutDir=$2

# CHECK INPUTS
if [[ -f "$Reads" && "$Reads" =~ \.(fq|fastq).gz$ && -n "$OutDir" ]]; then
    # CREATE OUTPUT FOLDER
    mkdir -p "$OutDir"

    # RUN FASTQC
    fastqc "$Reads" -t 2 -o "$OutDir"
else
    # PRINT ERROR & USAGE MESSAGES
    echo -e "\nERROR: Expected inputs not found. Please provide a FASTQ file (.fq.gz or .fastq.gz required) and an output directory. \n"
    echo -e "Usage: sbatch fastqc.sh <fastq_file.fq.gz> <output_directory> \n"
    exit 1
fi






