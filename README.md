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
sbatch $scripts_dir/fastqc.sh $reads_dir/file.fq.gz $out_dir
```

To loop through multiple files:
```
for file in "$reads_dir"/*.fq.gz; do
    # Extract filename without extension
    filename="${file%.*}"

    # Submit your script with appropriate arguments
    sbatch -o "$out_dir/fastqc_$filename.out" \
        -e "$out_dir/fastqc_$filename.err" \
        $scripts_dir/fastqc.sh "$file" "$out_dir"

done
```

## MultiQC
Used to aggregate QC output into a single report for ease of visualisation.

To run on a directory containing QC reports:
```
multiqc fastqc_results/
```

## Trimmomatic
Used to trim adapters, low quality sequence and first biased 10bp. Depending on what FastQC metrics look like, you change the trimming parameters.

A usual run for Novogene PE150 data includes ```ILLUMINACLIP, SLIDINGWINDOW:4:20, HEADCROP:10, MINLEN:80```.

To run on a single paired end read set:
```
sbatch scripts/trimmomatic_pe.sh \
    /dir/to/reads/sample1_1.fastq.gz \
    /dir/to/reads/sample1_2.fastq.gz
```

To loop through multiple samples:
```
for file in /dir/to/reads/*_1.fastq.gz;
    do Short=$(basename $file _1.fastq.gz)
    sbatch scripts/trimmomatic_pe.sh $file /dir/to/reads/"$Short"_2.fastq.gz
    done
```

## Salmon
Used to quantify number of trimmed reads mapping to a fasta file of transcripts.

First, index the transcript coding sequences fasta file (only needs to be done once for each transcriptome): 
```
sbatch scripts/salmon_index.sh /dir/to/transcriptome/cds_seq.fasta
```

Then, quantify...\
To run on a single trimmed paired end read set:
```
sbatch scripts/salmon_quant.sh \
    /dir/to/trimmed_reads/sample1_F_trimmed.fastq.gz \
    /dir/to/trimmed_reads/sample1_R_trimmed.fastq.gz \
    /dir/to/transcriptome_index
```

To loop through multiple samples:
```
for file in /dir/to/trimmed_reads/*F_trimmed.fastq.gz;
    do Short=$(basename $file _F_trimmed.fastq.gz)
    sbatch scripts/salmon_quant.sh $file /dir/to/trimmed_reads/"$Short"_R_trimmed.fastq.gz /dir/to/transcriptome_index
    done
```

## DESeq2
Used for differential expression testing.

Perform in R, following guide at http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html