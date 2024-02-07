#!/usr/bin/env bash
#SBATCH -J fastqc
#SBATCH --partition=short
#SBATCH --mem=1G
#SBATCH --cpus-per-task=2

# INPUT
Reads=$1

# CREATE OUTPUT FOLDER
mkdir fastqc

# RUN FASTQC
fastqc $Reads -t 2 -o fastqc
