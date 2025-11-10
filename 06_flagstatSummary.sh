#!/bin/bash

set -eou pipefail

OUT_DIR="/metrics/mapping" # change to match where the flagstat out files are from bwa-mem2
OUT_FILE="$OUT_DIR/flagstat_summary.txt"

mkdir -p "$OUT_DIR"

# Output header to the TSV file
echo -e "sample\tinputRdPairs\tprimary_mapped\tperc_mapped\tpaired\tpaired_perc\tsplit_pairs\tsingletons\tperc_singletons" > "$OUT_FILE"

# Loop through all OUT files in the current directory
for f in "$OUT_DIR/*.flagstat.txt; do
    # get sample ID
    sample="${f%%.flagstat.out}"
    # Extract relevant values
    input_pairs=$(sed -n '10p' "$f" | awk '{print $1}')
    primary_mapped=$(sed -n '8p' "$f" | awk '{print $1}')
    primary_perc=$(sed -n '8p' "$f" | awk '{print $6}' | sed 's/(//')
    paired=$(sed -n '12p' "$f" | awk '{print $1}')
    paired_perc=$(sed -n '12p' "$f" | awk '{print $6}' | sed 's/(//')
    split_pairs=$(sed -n '15p' "$f" | awk '{print $1}')
    singletons=$(sed -n '14p' "$f" | awk '{print $1}')
    sing_perc=$(sed -n '14p' "$f" | awk '{print $5}' | sed 's/(//')

    # print out the extracted metrics
    echo -e "$sample\t$input_pairs\t$primary_mapped\t$primary_perc\t$paired\t$paired_perc\t$split_pairs\t$singletons\t$sing_perc" >> "$OUT_FILE"
done

echo "Metrics have been saved to $OUT_FILE"
