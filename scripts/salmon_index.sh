#!/usr/bin/env bash
#SBATCH -J salmon
#SBATCH --partition=short
#SBATCH --mem=2G
#SBATCH --cpus-per-task=4

# INPUT
Transcriptome=$1
OutDir=$2

# CHECK INPUTS
if [[ ! -f "$Transcriptome" || ! "$Transcriptome" =~ \.(fa|fna|fasta)$ ]]; then
    echo -e "\nERROR: Input file doesn't exist or has an invalid extension (.fa .fna or .fasta required). \n"
    echo -e "Usage: sbatch salmon_index.sh <transcriptome_cds.fasta> <output_directory> \n"
    exit 1
fi

if [ -z "$OutDir" ]; then
    echo -e "\nERROR: Output directory argument is missing. \n"
    echo -e "Usage: sbatch salmon_index.sh <transcriptome_cds.fasta> <output_directory> \n"
    exit 1
fi

# CREATE OUTPUT FOLDER
mkdir -p "$OutDir"

# RUN SALMON INDEX
salmon index -t "$Transcriptome" -i "$OutDir"/transcriptome_index --keepDuplicates -k 27
