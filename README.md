# Analysis of RNAseq data

## QC
Check quality of reads using FastQC. 
```
sbatch scripts/fastqc.sh file.fastq.gz
```

## Trimming
Trim adapters, low quality sequence and first 10bp using Trimmomatic. Depending on what reads look like, change trimming parameters. Usual run for Novogene data is ILLUMINACLIP, SLIDINGWINDOW:4:20, HEADCROP:10, MINLEN:100.
```
sbatch scripts/trimmomatic_pe.sh forward.fastq.gz reverse.fastq.gz
```

## Pseudoalignment quantification
This quantification method uses a fasta file of transcripts. First index transcript coding sequences fasta file and then quantify reads.
```
sbatch scripts/salmon_index.sh coding_seq.fasta

sbatch scripts/salmon_quant.sh forward_trimmed.fastq.gz reverse_trimmed.fastq.gz index_name
```

## Differential expression testing
Perform in R, following guide at http://bioconductor.org/packages/devel/bioc/vignettes/DESeq2/inst/doc/DESeq2.html