#!/bin/bash
#codon_usage.sh
#Read a FASTA file of coding DNA sequences and produce a codon usage table.

#Exit on error, undefined vars, pipe failures
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

# Header line indicates a new sequence
/^>/ {

#If seq isn't empty, then count its codon befeor reseting it to a empty string
    if (seq != "") {

#Find what part of the sequence is usable (no overhangs)
        len = length(seq)
        usable_len = len - (len % 3)

#Loop through the sequence in intervals of 3 to find codons
        for (i = 1; i <= usable_len; i += 3) {
            codon = substr(seq, i, 3)
            counts[codon]++
            total_codons++
        }

#Reset seq to a empty string 
        seq = ""
    }
    next
}

#If we are on a sequence line, add it to seq
{
    seq = seq toupper($0)
}

END {

#Process final sequence using same algorithm
    if (seq != "") {
        len = length(seq)
        usable_len = len - (len % 3)

        for (i = 1; i <= usable_len; i += 3) {
            codon = substr(seq, i, 3)
            counts[codon]++
            total_codons++
        }
    }


#Print codons with nonzero counts
    for (codon in counts) {
        freq = counts[codon] / total_codons
        printf "%s\t%d\t%.4f\n", codon, counts[codon], freq
    }

    printf "\nTotal codons: %d\n", total_codons
}
' "$fasta_file" | sort
