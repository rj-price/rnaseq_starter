#!/usr/bin/env bash
#SBATCH -J fastqc
#SBATCH --partition=short
#SBATCH --mem=1G
#SBATCH --cpus-per-task=2

# INPUT
Reads=$1
OutputDir=$2

# CHECK INPUT
if [[ ! -f "$Reads" || ! "$Reads" =~ \.(fq|fastq).gz$ ]]; then
    echo -e "Error: Input file doesn't exist or has an invalid extension (.fq.gz or .fastq.gz required). \n"
    echo -e "Usage: sbatch fastqc.sh <fastq_file.fq.gz> <output_directory> \n"
    exit 1
fi

# CREATE OUTPUT FOLDER
mkdir -p $OutputDir

# RUN FASTQC
echo -e "Running FastQC with '$Reads'... \n"
fastqc $Reads -t 2 -o $OutputDir
