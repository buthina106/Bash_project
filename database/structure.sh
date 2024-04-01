#!/bin/bash

show_menu() {
    echo "----------------------------------------"
    echo "           Database Menu                "
    echo "----------------------------------------"
    echo "1. Create DB"
    echo "2. List DBs"
    echo "3. Drop DB"
    echo "4. Connect DB"
    echo "5. Exit"
    echo "----------------------------------------"
}

echo "🤩  Welcome To Database Engine! 🤩"
echo



while true; do
show_menu
   read -p "Enter your choice: " choice

    case $choice in
        1)
            echo "Creating Database 🤩"
            if [ -f CreateDB.sh ]; then
                source CreateDB.sh
            else
                echo "Error: CreateDB.sh script not found!"
            fi
            ;;
        2)
            echo "Listing Your Databases 👀"
            if [ -f ListDBs.sh ]; then
                source ListDBs.sh
            else
                echo "Error: ListDBs.sh script not found!"
            fi
            ;;
        3)
            echo "Dropping a Database 😞"
            if [ -f RemoveDB.sh ]; then
                source RemoveDB.sh
            else
                echo "Error: RemoveDB.sh script not found!"
            fi
            ;;
        4)
            echo "Connecting to a Database 💻"
            if [ -f ConnectDB.sh ]; then
                source ConnectDB.sh
            else
                echo "Error: ConnectDB.sh script not found!"
            fi
            ;;
        5)
            echo "Thank You For Using Our System 😊"
            exit
            ;;
        *)
            echo "Invalid Choice: '$choice'. Please select a valid option."
            ;;
    esac
done


