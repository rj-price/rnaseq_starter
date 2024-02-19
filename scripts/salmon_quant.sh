#!/usr/bin/env bash
#SBATCH -J salmon
#SBATCH --partition=medium
#SBATCH --mem=2G
#SBATCH --cpus-per-task=4

# INPUTS
F_Reads=$1
R_Reads=$2
Index=$3
OutDir=$4

# CHECK INPUTS
if [[ ! -f "$F_Reads" || ! "$F_Reads" =~ \.(fq|fastq)\.gz$ || ! -f "$R_Reads" || ! "$R_Reads" =~ \.(fq|fastq)\.gz$ ]]; then
    echo -e "\nERROR: Input files don't exist or have invalid extension (.fq.gz or .fastq.gz required). \n"
    echo -e "Usage: sbatch salmon_quant.sh <fastq_file_1.fq.gz> <fastq_file_2.fq.gz> <transcriptome_index_dir> <output_directory> \n"
    exit 1
fi

if [ -z "$Index" ]; then
    echo -e "\nERROR: Transcriptome index directory argument is missing. \n"
    echo -e "Usage: sbatch salmon_quant.sh <fastq_file_1.fq.gz> <fastq_file_2.fq.gz> <transcriptome_index_dir> <output_directory> \n"
    exit 1
fi

if [ -z "$OutDir" ]; then
    echo -e "\nERROR: Output directory argument is missing. \n"
    echo -e "Usage: sbatch salmon_quant.sh <fastq_file_1.fq.gz> <fastq_file_2.fq.gz> <transcriptome_index_dir> <output_directory> \n"
    exit 1
fi

# CREATE OUTPUT FOLDER
mkdir -p "$OutDir"

# OUTPUT PREFIX
Prefix=$(basename "$F_Reads" _trimmed_R1.f*q.gz)

# RUN SALMON QUANT
salmon quant \
    -i "$Index" \
    -l A \
    -1 "$F_Reads" \
    -2 "$R_Reads" \
    --validateMappings \
    -p 4 \
    --numBootstraps 1000 \
    --dumpEq \
    --seqBias \
    --gcBias \
    -o "$Prefix"_quant
