#!/bin/bash

# Script to display all environment variables using printenv command
# and save them to a file
# Usage: ./printenv.sh

OUTPUT_FILE="environment_variables.txt"

echo "==================================="
echo "Environment Variables"
echo "==================================="
echo ""

# Execute printenv to show all environment variables
printenv

# Save environment variables to file
{
    echo "==================================="
    echo "Environment Variables"
    echo "Date: $(date)"
    echo "==================================="
    echo ""
    printenv
    echo ""
    echo "==================================="
    echo "Total environment variables: $(printenv | wc -l)"
    echo "==================================="
} > "$OUTPUT_FILE"

echo ""
echo "==================================="
echo "Total environment variables: $(printenv | wc -l)"
echo "Saved to: $OUTPUT_FILE"
echo "==================================="
