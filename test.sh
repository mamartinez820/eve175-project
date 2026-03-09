#!/bin/bash
#test.sh
#Test script for codon_usage.sh

pass_count=0
fail_count=0

run_test() {
    test_name="$1"
    command="$2"
    expected="$3"

#Run command and store it in the variable actual
    actual=$(eval "$command" 2>&1)

#Evaluate if actual is equivalent to expected and do a pass or fail count
    if [ "$actual" = "$expected" ]; then
        echo "PASS: $test_name"
        pass_count=$((pass_count + 1))
    else
        echo "FAIL: $test_name"
        echo "Expected:"
        printf "%s\n" "$expected"
        echo "Got:"
        printf "%s\n" "$actual"
        echo
        fail_count=$((fail_count + 1))
    fi
}

# Create test input files
cat > data/test1.fa << 'EOF'
>gene1
ATGAAAGCGTGA
>gene2
ATGAAATGA
EOF

cat > data/test2.fa << 'EOF'
>seq1
ATGAAAAC
>seq2
TTTGG
EOF

cat > data/empty.fa << 'EOF'
>empty1

EOF

cat > data/bad.txt << 'EOF'
>gene1
ATGAAA
EOF

# Test 1: normal case
expected1=$(cat << 'EOF'
AAA	2	0.2857
ATG	2	0.2857
GCG	1	0.1429
TGA	2	0.2857

Total codons: 7
EOF
)
run_test "normal FASTA input" "./codon_usage.sh data/test1.fa" "$expected1"

# Test 2: trailing bases ignored
expected2=$(cat << 'EOF'
AAA	1	0.3333
ATG	1	0.3333
TTT	1	0.3333

Total codons: 3
EOF
)
run_test "ignores trailing bases" "./codon_usage.sh data/test2.fa" "$expected2"

# Test 3: missing argument
expected3=$(cat << 'EOF'
Error: Please provide exactly one FASTA file.
Usage: ./codon_usage.sh <fasta_file>
EOF
)
run_test "missing argument" "./codon_usage.sh" "$expected3"

# Test 4: missing file
expected4="Error: File 'does_not_exist.fa' does not exist."
run_test "missing file" "./codon_usage.sh data/does_not_exist.fa" "$expected4"

# Test 5: wrong extension
expected5="Error: Input file must have a .fa or .fasta extension."
run_test "wrong file extension" "./codon_usage.sh data/bad.txt" "$expected5"

# Summary
echo "Passed: $pass_count"
echo "Failed: $fail_count"
	
