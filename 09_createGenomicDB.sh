## increase GATK speed by using intervals

## 1. index reference
#!/bin/bash
module load StdEnv/2023 samtools/1.20
set -eou pipefail
samtools faidx reference.fasta

## 2. make bed file from fai file
awk '{print $1, "0", $2}' <infile.fai >outfile.bed

## 3. split into intervals
split -l 500 interval_batch outfile.bed
mkdir beds
mv interval_batch* beds
cd beds
for FILE in *; do mv ${FILE} ${FILE}.bed; done

## 4. gatk dict file
module load StdEnv/2023 gatk/4.4.0.0
gatk CreateSequenceDictionary -R reference.fasta
