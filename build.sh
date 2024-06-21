#!/bin/bash

# Function to check if a command was successful
check_command() {
    if [ $? -ne 0 ]; then
        echo "$1 failed. Exiting."
        exit 1
    fi
}

# Set the working directory to /var/www
cd /var/www || { echo "Failed to change directory to /var/www. Exiting."; exit 1; }

# Check if the "artisan" file does not exist in the specified directory
if [ ! -f "/var/www/pterodactyl/artisan" ]; then
    echo "We tried to find your Artisan file but we couldn't. Please move to the directory where you installed the Panel and re-run this script. Have a Good Day!"
    exit 1
else
    echo "Your Artisan File has been found!"
    sleep 2

    echo "Checking if unzip is installed"
    # Attempt to install unzip using apt (for Ubuntu systems)
    apt update -y > /dev/null 2>&1
    check_command "apt update"
    apt install unzip -y > /dev/null 2>&1
    check_command "apt install unzip"

    echo "Backing up previous panel files in case something goes wrong!"
    # Create a backup of the current "public" and "resources" directories
    zip -r /var/www/PterodactylBackup-$(date +"%Y-%m-%d").zip /var/www/pterodactyl/public /var/www/pterodactyl/resources > /dev/null 2>&1
    check_command "Backup"

    echo "Downloading the Theme you picked"
    # Create a temporary directory for downloading the zip file
    mkdir -p /var/www/tempdown && cd /var/www/tempdown || { echo "Failed to create or change to /var/www/tempdown. Exiting."; exit 1; }
    # Download the zip file from the specified URL
    wget https://raw.githubusercontent.com/YUDAMODS/THEME-PANEL/master/pterodactyl.zip -O pterodactyl.zip
    check_command "wget download"
    # Unzip the downloaded file
    unzip pterodactyl.zip > /dev/null 2>&1
    check_command "unzip"

    echo "Copying the extracted files to the /var/www/pterodactyl directory"
    # Copy the extracted files to the necessary location
    cp -r * /var/www/pterodactyl
    check_command "File copy"

    echo "Files have been copied over!"
    sleep 2

    echo "Removing the temp folders created in the copy process"
    # Remove the temporary download directory
    cd /var/www || { echo "Failed to change directory to /var/www. Exiting."; exit 1; }
    rm -rf /var/www/tempdown
    check_command "Remove temp directory"

    echo "Running Artisan commands to clear caches and optimize"
    # Ensure proper permissions and run artisan commands to clear caches and optimize
    cd /var/www/pterodactyl || { echo "Failed to change directory to /var/www/pterodactyl. Exiting."; exit 1; }
    php artisan view:clear
    check_command "php artisan view:clear"
    php artisan config:clear
    check_command "php artisan config:clear"
    php artisan cache:clear
    check_command "php artisan cache:clear"
    php artisan optimize
    check_command "php artisan optimize"

    echo "Theme installation complete! Have a good day and don't forget to refresh your browser cache! (CTRL + F5)"
    echo "-Will"
fi
