#!/bin/bash
# codon_usage.sh
# Read a FASTA file of coding DNA sequences and produce a codon usage table.

set -euo pipefail

#Check for exactly one argument
if [ "$#" -ne 1 ]; then
    echo "Error: Please provide exactly one FASTA file." >&2
    echo "Usage: $0 <fasta_file>" >&2
    exit 1
fi

fasta_file="$1"

#Check that file exists
if [ ! -f "$fasta_file" ]; then
    echo "Error: File '$fasta_file' does not exist." >&2
    exit 1
fi

#Check that file has a FASTA extension
case "$fasta_file" in
    *.fa|*.fasta|*.FA|*.FASTA)
        ;;
    *)
        echo "Error: Input file must have a .fa or .fasta extension." >&2
        exit 1
        ;;
esac

awk '
BEGIN {
    total_codons = 0
    seq = ""
}

#Create function that counts codon per sequence
function process_sequence(s) {
    len = length(s)
    usable_len = len - (len % 3)

    for (i = 1; i <= usable_len; i += 3) {
        codon = substr(s, i, 3)
        counts[codon]++
        total_codons++
    }
}

#Check if line is a header line
/^>/ {

#If line is a hedear line, if seq is not empty, then count its codons
    if (seq != "") {
        process_sequence(seq)
        seq = ""
    }
    next
}

#If the line is not  a header and is not blank, then assign that lines value to seq
NF > 0 {
    seq = seq toupper($0)
}

END {

#Check if the final line did not get processed
    if (seq != "") {
        process_sequence(seq)
    }

#Print codons
    for (codon in counts) {
        freq = counts[codon] / total_codons
        printf "%s\t%d\t%.4f\n", codon, counts[codon], freq | "sort"
    }

    close("sort")

    printf "\nTotal codons: %d\n", total_codons
}
' "$fasta_file" 
