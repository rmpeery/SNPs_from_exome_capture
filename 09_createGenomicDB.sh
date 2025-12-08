## increase GATK speed by using intervals

## 1. index reference
#!/bin/bash
module load StdEnv/2023 samtools/1.20
set -eou pipefail
samtools faidx <reference.fasta>

## 2. make bed file from fai file
awk '{print $1, "0", $2}' <infile.fai >outfile.bed

## 3. split into intervals
split -l 500 interval_batch
