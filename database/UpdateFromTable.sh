#!/bin/bash
# Path: DataBase/updateTable.sh

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

# Check if there are tables to update
if [ ! "$(ls)" ]; then
    echo "There are no tables to update."
    read -n 1 -s -r -p "Press any key to continue..."
    exit
fi

# Ask the user to enter the table name then check if the table exists
while true; do
    read -p "Enter the name of the table to update: " tbName
    if [ ! -f "$tbName" ] || [ ! -f "$tbName.metadata" ]; then
        pwd
        
        echo "Table Doesn't Exist"
        exit
    fi
    break
done

# Check if the table is empty (ignoring the first line - column names)
if [ ! "$(awk 'NR>1' "$tbName")" ]; then
    echo "Table is Empty"
    exit
fi

# Determine the primary key
pk=$(cat "$tbName.metadata" | awk -F: '{print $1}' | tail -1)

# Determine the column number of the primary key
pkNum=$(cat "$tbName.metadata" | awk -F: '{print $1}' | head -n -1 | grep -n "$pk" | cut -d: -f1)

# Ask the user for the primary key value of the record to update
while true; do
    read -p "Enter the value of the primary key ($pk) to update: " pkValue
    # Check if the primary key value exists in the table
    if [ ! "$(awk -F: -v pkNum="$pkNum" -v pkValue="$pkValue" '$pkNum==pkValue' "$tbName")" ] || [[ "$pkValue" = "" ]]; then
        echo "Value Doesn't Exist"
        exit
    fi
    break
done

# Ask the user for the column name to update
while true; do
    read -p "Enter the name of the column to update: " colName
    # Check if the column name is the primary key
    if [ "$colName" = "$pk" ]; then
        echo "You can't update the primary key"
        read -n 1 -s -r -p "Press any key to continue..."
        exit
    fi

    # Check if the column exists in the table
    if ! grep -q "^$colName:" "$tbName.metadata" || [[ "$colName" = "" ]]; then
        echo "Column Doesn't Exist"
        read -n 1 -s -r -p "Press any key to continue..."
        exit
    fi
    break
done

# Ask the user for the new value of the column
while true; do
    read -p "Enter the new value of $colName: " newValue
    # Validate the new value of the column
    validateValue "$newValue" "$colName" "$tbName"
    if [ $? -ne 0 ]; then
        continue
    fi
    break
done

# Extract the column number of the column to update
colNum=$(awk -F: -v colName="$colName" '$1 == colName {print NR}' "$tbName.metadata")
#echo $colNum
# Extract the old value of the column to update
oldValue=$(awk -F: -v pkNum="$pkNum" -v pkValue="$pkValue" '$pkNum == pkValue {print $'"$colNum"'}' "$tbName")
#echo $oldValue

# Replace the old value with the new value in the table
sed -i "/^$pkValue/ s/$oldValue/$newValue/" "$tbName"
#sed -i "s/$oldValue/$newValue/g" "$tbName"

echo "Record Updated Successfully"
read -n 1 -s -r -p "Press any key to continue..."

