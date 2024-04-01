#!/bin/bash
# List all the table files in the Mdata directory
shopt -s nullglob  # Enable nullglob to prevent pattern expansion to literal string '*' when no files match
tables=(*)
shopt -u nullglob  # Disable nullglob to revert to its previous behavior

# Check if any table files exist
if [ ${#tables[@]} -eq 0 ]; then
    echo "No tables found in database."
else
    echo "Tables in existing database :"
    for table in "${tables[@]}"; do
        # Exclude files with .metadata extension
        if [[ $table != *.metadata ]]; then
            echo "- $table"
        fi
    done
fi

# Return to the original directory
cd - > /dev/null

