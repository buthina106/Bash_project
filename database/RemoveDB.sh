#!/bin/bash

while true; do
    read -p "Enter the Database name to delete: " db_name

    case $db_name in
        "")
            echo "Error: please enter database name."
            continue
            ;;
        [[:space:]])
            echo " Database name cannot contain spaces."
            continue
            ;;
        [0-9]*)
            echo " Database name should not start with a number."
            continue
            ;;
        [!a-zA-Z0-9_])
            echo " Database name should only contain letters, numbers, and underscores."
            continue
            ;;
        [a-zA-Z]*)
            if [[ $db_name =~ ^[a-zA-Z0-9_]+$ ]]; then
                if [ -d "./DataBases/$db_name" ]; then
                    rm -r "./DataBases/$db_name"
                    echo "Database $db_name is deleted successfully!!!!"
                else
                    echo "Error: Database $db_name does not exist."
                fi
                break
            fi
            ;;
        *)
            echo "Invalid database name. Please provide a valid name."
            continue
            ;;
    esac
done

