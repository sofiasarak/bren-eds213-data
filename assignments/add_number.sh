#!/bin/bash
# Add two numbers.
if [ $# -ne 2 ]; then
    echo "Supply two numbers, no more, no less"
    exit 1
fi
first=$1
second=$2
echo "The sum of $first and $second is $(( $first + $second ))"