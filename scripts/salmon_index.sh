#!/usr/bin/env bash
#SBATCH -J salmon
#SBATCH --partition=short
#SBATCH --mem=2G
#SBATCH --cpus-per-task=4

# INPUT
Transcriptome=$1
OutDir=$2

# CHECK INPUTS
if [[ -f "$Transcriptome" && "$Transcriptome" =~ \.(fa|fna|fasta)$ && -n "$OutDir" ]]; then
    # CREATE OUTPUT FOLDER
    mkdir -p "$OutDir"

    # RUN SALMON INDEX
    salmon index -t "$Transcriptome" -i "$OutDir"/transcriptome_index --keepDuplicates -k 27
else
    # PRINT ERROR & USAGE MESSAGES
    echo -e "\nERROR: Expected inputs not found. Please provide a transcriptome CDS file (.fa .fna or .fasta required) and an output directory. \n"
    echo -e "Usage: sbatch salmon_index.sh <transcriptome_cds.fasta> <output_directory> \n"
    exit 1
fi
