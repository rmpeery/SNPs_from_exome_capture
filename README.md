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
  04_bwamemIndexRef.slm & 05_bwamemPE.slm \
Get stats: \
  06_flagstatSummary.sh

References
  1. FastQC; https://github.com/s-andrews/FastQC
  2. MultiQC; https://github.com/MultiQC/MultiQC?tab=readme-ov-file; https://doi.org/10.1093/bioinformatics/btw354
  3. trimmomatic; https://github.com/usadellab/Trimmomatic;
     Bolger, A. M., Lohse, M., & Usadel, B. (2014). Trimmomatic: A flexible trimmer for Illumina Sequence Data. Bioinformatics, btu170.
  4. BWA-MEM2; https://github.com/bwa-mem2/bwa-mem2; https://doi.org/10.1109/IPDPS.2019.00041
  5. samtools; https://www.htslib.org/ and https://github.com/samtools/samtools

## GATK SNP calling workflow
This follows closely to the best practices for GATK. However, since this is desiged for exome capture, markDuplicates is not run, because exome capture will have a high proportion of reads with the same start/stop mapping coordiantes by design. \

Read groups are added for later ease of vcf/bcf tool use: 07_addRdGrp.slm \
Haplotypes are called for each individual: 08_haploCall.slm \
Then genotypes are called per interval, since transcriptome contigs are the reference, parsing this makes the analysis much faster. \
  09_createGenomeDB.sh is used to prep everything needed to call genotypes \
  10_callSNPs.slm generates the vcf files per interval. \
Finally the intervals are concatinated into one final vcf that needs to go through a validation step (since we don't have a refernce "known" set of SNPs) and then filtering. \
  11_finalGATK_VCF.slm \

References
  1. picard tools; https://broadinstitute.github.io/picard/ and https://github.com/broadinstitute/picard
  2. GATK; https://gatk.broadinstitute.org/hc/en-us

## mpileup workflow through angsd wrapper
Mpileup uses a different likelihood algorithm than GATK and is a good compliment. Freebayes could also be used if it is preferred. \
  12_angsdMpileup.slm

References
1. angsd; https://github.com/ANGSD/angsd and https://www.popgen.dk/angsd/index.php/ANGSD

## Generate high-confidence SNP set
There is no reference SNP set so calling through two algorithms and using the co-occurring SNPs gives the highest confidence SNP dataset. \
  13_HCsnps.slm

References
1. bcftools; https://samtools.github.io/bcftools/bcftools.html

