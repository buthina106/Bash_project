#!/bin/bash

# Function to validate a name
# $1: name
function validateName() {
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

# Ask the user to enter the table name using loop until the name is valid
while true; do
    read -p "Enter the name of the table: " tbName
    validateName "$tbName" || continue
    break
done

# Check if the table already exists
if [ -f "$tbName" ] || [ -f "$tbName.metadata" ]; then
    echo "Table Already Exists"
    exit 1
fi

# Ask the user to enter the number of columns using loop until the number is valid
while true; do
    read -p "Enter the number of columns: " colsNum
    # Validate Number of Columns
    if [[ ! $colsNum =~ ^[0-9]+$ ]]; then
        echo "Number of Columns Must Be a Number"
        continue
    elif [ $colsNum -eq 0 ]; then
        echo "Number of Columns Must Be Greater Than 0"
        continue
    fi
    break
done

# Create a metadata file and file for the table
touch "$tbName.metadata"
touch "$tbName"

# Loop on the number of columns
counter=1
while [ $counter -le $colsNum ]; do
    # Ask the user to enter the column name using loop until the name is valid
    while true; do
        read -p "Enter the name of column #$counter: " colName
        validateName "$colName" || continue
        break
    done

    # Ask the user to choose the column type using loop until the type is valid
    while true; do
        echo "Choose the type of column #$counter:"
        PS3="Select an option (1-2): "
        select colType in "integer" "string"; do
            case $colType in
                "integer" | "string" ) break ;;
                *) echo "Invalid Choice" ;;
            esac
        done
        break
    done

    # Append the column name and type to the metadata file
    echo "$colName:$colType" >> "$tbName.metadata"

    # Append the column name to the table file
    echo -n "$colName " >> "$tbName"

    ((counter++))
done

# Append a new line to the table file
echo >> "$tbName"

# Ask the user to choose the primary key using select and case
pk_check=false
while [ "$pk_check" = false ]; do 
    echo "Choose the primary key:"
    PS3="Select an option (1-$colsNum): "
    select primaryKeyCol in $(cut -d: -f1 "$tbName.metadata"); do 
        if [ -n "$primaryKeyCol" ]; then
            echo "$primaryKeyCol:primarykey" >> "$tbName.metadata"
            pk_check=true
            break
        else
            echo "Invalid Choice"
        fi
    done
done

echo "Table Created Successfully"
read -n 1 -s -r -p "Press any key to continue..."

