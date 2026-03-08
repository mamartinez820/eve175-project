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
