#!/bin/bash

# Function to validate the name
function validateName {
    if [ -z "$1" ]; then
        echo "Name Can't Be Empty"
        return 1
    elif [[ "$1" =~ ^[0-9] ]]; then
        echo "Name Can't Start With a Number"
        return 1
    elif [[ "$1" = " " ]]; then
        echo "Name Can't Contain Spaces"
        return 1
    elif [[ "$1" =~ [^a-zA-Z0-9_] ]]; then
        echo "Name Can't Contain Special Characters"
        return 1
    fi
}

# Function to validate the table name
validate_table_name() {
    local tbName=$1
    if [ ! -f "$tbName" ] || [ ! -f "$tbName.metadata" ]; then
        echo "Table Does Not Exist"
        return 1
    fi
}

# Main Script

# Ask the user to enter the table name using loop until the name is valid
while true; do
    read -p "Enter the name of the table: " tbName
    validateName "$tbName"
    if [ $? -ne 0 ]; then
        echo "Invalid Table Name"
        continue
    fi
    break
done

# Validate the table name
validate_table_name "$tbName" || exit 1

# Ask the user to enter the primary key value
read -p "Enter the primary key value to select the row: " primaryKey

# Selecting the row based on the primary key value
selectedRow=$(awk -F':' -v key="$primaryKey" '{for(i=1;i<=NF;i++) if($i == key) {print; exit}}' "$tbName")

# Check if the row with the primary key value exists
if [ -z "$selectedRow" ]; then
    echo "Row with primary key '$primaryKey' not found in $tbName"
else
    echo "Selected Row:"
    echo "$selectedRow"
fi
