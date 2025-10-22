# Calling SNPs from exome capture data
The workflow is organized from trimming through the final bcf file. All scripts are formatted to run through a slurm queueing system. In this case The Digital Research Alliance (formerly ComputeCanada). The input data are short read sequences from Illumina Next-Seq and the transcriptome contigs used to design the baits are the "reference" for mapping reads.

## Extract ora compressed files
This script decompressed reads that are compressed using Illuminas DRAGEN ORA compression. Notes within the script include how/where to download references and how to check the reference that was used for compression.
00_orad.slm

## Quality check reads
This script uses FastQC[1] to generate a summary of quality metrics per sequence. \
  01_QC.slm

The reads are then summarized into one html document with MultiQC[2]. If you need to set up a python environment see these instructions: https://docs.alliancecan.ca/wiki/Python/en \
  02_MultiQC.slm

## Trim reads
Reads are trimmed with trimmomatic[3] using input from QC including the length to trim, head and crop, adapter contamination etc. \
  03_trimPE.slm

## QC again

## Index reference and map reads
Reads are mapped to the indexed reference exome using BWA-MEM2[4] \
  04_bwamemIndexRef.slm & 04_bwamemPE.slm


  References
  1. FastQC; https://github.com/s-andrews/FastQC
  2. MultiQC; https://github.com/MultiQC/MultiQC?tab=readme-ov-file; https://doi.org/10.1093/bioinformatics/btw354
  3. trimmomatic; https://github.com/usadellab/Trimmomatic;
     Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: A flexible trimmer for Illumina Sequence Data. Bioinformatics, btu170.
  4. BWA-MEM2; https://github.com/bwa-mem2/bwa-mem2; https://doi.org/10.1109/IPDPS.2019.00041
