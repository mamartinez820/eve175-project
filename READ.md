Codon Usage Calculator
------------------------------------------------------------
Project Description

This project implements a Bash-based bioinformatics tool that analyzes codon usage from DNA sequences in a FASTA file. The script reads one or more coding sequences, concatenates sequence lines, and divides them into non-overlapping codons (triplets) starting from the first nucleotide. It then counts the occurrences of each codon across all sequences and calculates the relative frequency of each codon.

Codons are reported in alphabetical order along with their counts and frequencies. Any trailing bases that do not form a complete codon are ignored.
------------------------------------------------------------
Usage Instructions

First make the script executable:

chmod +x codon_usage.sh

Run the program by providing a FASTA file as an argument:

./codon_usage.sh <fasta_file>

Example:

./codon_usage.sh data/test1.fa

Run the automated tests with:

chmod +x test.sh
./test.sh
------------------------------------------------------------
Input Format

The program expects a FASTA-formatted file containing one or more DNA sequences.

Example input:

>gene1
ATGAAAGCGTGA
>gene2
ATGAAATGA

Rules:

Header lines begin with >

Sequence lines may span multiple lines

Only .fa or .fasta files are accepted

Trailing bases that do not form a full codon are ignored

Output Format

The script prints a table containing:

Codon

Count (number of times the codon appears)

Relative frequency (count divided by total codons)

Example output:

AAA    2    0.2857
ATG    2    0.2857
GCG    1    0.1429
TGA    2    0.2857

Total codons: 7
------------------------------------------------------------
Dependencies and Assumptions

Dependencies:

Bash shell

AWK

Standard Unix utilities (e.g., sort)

Assumptions:

Input sequences are DNA sequences.

Codons are counted starting at position 1 of each sequence.

The script processes sequences independently and sums codon counts across all sequences.

Invalid file types or missing files produce an error message.
------------------------------------------------------------
AI Assistance

AI was used to assist in debugging errors in printing the sorted codons, it was recommended to use
close(sort) which sorted the codons as soon as we were done iterating through them, which prevented
anything else to get sorted with them.  AI was also used in debugging the  nested functions that called 
other scripts.
