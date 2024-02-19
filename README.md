# Analysis of RNAseq data

Environmental variable (change this to actual path):
```
scripts_dir=/dir/to/rnaseq_starter/scripts
```

## FastQC
Used to check various quality metrics of reads.

Set the reads and output directories (change these to the actual paths):
```
reads_dir=/dir/to/reads/
out_dir=/dir/to/output/fastqc_results
```

To run on a single file:
```
sbatch "$scripts_dir"/fastqc.sh "$reads_dir"/file.fq.gz "$out_dir"
```

To loop through multiple files:
```
for file in "$reads_dir"/*.fq.gz; do

    # Submit script with appropriate arguments
    sbatch "$scripts_dir"/fastqc.sh "$file" "$out_dir"

done
```

## MultiQC
Used to aggregate QC output into a single report for ease of visualisation.

To run on a directory containing QC reports:
```
multiqc fastqc_results/
```

## Trimmomatic
Used to trim adapters, low quality sequence and biased first 10bp of each read. Depending on what FastQC metrics look like, you change the trimming parameters in the script.

A usual run for Novogene PE150 data includes ```ILLUMINACLIP, SLIDINGWINDOW:4:20, HEADCROP:10, MINLEN:80```.

Set the reads and output directories (change these to the actual paths):
```
reads_dir=/dir/to/reads/
out_dir=/dir/to/output/trimmed_reads
```

To run on a single paired end read set:
```
sbatch "$scripts_dir"/trimmomatic_pe.sh \
    "$reads_dir"/sample1_1.fq.gz \
    "$reads_dir"/sample1_2.fq.gz \
    "$out_dir"
```

To loop through multiple samples:
```
for file in "$reads_dir"/*_1.fq.gz; do

    # Extract filename without read number and extension
    filename=$(basename "$file" _1.fq.gz)

    # Submit script with appropriate arguments
    sbatch "$scripts_dir"/trimmomatic_pe.sh "$file" "$reads_dir"/"$filename"_2.fq.gz "$out_dir"
    
done
```

## Salmon
Used to quantify number of trimmed reads mapping to a fasta file of transcripts.

Set the trimmed reads and output directories (change these to the actual paths):
```
reads_dir=/dir/to/trimmed_reads/
out_dir=/dir/to/output/salmon
```

First, index the transcript coding sequences fasta file (only needs to be done once for each transcriptome): 
```
sbatch "$scripts_dir"/salmon_index.sh /dir/to/transcriptome/cds_seq.fasta "$out_dir"
```

Then, quantify...\
To run on a single trimmed paired end read set:
```
sbatch "$scripts_dir"/salmon_quant.sh \
    "$reads_dir"/sample1_trimmed_R1.fastq.gz \
    "$reads_dir"/sample1_trimmed_R2.fastq.gz \
    "$out_dir"/transcriptome_index \
    "$out_dir"
```

To loop through multiple samples:
```
for file in "$reads_dir"/*R1.fastq.gz; do

    # Extract filename without read number and extension
    filename=$(basename "$file" _R1.fastq.gz)

    # Submit script with appropriate arguments
    sbatch "$scripts_dir"/salmon_quant.sh "$file" "$reads_dir"/"$filename"_R2.fastq.gz "$out_dir"/transcriptome_index "$out_dir"

done
```

## DESeq2
Used for differential expression testing.

Perform in R, following guide at http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html