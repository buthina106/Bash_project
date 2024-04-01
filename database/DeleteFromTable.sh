#!/bin/bash

# Check if there are tables to insert into
if [ ! "$(ls)" ]; then
    echo "There are no tables to show."
    exit
fi

# Ask the user to enter the table name then check if the table exists
while true; do
    read -p "Enter the name of the table to delete from: " tbName
    if [ ! -f "$tbName" ] || [ ! -f "$tbName.metadata" ]; then
        echo "Table Doesn't Exist"
        exit
    fi
    break
done

# Check if the table is empty considering ignoring the first line (column names)
if [ ! "$(awk 'NR>1' "$tbName")" ]; then
    echo "Table is Empty"
    exit
fi

# Determine the primary key
pk=$(tail -n 1 "$tbName.metadata" | cut -d: -f1)

# Determine the column number of the primary key
pkNum=$(awk -F: -v pk="$pk" '{if ($1 == pk) print NR}' "$tbName.metadata")

# Ask the user to enter the primary key value then check if the value exists
while true; do
    read -p "Enter the value of the primary key ($pk) to delete: " pkValue

    # Check if the entered value matches the primary key
    if [ "$(awk -F: -v pkNum="$pkNum" -v pkValue="$pkValue" 'NR>1 && $pkNum==pkValue' "$tbName")" ]; then
        # Delete the record with the primary key value that the user entered using sed
        sed -i "/^$pkValue:/d" "$tbName"
        echo "Record with primary key '$pkValue' deleted successfully."
        break
    else
        echo "Invalid primary key value. Please enter a valid primary key value."
    fi
done

