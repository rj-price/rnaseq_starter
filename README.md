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

First, index the transcript coding sequences fasta file (only needs to be done once for each transcriptome): 
```
sbatch "$scripts_dir"/salmon_index.sh /dir/to/transcriptome/cds_seq.fasta
```

Then, quantify...\
To run on a single trimmed paired end read set:
```
sbatch "$scripts_dir"/salmon_quant.sh \
    /dir/to/trimmed_reads/sample1_F_trimmed.fastq.gz \
    /dir/to/trimmed_reads/sample1_R_trimmed.fastq.gz \
    /dir/to/transcriptome_index
```

To loop through multiple samples:
```
for file in /dir/to/trimmed_reads/*F_trimmed.fastq.gz;
    do Short=$(basename $file _F_trimmed.fastq.gz)
    sbatch "$scripts_dir"/salmon_quant.sh $file /dir/to/trimmed_reads/"$Short"_R_trimmed.fastq.gz /dir/to/transcriptome_index
    done
```

## DESeq2
Used for differential expression testing.

Perform in R, following guide at http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html