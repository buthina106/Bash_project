#!/bin/bash

while true;
do
    read -p "Enter the Database name: " db_name

    case $db_name in
        "")
            echo "Error: Database name cannot be empty."
            continue
            ;;
        *[[:space:]]*)
            echo "Error: Database name cannot contain spaces."
            continue
            ;;
        [0-9]*)
            echo "Error: Database name should not start with a number."
            continue
            ;;
        *[!a-zA-Z0-9_]*)
            echo "Error: Database name should only contain letters, numbers, and underscores."
            continue
            ;;
        [a-zA-Z]*)
            if [[ $db_name =~ ^[a-zA-Z0-9_]+$ ]]; then
                mkdir -p "./DataBases/$db_name"
                echo "Database $db_name is created successfully!!!!"

                
                break
                 
                 fi
         
                 ;; 
        *)
            echo "Invalid database name. Please provide a valid name."
            continue
            ;;
    esac
done


