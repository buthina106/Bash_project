#!/bin/bash

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
    echo "9. Back to Main Menu"
    echo "----------------------------------------"
}

# Main loop for displaying menu and processing user input
while true; do
    show_menu  # Display the menu
    read -p "Enter your choice: " choice  # Prompt user for choice

    case $choice in
        1) # Create Table
            echo "Creating Tables!!"
            ./CreateTables.sh
            ;;
        2) # List Tables
            echo "Listing Tables!!"
            ./listTables.sh
            ;;
        3) # Drop Table
            echo "Dropping Tables!!"
            ./DropTable.sh
            ;;
        4) # Insert Data
            echo "Inserting Data into Tables!!"
            ./InsertData.sh 
            ;;
        5) # Select From Table
            echo "Selecting Data from Tables!!"
            ./SelectFromTable.sh
            ;;
        6) # Select all From Table
        echo "Selecting all Data from Tables!!"
        ./SelectAllFromTable.sh
            ;;
        7) # Delete From Table
            echo "Deleting Data from Tables!!"
            ./DeleteFromTable.sh
            ;;
        8) # Update Table
            echo "Updating Data in Tables!!"
            ./UpdateFromTable.sh
            ;;
        9) # Back to Main Menu
            echo "Welcome back to Main Menu!! 😍"
            break  # Exit the loop and return to main menu
            ;;
        *) # Handle invalid choices
            echo "Invalid Choice. Please try again."
            ;;
    esac
done


