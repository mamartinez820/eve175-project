#!/bin/bash

# test.sh
# Test script for codon_usage.sh

pass_count=0
fail_count=0

run_test() {
    test_name="$1"
    command="$2"
    expected="$3"

    actual=$(eval "$command" 2>&1)

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

