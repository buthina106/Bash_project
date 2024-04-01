#!/bin/bash

# Function to validate the name
function validateName {
    if [ -z "$1" ]; then
        echo "Name Can't Be Empty"
        return 1
    elif [[ "$1" =~ ^[0-9] ]]; then
        echo "Name Can't Start With a Number"
        return 1
    elif [[ "$1" = *" "* ]]; then
        echo "Name Can't Contain Spaces"
        return 1
    elif [[ "$1" =~ [^a-zA-Z0-9_] ]]; then
        echo "Name Can't Contain Special Characters"
        return 1
    fi
}

# Main Script

# Ask the user to enter the table name using loop until the name is valid
while true; do
    read -p "Enter the name of the table to drop: " tbName
    validateName "$tbName"
    if [ $? -ne 0 ]; then
        echo "Invalid Table Name"
        continue
    fi
    break
done

# Check if the table exists
if [ ! -f "$tbName" ] || [ ! -f "$tbName.metadata" ]; then
    echo "Table Does Not Exist"
    exit 1
fi

# Prompt the user for confirmation
read -p "Are you sure you want to drop the table '$tbName'? (y/n): " confirmation

if [ "$confirmation" != "y" ]; then
    echo "Table Drop Aborted"
    exit 0
fi

# Remove the table data file
rm "$tbName"

# Remove the table metadata file
rm "$tbName.metadata"

echo "Table Dropped Successfully"
