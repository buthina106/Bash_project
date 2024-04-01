#!/bin/bash
# Function to validate the value of the column based on the data type of the column in the metadata file
# $1: value
# $2: column name
# $3: table name
function validateValue() {
    # Check if the value is null
    if [ -z "$1" ]; then
        echo "The value of $2 can't be null."
        return 1
    fi

    # Check if the value is a number
    if [[ "$1" =~ ^[0-9]+$ ]]; then
        # Check if the data type of the column contains "integer"
        dataType=$(awk -F: -v col="$2" '$1 == col {print $2}' "$3.metadata" | grep -o 'integer')
        if [ "$dataType" == "integer" ]; then
            return 0
        else
            echo "The value of $2 must be a string."
            return 1
        fi
    fi

    # Check if the value is a string
    if [[ "$1" =~ ^[a-zA-Z0-9_]+$ ]]; then
        # Check if the data type of the column contains "string"
        dataType=$(awk -F: -v col="$2" '$1 == col {print $2}' "$3.metadata" | grep -o 'string')
        if [ "$dataType" == "string" ]; then
            return 0
        else
            echo "The value of $2 must be a number."
            return 1
        fi
    fi

    # If the value is not a number or a string, it's invalid
    echo "The value of $2 must be a number or a string."
    return 1
}

# Check if there are tables to insert into
if [ ! "$(ls)" ]; then
    echo "There are no tables to show."
    read -n 1 -s -r -p "Press any key to continue..."
    exit
fi

# Ask the user to enter the table name then check if the table exists
while true; do
    read -p "Enter the name of the table: " tbName
    if [ ! -f "$tbName" ] || [ ! -f "$tbName.metadata" ]; then
        echo "Table Doesn't Exist"
        read -n 1 -s -r -p "Press any key to continue..."
        exit
    fi
    break
done

# Initialize an array with the columns names
columns_names=($(awk -F: '{print $1}' "$tbName.metadata" | head -n -1))

# determine the primary key
pk=$(awk -F: '{print $1}' "$tbName.metadata" | tail -1)

# determine the column number of the primary key
pkNum=$(awk -F: '{print $1}' "$tbName.metadata" | head -n -1 | grep -n "$pk" | cut -d: -f1)

# Loop on the columns names
for col in "${columns_names[@]}"; do
    # Ask the user to enter the value of the column as the data type of the column
    while true; do
        read -p "Enter the value of $col: " value
        # if the col is the primary key then check if the value is unique
        if [ "$col" = "$pk" ]; then
            # Check if the value is unique
            if grep -q "^$value:" "$tbName"; then
                echo "Value Must Be Unique"
                continue
            fi
        fi
        # Validate the value of the column
        validateValue "$value" "$col" "$tbName"
        if [ $? -ne 0 ]; then
            continue
        fi
        break
    done
    # Append the value to the table file
    echo -n "$value" >> "$tbName"
    # Append a colon to the table file if the column isn't the last column [-1] (ignore the primary key)
    if [ "$col" != "${columns_names[-1]}" ]; then
        echo -n ":" >> "$tbName"
    fi
done

# Append a new line to the table file
echo >> "$tbName"

