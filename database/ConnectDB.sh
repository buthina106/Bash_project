#!/bin/bash
SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"

# Function to display the menu options
show_menu() {
    echo "----------------------------------------"
    echo "           Database Menu                "
    echo "----------------------------------------"
    echo "1. Create Table"
    echo "2. List Tables"
    echo "3. Drop Table"
    echo "4. Insert Data"
    echo "5. Select From Table"
    echo "6. Select All From Table"
    echo "7. Delete From Table"
    echo "8. Update Table"
    echo "9. Exit"
    echo "----------------------------------------"
}

# Main loop for displaying menu and processing user input
while true; do
    read -p "Enter the Database name to connect: " db_name

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
            if [ -d "$SCRIPT_DIR/DataBases/$db_name" ]; then
                cd "$SCRIPT_DIR/DataBases/$db_name" || exit
                echo "Connected to database: $db_name"
                break  # Exit the loop and proceed to the menu
            else
                echo "Error: Database $db_name does not exist."
                continue
            fi
            ;;
        *)
            echo "Invalid database name. Please provide a valid name."
            continue
            ;;
    esac
done

# Main menu loop
while true; do
    show_menu  # Display the menu
    read -p "Enter your choice: " choice  # Prompt user for choice

    case $choice in
        1) # Create Table
            echo "Creating Tables!!"
           
           "$SCRIPT_DIR/CreateTables.sh" "$db_name"

            ;;
        2) # List Tables
            echo "Listing Tables!!"
            "$SCRIPT_DIR/listTables.sh" "$db_name"
            ;;
        3) # Drop Table
            echo "Dropping Tables!!"
            "$SCRIPT_DIR/DropTable.sh" "$db_name"
            ;;
        4) # Insert Data
            echo "Inserting Data into Tables!!"
            "$SCRIPT_DIR/InsertData.sh" "$db_name"
            ;;
        5) # Select From Table
            echo "Selecting Data from Tables!!"
            "$SCRIPT_DIR/SelectFromTable.sh" "$db_name"
            ;;
        6) # Select all From Table
            echo "Selecting all Data from Tables!!"
            "$SCRIPT_DIR/SelectAllFromTable.sh" "$db_name"
            ;;
        7) # Delete From Table
            echo "Deleting Data from Tables!!"
            "$SCRIPT_DIR/DeleteFromTable.sh" "$db_name"
            ;;
        8) # Update Table
            echo "Updating Data in Tables!!"
            "$SCRIPT_DIR/UpdateFromTable.sh" "$db_name"
            ;;
        9) # Exit
            echo "Thank You For Using Our System 😊"
              exit
              ;;
        *) # Handle invalid choices
            echo "Invalid Choice. Please try again."
            ;;
    esac
done

